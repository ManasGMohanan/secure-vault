import 'package:flutter/material.dart';

/// Maps brand keys to their local SVG asset paths.
const Map<String, String> logoAssetMap = {
  'google': 'assets/logos/google.svg',
  'github': 'assets/logos/github.svg',
  'apple': 'assets/logos/apple.svg',
  'microsoft': 'assets/logos/microsoft.svg',
  'amazon': 'assets/logos/amazon.svg',
  'netflix': 'assets/logos/netflix.svg',
  'facebook': 'assets/logos/facebook.svg',
  'x': 'assets/logos/x.svg',
  'instagram': 'assets/logos/instagram.svg',
  'linkedin': 'assets/logos/linkedin.svg',
  'udemy': 'assets/logos/udemy.svg',
  'coursera': 'assets/logos/coursera.svg',
  'messenger': 'assets/logos/messenger.svg',
  'gmail': 'assets/logos/gmail.svg',
  'mastercard': 'assets/logos/mastercard.svg',
  'visa': 'assets/logos/visa.svg',
};

/// Maps brand keys to lists of domains.
const Map<String, List<String>> brandDomainsMap = {
  'google': ['google.com'],
  'github': ['github.com'],
  'apple': ['apple.com', 'icloud.com'],
  'microsoft': ['microsoft.com', 'outlook.com', 'office.com', 'live.com'],
  'amazon': ['amazon.com', 'amazon.in', 'amazon.co.uk', 'amazon.ca'],
  'netflix': ['netflix.com'],
  'facebook': ['facebook.com'],
  'x': ['x.com', 'twitter.com'],
  'instagram': ['instagram.com'],
  'linkedin': ['linkedin.com'],
  'udemy': ['udemy.com'],
  'coursera': ['coursera.org', 'coursera.com'],
  'messenger': ['messenger.com'],
  'gmail': ['gmail.com'],
  'mastercard': ['mastercard.com'],
  'visa': ['visa.com'],
};

/// Maps brand keys to lists of title keywords.
const Map<String, List<String>> brandTitleKeywordsMap = {
  'google': ['google'],
  'github': ['github'],
  'apple': ['apple', 'icloud'],
  'microsoft': ['microsoft', 'outlook', 'office', 'xbox'],
  'amazon': ['amazon', 'aws'],
  'netflix': ['netflix'],
  'facebook': ['facebook'],
  'x': ['twitter', 'x'],
  'instagram': ['instagram'],
  'linkedin': ['linkedin'],
  'udemy': ['udemy'],
  'coursera': ['coursera'],
  'messenger': ['messenger'],
  'gmail': ['gmail'],
  'mastercard': ['mastercard', 'master card'],
  'visa': ['visa'],
};

/// Maps custom bank keywords to their official domains.
const Map<String, String> titleToDomainMap = {
  'hdfc': 'hdfcbank.com',
  'sbi': 'sbi.co.in',
  'state bank of india': 'sbi.co.in',
  'canara': 'canarabank.com',
  'rupay': 'rupay.co.in',
};

/// Parses the host domain from scheme-less or fully qualified URLs.
String? getDomainFromUrl(String url) {
  if (url.trim().isEmpty) return null;
  try {
    String formattedUrl = url.trim();
    if (!formattedUrl.contains('://')) {
      formattedUrl = 'https://$formattedUrl';
    }
    final uri = Uri.parse(formattedUrl);
    String host = uri.host.toLowerCase();
    if (host.startsWith('www.')) {
      host = host.substring(4);
    }
    return host.isNotEmpty ? host : null;
  } catch (_) {
    // Basic regex fallback if Uri parsing fails
    final match = RegExp(r'(?:https?:\/\/)?(?:www\.)?([^\/\?#]+)').firstMatch(url);
    if (match != null) {
      String? host = match.group(1)?.toLowerCase();
      if (host != null && host.startsWith('www.')) {
        host = host.substring(4);
      }
      return host;
    }
    return null;
  }
}

/// Resolves the domain from the URL, or falls back to popular title matches if URL is empty.
String? getDomainFromUrlOrTitle(String url, String title) {
  final cleanUrl = url.trim();
  if (cleanUrl.isNotEmpty) {
    return getDomainFromUrl(cleanUrl);
  }
  
  final cleanTitle = title.trim().toLowerCase();
  for (final entry in titleToDomainMap.entries) {
    if (cleanTitle.contains(entry.key)) {
      return entry.value;
    }
  }
  
  return null;
}

/// Checks if the domain or title matches a local SVG logo, returning its path.
String? getLocalSvgPath(String? domain, String title) {
  final cleanTitle = title.trim().toLowerCase();
  final cleanDomain = domain?.trim().toLowerCase() ?? '';

  for (final brand in logoAssetMap.keys) {
    // 1. Check title keywords matching
    final keywords = brandTitleKeywordsMap[brand] ?? [brand];
    if (keywords.any((kw) => cleanTitle.contains(kw))) {
      return logoAssetMap[brand];
    }

    // 2. Check domain matching (using endsWith safely for subdomains)
    if (cleanDomain.isNotEmpty) {
      final domains = brandDomainsMap[brand] ?? [];
      final hasDomainMatch = domains.any((dm) => 
        cleanDomain == dm || cleanDomain.endsWith('.$dm')
      );
      if (hasDomainMatch) {
        return logoAssetMap[brand];
      }
    }
  }

  return null;
}

/// Constructs the Google Favicon API url for fallback remote logos.
String getLogoUrl(String domain) {
  return 'https://www.google.com/s2/favicons?sz=128&domain=$domain';
}

/// Computes a deterministic soft pastel background color based on the title.
Color getBrandColor(String title) {
  if (title.isEmpty) return const Color(0xFF8AB3FF);
  
  // Deterministic hash code from string
  int hash = 0;
  for (int i = 0; i < title.length; i++) {
    hash = title.codeUnitAt(i) + ((hash << 5) - hash);
  }

  final List<Color> pastelColors = [
    const Color(0xFFF28B82), // Soft Red
    const Color(0xFFFBBC04), // Soft Yellow
    const Color(0xFF34A853), // Soft Green
    const Color(0xFF4285F4), // Soft Blue
    const Color(0xFF9C27B0), // Soft Purple
    const Color(0xFFE91E63), // Soft Pink
    const Color(0xFF009688), // Soft Teal
    const Color(0xFFD81B60), // Soft Magenta
    const Color(0xFF3F51B5), // Soft Indigo
    const Color(0xFFFF5722), // Soft Deep Orange
  ];

  final index = hash.abs() % pastelColors.length;
  return pastelColors[index];
}
