import 'package:masterbank/database/dao/contact_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  // OBS: O caminho é criando automaticamente pelos pacotes, você só precisa definir i nome do arquivo que irá guardar seu banco de dados... Sempre use a extenção ".db"
  final String path = join(await getDatabasesPath(), 'masterbank.db');
  // Retorna o banco de dados para poder ser usado na aplicação
  return openDatabase(
    path,
    onCreate: (db, version) => {
      // Criando uma tabela no banco de dados local
      db.execute(ContactDao.tableSql)
    },
    // Definindo a versão do banco de dados local
    version: 1,
  );
}
