class Transaction {
  final String id;
  final String title;
  final double value;
  final DateTime date;
  final String category;

  Transaction({
    required this.id,
    required this.title,
    required this.value,
    required this.date,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'value': value,
      'date': date.toIso8601String(),
      'category': category,
    };
  }

  static Transaction fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      value: json['value'],
      date: DateTime.parse(json['date']),
      category: json['category'],
    );
  }
}
