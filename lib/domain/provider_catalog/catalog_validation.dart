abstract final class CatalogValidation {
  static String? requiredText(String? value, String label) =>
      value == null || value.trim().isEmpty ? 'Informe $label.' : null;

  static String? positivePrice(String? value) {
    final normalized = value?.replaceAll(',', '.').trim() ?? '';
    final price = double.tryParse(normalized);
    return price == null || price <= 0
        ? 'Informe um valor maior que zero.'
        : null;
  }

  static String? time(String? value, String label) =>
      minutes(value) == null ? 'Informe $label no formato HH:mm.' : null;

  static String? timeWindow(String start, String end) {
    final startMinutes = minutes(start);
    final endMinutes = minutes(end);
    if (startMinutes == null ||
        endMinutes == null ||
        endMinutes <= startMinutes) {
      return 'O fim deve ser posterior ao início.';
    }
    return null;
  }

  static int? minutes(String? value) {
    final parts = value?.split(':');
    if (parts == null || parts.length != 2) {
      return null;
    }
    final hour = int.tryParse(parts.first);
    final minute = int.tryParse(parts.last);
    if (hour == null ||
        minute == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59) {
      return null;
    }
    return hour * 60 + minute;
  }

  static String adjustTime(String value, int deltaMinutes) {
    final current = minutes(value) ?? 0;
    final adjusted = (current + deltaMinutes).clamp(0, (23 * 60) + 30);
    final hour = adjusted ~/ 60;
    final minute = adjusted % 60;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}
