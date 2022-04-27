import 'package:masterbank/database/app_database.dart';
import 'package:masterbank/models/contact.dart';
import 'package:sqflite/sqflite.dart';

class ContactDao {
  static const String _tableName = 'contacts';
  static const String _id = 'id';
  static const String _accountName = 'account_name';
  static const String _accountNumber = 'account_number';
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_accountName TEXT, '
      '$_accountNumber INTEGER)';

  Future<int> save(Contact contact) async {
    final Database db = await getDatabase();
    // Mapa para definir os valores que seram guardados no banco de dados local
    Map<String, dynamic> contactMap = _toMap(contact);
    // Inserir valores na tabela "contacts"
    return db.insert(_tableName, contactMap);
  }

  Future<List<Contact>> findAll() async {
    final Database db = await getDatabase();
    // Busca todos os dados da tabela "contacts"
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Contact> contacts = _toList(result);

    return contacts;
  }

  Map<String, dynamic> _toMap(Contact contact) {
    final Map<String, dynamic> contactMap = {};
    // O campo "id" foi omitido pois o sqlite irá gerar números inteiros random para ele já que é a chave primária
    contactMap[_accountName] = contact.accountName;
    contactMap[_accountNumber] = contact.accountNumber;
    return contactMap;
  }

  List<Contact> _toList(List<Map<String, dynamic>> result) {
    final List<Contact> contacts = [];
    for (Map<String, dynamic> resultValue in result) {
      final Contact contact = Contact(
        resultValue[_id],
        resultValue[_accountName],
        resultValue[_accountNumber],
      );
      contacts.add(contact);
    }
    return contacts;
  }
}
