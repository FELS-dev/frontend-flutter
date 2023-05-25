// DatabaseHelper.dart
import 'dart:io';
import 'package:front_end/models/visitor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../models/choice.dart';
import '../models/stand.dart';
import '../models/treasure_hunt.dart';
import '../models/user_treasure_hunt_progress.dart';

class DatabaseHelper {
  static const _databaseName = "EventDatabase.db";
  static const _databaseVersion = 2;

  static const tableVisitor = 'visitor';
  static const tableDigitalPasses = 'digital_passes';
  static const tableCVSubmissions = 'cv_submissions';
  static const tableStands = 'stands';
  static const tableTreasureHunt = 'treasure_hunt';
  static const tableTreasureHuntChoices = 'treasure_hunt_choices';
  static const tableUserTreasureHuntProgress = 'user_treasure_hunt_progress';
  static const tableStandsTreasureHunts = 'stands_treasure_hunts';
  final String treasureHuntTable = 'treasure_hunt';
  final String choiceTable = 'treasure_hunt_choices';
  final String standTable = 'stands';
  final String visitorTable = 'visitor';

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> deleteDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _databaseName);
    print(path);
    // Close the database
    if (_database != null) {
      await _database!.close();
      _database = null;
    }

    // Make sure the directory exists
    try {
      await Directory(dirname(path)).delete(recursive: true);
    } catch (_) {}

    // Try deleting the file, will throw an error if the file doesn't exist
    try {
      await File(path).delete();
    } catch (_) {}
  }

  // Open the database and store the reference.
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database tables.
  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableVisitor (
      id INTEGER PRIMARY KEY,
      firstName TEXT,
      lastName TEXT,
      email TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE $tableDigitalPasses (
      id INTEGER PRIMARY KEY,
      visitor_id INTEGER,
      qr_code TEXT,
      FOREIGN KEY (visitor_id) REFERENCES $tableVisitor (id)
    )
    ''');

    await db.execute('''
    CREATE TABLE $tableCVSubmissions (
      id INTEGER PRIMARY KEY,
      visitor_id INTEGER,
      stand_id INTEGER,
      cv_file TEXT,
      submitted_at TEXT,
      FOREIGN KEY (visitor_id) REFERENCES $tableVisitor (id),
      FOREIGN KEY (stand_id) REFERENCES $tableStands (id)
    )
    ''');

    await db.execute('''
    CREATE TABLE $tableStands (
      id INTEGER PRIMARY KEY,
      name TEXT,
      description TEXT,
      location_x REAL,
      location_y REAL,
      qr_code TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE $tableTreasureHunt (
      id INTEGER PRIMARY KEY,
      question TEXT,
      stand_id INTEGER,
      FOREIGN KEY (stand_id) REFERENCES $tableStands (id)
    )
    ''');

    await db.execute('''
    CREATE TABLE $tableTreasureHuntChoices (
      id INTEGER PRIMARY KEY,
      hunt_id INTEGER,
      choice TEXT,
      is_correct INTEGER,
      FOREIGN KEY (hunt_id) REFERENCES $tableTreasureHunt (id)
    )
    ''');

    await db.execute('''
    CREATE TABLE $tableUserTreasureHuntProgress (
      id INTEGER PRIMARY KEY,
      visitor_id INTEGER,
      hunt_id INTEGER,
      choice_id INTEGER,
      is_completed INTEGER,
      FOREIGN KEY (visitor_id) REFERENCES $tableVisitor (id),
      FOREIGN KEY (hunt_id) REFERENCES $tableTreasureHunt (id),
      FOREIGN KEY (choice_id) REFERENCES $tableTreasureHuntChoices (id)
    )
    ''');

    await db.execute('''
    CREATE TABLE $tableStandsTreasureHunts (
      id INTEGER PRIMARY KEY,
      stand_id INTEGER,
      treasure_hunt_id INTEGER,
      FOREIGN KEY (stand_id) REFERENCES $tableStands (id),
      FOREIGN KEY (treasure_hunt_id) REFERENCES $tableTreasureHunt (id)
    )
    ''');
  }

  // insert Treasure Hunt into the database
  Future<int> insertTreasureHunt(TreasureHunt treasureHunt) async {
    Database db = await instance.database;
    return await db.insert(treasureHuntTable, treasureHunt.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // insert Choice into the database
  Future<int> insertChoice(Choice choice) async {
    Database db = await instance.database;
    return await db.insert(choiceTable, choice.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // get Treasure Hunts from the database
  Future<List<TreasureHunt>> getTreasureHunts() async {
    Database db = await instance.database;
    var treasureHunts = await db.query(treasureHuntTable);
    List<TreasureHunt> treasureHuntList = treasureHunts.isNotEmpty
        ? treasureHunts.map((c) => TreasureHunt.fromJson(c)).toList()
        : [];
    return treasureHuntList;
  }

  // get Choices from the database
  Future<List<Choice>> getChoices() async {
    Database db = await instance.database;
    var choices = await db.query(choiceTable);
    List<Choice> choiceList = choices.isNotEmpty
        ? choices.map((c) => Choice.fromJson(c)).toList()
        : [];
    return choiceList;
  }

  // get Treasure Hunts for a specific stand from the database
  Future<List<TreasureHunt>> getTreasureHuntsByStandId(int id) async {
    final db = await database;
    var result = await db.query(treasureHuntTable, where: 'stand_id = ?', whereArgs: [id]);
    List<TreasureHunt> treasureHunts = result.isNotEmpty
        ? result.map((item) => TreasureHunt.fromJson(item)).toList()
        : [];
    return treasureHunts;
  }
  // get Choices for a specific Treasure Hunt from the database
  Future<List<Choice>> getChoicesByHuntId(int huntId) async {
    Database db = await instance.database;
    var choices = await db.query(choiceTable, where: 'hunt_id = ?', whereArgs: [huntId]);
    List<Choice> choiceList = choices.isNotEmpty
        ? choices.map((c) => Choice.fromJson(c)).toList()
        : [];
    return choiceList;
  }

  // Insert or replace stand in the database
  Future<int> insertStand(Stand stand) async {
    Database db = await instance.database;
    var result = await db.insert(
      standTable,
      stand.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<int> insertVisitor(Visitor visitor) async {
    Database db = await instance.database;
    var result = await db.insert(
      visitorTable,
      visitor.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<bool> visitorExists() async {
    Database db = await instance.database;

    // Perform a query on the database
    List<Map> result = await db.query(visitorTable);

    // If the table is not empty, return true
    if (result.isNotEmpty) {
      return true;
    }

    // If the table is empty, return false
    return false;
  }

  Future<List<Stand>> getStands() async {
    Database db = await instance.database;

    List<Map> maps = await db.query(standTable);

    return List.generate(maps.length, (i) {
      return Stand.fromJson(maps[i] as Map<String, dynamic>);
    });
  }
  Future<void> addProgress(UserTreasureHuntProgress progress) async {
    final db = await database;
    await db.insert(
      'user_treasure_hunt_progress',
      {
        'progress_id': progress.progressId,
        'visitor_id': progress.visitorId,
        'hunt_id': progress.huntId,
        'choice_id': progress.choiceId,
        'is_completed': (progress.isCompleted ?? false) ? 1 : 0
      },
    );
  }
}

