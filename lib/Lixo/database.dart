import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:mysql_client/mysql_client.dart';

import '../model/Pessoa.dart';

Future<MySQLConnection> createConnection() async {
  final conn = await MySQLConnection.createConnection(
    host: '10.0.2.2',
    port: 3306,
    userName: "root",

    password: 'password',
    databaseName: 'database_f', // optional
  );

  try {
    await conn.connect();
    print("Connected");
  } catch (e) {
    print('Erro: $e');
  }
  return conn;
}

Future<void> createTables() async {
  final conn = await MySQLConnection.createConnection(
    host: '10.0.2.2',
    port: 3306,
    userName: "root",
    password: 'password',
    databaseName: 'database_f', // optional
  );
  await conn.connect();
  print("Connected");
  try {
    await conn.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INT PRIMARY KEY AUTO_INCREMENT,
        name VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL,
        password VARCHAR(255) NOT NULL
      )
    ''');

    print('Tabelas criadas com sucesso!');
  } catch (e) {
    print('Erro ao criar tabelas: $e');
  }

  await conn.close();
}

Future<void> registerUser(String name, String email, String password) async {
  final conn = await createConnection();
  try {
    await conn.execute(
      'INSERT INTO users (name, email, password) VALUES (:name, :email, :password)',
      {'name': name, 'email': email, 'password': password},
    );
    print('Usuário registrado com sucesso!');
  } catch (e) {
    print('Erro ao registrar usuário: $e');
  }

  await conn.close();
}

Future<Database> createDatabase() async {
  final databasesPath = await getDatabasesPath();
  final path = join(databasesPath, 'database.db');

  final database = await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS user (
        id INTEGER PRIMARY KEY,
        email TEXT,
        senha TEXT
      )
    ''');
    },
  );

  // ignore: avoid_print
  print('Bancos:${database.isOpen}');
  return database;
}

Future<void> insertContato(User user) async {
  final db = await createDatabase();
  final tableExists = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='user'");
  if (tableExists.isEmpty) {
    await db.execute(
        'CREATE TABLE user(id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, senha TEXT)');
  }
  await db.insert('user', user.toMap());
}


// Função para buscar todos os contatos do banco de dados
Future<List<User>> getUserMySql() async {
  final conn = await createConnection();
  var result = await conn.execute("SELECT * FROM users");

  // print some result data
  print(result.numOfColumns);
  print(result.numOfRows);
  print(result.lastInsertID);
  print(result.affectedRows);
  List<Map<String, String>> listaDados = [];

  for (final row in result.rows) {
    // print(row.colAt(0));
    // print(row.colByName("title"));
    final data = {
      'id': row.colAt(0) ?? "",
      'name': row.colAt(1) ?? "",
      'email': row.colAt(2) ?? "",
      'password': row.colAt(3) ?? "",
    };
    listaDados.add(data);

    print(row.assoc());
  }
  List<User> listaUsers = listaDados.map((map) {
    return User(
      id: int.parse(map['id']!),
      name: map['name']!,
      email: map['email']!,
      password: map['password']!,
    );
  }).toList();
  print(listaDados);
  result.rowsStream.listen((row) {
    print(row.assoc());
  });
  return listaUsers;
}

Future<bool?> loginUser(String email, String password) async {
  final conn = await createConnection();

  try {
    final results = await conn.execute(
      'SELECT * FROM users WHERE email = :email AND password = :password',
      {'email': email, 'password': password},
    );
    List<Map<String, String>> listaDados = [];

    for (final row in results.rows) {
      // print(row.colAt(0));
      // print(row.colByName("title"));
      final data = {
        'id': row.colAt(0) ?? "",
        'name': row.colAt(1) ?? "",
        'email': row.colAt(2) ?? "",
        'password': row.colAt(3) ?? "",
      };
      listaDados.add(data);

      print(row.assoc());
    }
    List<User> listaUsers = listaDados.map((map) {
      return User(
        id: int.parse(map['id']!),
        name: map['name']!,
        email: map['email']!,
        password: map['password']!,
      );
    }).toList();
    print(listaDados);
    if (listaUsers.isEmpty) {
      return false;
    }
    if (listaUsers.isNotEmpty) {
      return true;
    }
    return true;
  } catch (e) {
    print('Erro ao realizar o login: $e');
    return false;
  } finally {
    await conn.close();
  }
}

Future<void> delete(int id) async {
  final conn = await createConnection();
  var result =
      await conn.execute("DELETE FROM users WHERE id = :id", {'id': id});
  print(result);
  print('delete');
}


// Classe para representar um user

