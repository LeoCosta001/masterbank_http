class Contact {
  final int id;
  final String accountName;
  final int accountNumber;

  Contact(this.id, this.accountName, this.accountNumber);

  @override
  String toString() {
    return 'Contact{id: $id, accountName: $accountName, accountNumber: $accountNumber}';
  }

  // Convertendo o JSON para um objeto Dart
  Contact.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        accountName = json['name'],
        accountNumber = json['accountNumber'];

  // Convertendo o objeto Dart para um tipo JSON
  Map<String, dynamic> toJson() => {
        'name': accountName,
        'accountNumber': accountNumber,
      };
}
