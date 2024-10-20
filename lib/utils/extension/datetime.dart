extension DateTimeOrderId on DateTime {
  // Method to generate an order ID from the DateTime instance
  String toOrderId() {
    return '$year${_twoDigits(month)}${_twoDigits(day)}${_twoDigits(hour)}${_twoDigits(minute)}${_twoDigits(second)}$millisecond';
  }

  // Helper function to ensure two-digit formatting
  String _twoDigits(int n) {
    return n >= 10 ? '$n' : '0$n';
  }
}
