import 'dart:async';
import 'dart:js_interop';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:web/web.dart' as web;

// Keep a long-lived BroadcastChannel instance to respond to pings from future tabs.
web.BroadcastChannel? _sessionChannel;

Future<void> initializeWebSessionWipe(String boxName) async {
  try {
    final storage = web.window.sessionStorage;
    final active = storage.getItem('secure_vault_session_active');
    
    // 1. Check Signal A: sessionStorage (same-tab refresh)
    if (active != null) {
      debugPrint('[WEB_SECURITY] Page refresh in same tab detected. Skipping IndexedDB wipe.');
      // Initialize the channel for answering other tabs
      _sessionChannel = web.BroadcastChannel('secure_vault_tabs');
      _sessionChannel!.onmessage = (web.MessageEvent event) {
        final msg = event.data.toString();
        debugPrint('[WEB_SECURITY] Received BroadcastChannel message: $msg');
        if (msg == 'ping') {
          _sessionChannel?.postMessage('pong'.toJS);
        }
      }.toJS;
      return;
    }

    // Add random jitter of 0-50ms to prevent concurrent collision of pings
    final random = Random();
    final jitter = random.nextInt(50);
    await Future.delayed(Duration(milliseconds: jitter));

    // 2. Check Signal B: BroadcastChannel (other active tabs)
    final tempChannel = web.BroadcastChannel('secure_vault_tabs');
    bool hasOtherActiveTabs = false;

    tempChannel.onmessage = (web.MessageEvent event) {
      final msg = event.data.toString();
      debugPrint('[WEB_SECURITY] Discovery phase - received message: $msg');
      if (msg == 'pong') {
        hasOtherActiveTabs = true;
      }
    }.toJS;

    // Broadcast ping
    tempChannel.postMessage('ping'.toJS);

    // Wait 150ms for replies
    await Future.delayed(const Duration(milliseconds: 150));

    // Close the temporary discovery listener channel
    tempChannel.close();

    if (!hasOtherActiveTabs) {
      debugPrint('[WEB_SECURITY] No other active tabs detected. Wiping stale IndexedDB box.');
      try {
        await Hive.deleteBoxFromDisk(boxName);
      } catch (e) {
        debugPrint('[WEB_SECURITY] Hive.deleteBoxFromDisk failed (safe caught): $e');
      }
      storage.setItem('secure_vault_session_active', 'true');
    } else {
      debugPrint('[WEB_SECURITY] Other active tabs detected. Skipping IndexedDB wipe to prevent corruption.');
      storage.setItem('secure_vault_session_active', 'true');
    }

    // Initialize the long-lived channel to respond to future tabs pings
    _sessionChannel = web.BroadcastChannel('secure_vault_tabs');
    _sessionChannel!.onmessage = (web.MessageEvent event) {
      final msg = event.data.toString();
      debugPrint('[WEB_SECURITY] Long-lived responder - received message: $msg');
      if (msg == 'ping') {
        _sessionChannel?.postMessage('pong'.toJS);
      }
    }.toJS;

  } catch (e) {
    debugPrint('[WEB_SECURITY] Failed to initialize session check: $e');
  }
}

void clearWebSession() {
  try {
    web.window.sessionStorage.removeItem('secure_vault_session_active');
    debugPrint('[WEB_SECURITY] Web session storage flag cleared.');
  } catch (_) {}
}
