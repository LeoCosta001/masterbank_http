class Contact {
  final int id;
  final String accountName;
  final int accountNumber;

  Contact(this.id, this.accountName, this.accountNumber);

  @override
  String toString() {
    return 'Contact{id: $id, accountName: $accountName, accountNumber: $accountNumber}';
  }
}