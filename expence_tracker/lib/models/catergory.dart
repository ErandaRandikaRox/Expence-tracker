import 'package:expense_tracker/models/expence.dart';

enum Catergory {
  all,
  grocery,
  food,
  work,
  entertainment,
  travelling,
  other;

  String toJson() => name;
  static Catergory fromJson(String json) => values.byName(json);
}

extension Categoryx on Catergory {
  String get toName => switch (this) {
        Catergory.all => 'All',
        Catergory.grocery => 'Grocery',
        Catergory.food => 'Food',
        Catergory.work => 'Work',
        Catergory.entertainment => 'Entertainment',
        Catergory.travelling => 'Travelling',
        Catergory.other => 'Other',
      };

  bool apply(Expence? expence) => switch (this) {
        Catergory.all => true,
        Catergory.grocery => expence?.catergory == Catergory.grocery,
        Catergory.food => expence?.catergory == Catergory.food,
        Catergory.work => expence?.catergory == Catergory.work,
        Catergory.entertainment => expence?.catergory == Catergory.entertainment,
        Catergory.travelling => expence?.catergory == Catergory.travelling,
        Catergory.other => expence?.catergory == Catergory.other,
      };

  Iterable<Expence> applyAll(Iterable<Expence> expence) {
    return expence.where(apply);
  }
}