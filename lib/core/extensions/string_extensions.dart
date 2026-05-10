extension StringExtensions on String {
  bool get isDigitsOnly => RegExp(r'^\d+$').hasMatch(this);

  bool get isValidMobile => isDigitsOnly && length == 10;

  String get maskedMobile {
    if (length < 4) return this;
    return '${substring(0, 2)}${'X' * (length - 4)}${substring(length - 2)}';
  }

  String get titleCase => split(' ')
      .map(
        (w) => w.isEmpty
            ? w
            : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}',
      )
      .join(' ');

  bool get isNullOrEmpty => isEmpty;
}

extension NullableStringExtensions on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}
