import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/User.dart';

class DBHelper {
  late Database db;

  String encrpytPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}lsp_mobile.db';
    var itemDatabase = openDatabase(path, version: 1, onCreate: _createDb);
    return itemDatabase;
  }

  // Create DB users
  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT,
      nama TEXT,
      password TEXT,
      nomorHP TEXT
      )
    ''');
  }

  // Register
  Future<bool> registerUser(User user) async {
    Database db = await initDb();
    user.password = encrpytPassword(user.password!);
    try {
      await db.insert(
        'users',
        user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // Authentication User
  Future<bool> authUser(String username, String password) async {
    db = await initDb();
    password = encrpytPassword(password);
    var result = await db.rawQuery('''
      SELECT * FROM users WHERE username = '$username' AND password = '$password'
    ''');
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  // Fetch User
  Future<User> fetchUser(String username, password) async {
    db = await initDb();
    password = encrpytPassword(password);
    var result = await db.rawQuery('''
      SELECT * FROM users WHERE username = '$username' AND password = '$password'
    ''');
    if (result.isNotEmpty) {
      return User.fromJson(result.first);
    } else {
      return User();
    }
  }

  //Update Password
  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    db = await initDb();
    var result = await db.rawQuery(
        'SELECT * FROM users WHERE username = "user" AND password = "$oldPassword"');
    if (result.isNotEmpty) {
      await db.rawUpdate(
          'UPDATE users SET password = "$newPassword" WHERE username = "user"');
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateUser(User user) async {
    db = await initDb();
    try {
      await db.rawUpdate(
          'UPDATE users SET username = "${user.username}", nama = "${user.nama}", nomorHp = "${user.nomorHP}" WHERE id = ${user.id}');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future close() async {
    Database db = await initDb();
    db.close();
  }
}
