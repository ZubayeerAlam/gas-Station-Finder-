/// Small, dependency-free display formatters.
abstract final class Fmt {
  static String distance(double meters) {
    if (meters < 1000) return '${meters.round()} m';
    final km = meters / 1000;
    return '${km.toStringAsFixed(km < 10 ? 1 : 0)} km';
  }

  static String duration(Duration d) {
    if (d.inMinutes < 1) return '< 1 min';
    if (d.inHours == 0) return '${d.inMinutes} min';
    final m = d.inMinutes.remainder(60);
    return m == 0 ? '${d.inHours} h' : '${d.inHours} h $m min';
  }

  /// Fuel prices often have 3 decimals (e.g. 1.789); keep up to 3, trim zeros.
  static String price(double amount, String currencyCode) {
    var s = amount.toStringAsFixed(3);
    while (s.endsWith('0') && s.split('.').last.length > 2) {
      s = s.substring(0, s.length - 1);
    }
    return '$currencyCode $s';
  }

  static String relativeTime(DateTime time, {DateTime? now}) {
    final diff = (now ?? DateTime.now()).difference(time);
    if (diff.isNegative || diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes} min ago';
    if (diff.inDays < 1) return '${diff.inHours} h ago';
    if (diff.inDays < 30) return '${diff.inDays} d ago';
    return '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}';
  }
}
