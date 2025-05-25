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
    // TODO: Handle this case.
    Catergory.all => true,
    // TODO: Handle this case.
    Catergory.grocery => expence?.catergory == Catergory.grocery,
    // TODO: Handle this case.
    Catergory.food => expence?.catergory == Catergory.food,
    // TODO: Handle this case.
    Catergory.work => expence?.catergory == Catergory.work,
    // TODO: Handle this case.
    Catergory.entertainment => expence?.catergory == Catergory.entertainment,
    // TODO: Handle this case.
    Catergory.travelling => expence?.catergory == Catergory.travelling,
    // TODO: Handle this case.
    Catergory.other => expence?.catergory == Catergory.other,
  };

  Iterable<Expence?> appAll(Iterable<Expence?> expence) {
    return expence.where(apply);
  }
}
