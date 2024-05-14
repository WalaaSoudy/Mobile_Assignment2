import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'your_database.db');

    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
  await db.execute('''
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      email TEXT UNIQUE,
      password TEXT,
      gender TEXT,
      student_id TEXT,
      level INTEGER,
      imagePath TEXT  
    )
  ''');

  await db.execute('''
    CREATE TABLE IF NOT EXISTS favorite_stores (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      store_name TEXT,
      store_location TEXT,
      FOREIGN KEY (user_id) REFERENCES users(id)
    )
  ''');
}
Future<void> insertFavoriteStore(String userEmail, String storeName, String storeLocation, double latitude, double longitude) async {
  try {
    Database db = await database;
    await db.insert(
      'favorite_stores',
      {
        'user_email': userEmail,
        'store_name': storeName,
        'store_location': storeLocation,
        'latitude': latitude,
        'longitude': longitude,
      },
    );
    print('Favorite store inserted successfully');
  } catch (e) {
    print('Error inserting favorite store: $e');
  }
}
Future<List<Map<String, dynamic>>> getFavoriteStoresByUserEmail(String email) async {
  try {
    Database db = await database;
    List<Map<String, dynamic>> favoriteStores = await db.rawQuery('''
      SELECT favorite_stores.*
      FROM favorite_stores
      INNER JOIN users ON favorite_stores.user_id = users.id
      WHERE users.email = ?
    ''', [email]);
    print('Favorite stores retrieved successfully for user with email $email');
    return favoriteStores;
  } catch (e) {
    print('Error retrieving favorite stores: $e');
    return [];
  }
}



  Future<int> insertUser(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('users', row);
  }
Future<Map<String, dynamic>> getUserByEmail(String email) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.query('users', where: 'email = ?', whereArgs: [email]);
      if (result.isNotEmpty) {
        return result.first;
      }
      return {};
    } catch (e) {
      print('Error fetching user by email from database: $e');
      return {};
    }
  }
  // Check if email exists in the database
  Future<bool> isEmailExists(String email) async {
    Map<String, dynamic> user = await getUserByEmail(email);
    return user.isNotEmpty;
  }

  // Check if student ID exists in the database
  Future<bool> isStudentIdExists(String studentId) async {
    Map<String, dynamic> user = await getUserByStudentId(studentId);
    return user.isNotEmpty;
  }

  Future<Map<String, dynamic>> getUserByStudentId(String studentId) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.query('users', where: 'student_id = ?', whereArgs: [studentId]);
      if (result.isNotEmpty) {
        return result.first;
      }
      return {};
    } catch (e) {
      print('Error fetching user by student ID from database: $e');
      return {};
    }
  }
  Future<Map<String, dynamic>> getUserByEmailAndPassword(String email, String password) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.query('users', where: 'email = ? AND password = ?', whereArgs: [email, password]);
      if (result.isNotEmpty) {
        return result.first;
      }
      return {};
    } catch (e) {
      print('Error fetching user from database: $e');
      return {};
    }
  }

  Future<String?> getUserProfileImage(int userId) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.query(
        'users',
        columns: ['imagePath'],
        where: 'id = ?',
        whereArgs: [userId],
      );
      if (result.isNotEmpty) {
        return result.first['imagePath'] as String?;
      }
      return null;
    } catch (e) {
      print('Error fetching user profile image from database: $e');
      return null;
    }
  }

 Future<void> updateUser(String userEmail, String name, String password) async {
  Database db = await database;
  await db.rawUpdate(
    'UPDATE users SET name = ?, password = ? WHERE email = ?',
    [name, password, userEmail],
  );
  print('User profile updated successfully');
}


  Future<void> updateUserProfileImage(int userId, String imagePath) async {
    try {
      Database db = await database;
      await db.rawUpdate(
        'UPDATE users SET imagePath = ? WHERE id = ?',
        [imagePath, userId],
      );
      print('User profile image updated successfully');
    } catch (e) {
      print('Error updating user profile image: $e');
    }
  }

  Future<String?> getUserImagePath(int userId) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query('users', columns: ['imagePath'], where: 'id = ?', whereArgs: [userId]);
    if (result.isNotEmpty) {
      String? imagePath = result.first['imagePath'] as String?;
      print('Image path retrieved for user $userId: $imagePath');
      return imagePath;
    }
    return null;
  }

  Future<void> updateUserProfile(int userId, String name, String password, String imagePath) async {
    Database db = await database;
    await db.rawUpdate(
      'UPDATE users SET name = ?, password = ?, imagePath = ? WHERE id = ?',
      [name, password, imagePath, userId],
    );
    print('Profile updated for user $userId');
  }

  Future<Map<String, dynamic>> getUserById(int userId) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.query('users', where: 'id = ?', whereArgs: [userId]);
      if (result.isNotEmpty) {
        return result.first;
      }
      return {};
    } catch (e) {
      print('Error fetching user from database: $e');
      return {};
    }
  }

  Future<int> insertImage(String imagePath) async {
    Database db = await database;
    Map<String, dynamic> row = {'imagePath': imagePath};
    return await db.insert('users', row);
  }

  Future<List<Map<String, dynamic>>> getAllImages() async {
    Database db = await database;
    return await db.query('users', columns: ['imagePath']);
  }

  Future<String?> getUserProfileImageByEmail(String email) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.query(
        'users',
        columns: ['imagePath'],
        where: 'email = ?',
        whereArgs: [email],
      );
      if (result.isNotEmpty) {
        return result.first['imagePath'] as String?;
      }
      return null;
    } catch (e) {
      print('Error fetching user profile image from database: $e');
      return null;
    }
  }
}
