String formatNumber(double number) {
  if (number.abs() < 1e-4 || number.abs() > 1e4) {
    String scientific = number.toStringAsExponential(4);
    List<String> parts = scientific.split('e');
    String base = parts[0];
    String exponent = parts[1];


    return base + r" \times 10^{" + exponent + r"}";
  } else {
    return number.toStringAsFixed(4).replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
  }
}
