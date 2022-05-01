import 'package:masterbank/models/contact.dart';

class Transaction {
  final double value;
  final Contact contact;

  Transaction(this.value, this.contact);

  @override
  String toString() {
    return 'Transaction{value: $value, contact: $contact}';
  }

  // Convertendo o JSON para um objeto Dart
  Transaction.fromJson(Map<String, dynamic> json)
      : value = json['value'],
        contact = Contact.fromJson(json['contact']);

  // Convertendo o objeto Dart para um tipo JSON
  Map<String, dynamic> toJson() => {
        'value': value,
        'contact': contact.toJson(),
      };
}
