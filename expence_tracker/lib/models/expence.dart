import 'package:equatable/equatable.dart';
import 'package:expense_tracker/models/catergory.dart';

class Expence extends Equatable {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Catergory catergory;

  const Expence({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.catergory,
  });

  @override
  List<Object> get props => [id, title, amount, date, catergory];

  factory Expence.fromJson(Map<String, dynamic> json) {
    return Expence(
      id: json['id'] as String,
      title: json['name'] as String,
      amount: double.parse(json['amount'] as String),
      date: DateTime.fromMicrosecondsSinceEpoch(json['date'] as int),
      catergory: Catergory.fromJson(json['catergory'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': title,
      'amount': amount.toString(), // Ensure string for JSON
      'date': date.microsecondsSinceEpoch,
      'catergory': catergory.toJson(),
    };
  }

  Expence copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    Catergory? catergory,
  }) {
    return Expence(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      catergory: catergory ?? this.catergory,
    );
  }
}