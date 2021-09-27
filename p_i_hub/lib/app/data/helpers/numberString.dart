String KFormatNumber(int n) {
  if (n > 9999)
    return '${(n / 1000).floor().toStringAsFixed(1)} K+';
  else if (n > 99999)
    return '${(n / 100000).floor().toStringAsFixed(1)} L+';
  else if (n > 9999999)
    return '${(n / 10000000).floor().toStringAsFixed(2)} Cr+';
  else if (n > 10000000000)
    return '${(n / 10000000000).floor().toStringAsFixed(2)} B+';
  return n.toString();
}
