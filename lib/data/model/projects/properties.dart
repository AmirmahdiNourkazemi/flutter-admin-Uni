class Property {
  final String? key;
  final String? value;

  Property({
    this.key,
    this.value,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      key: json['key'],
      value: json['value'],
    );
  }
}