import 'package:mysql1/mysql1.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DBService {
  Future<MySqlConnection> openConnection() async {
    var settings = ConnectionSettings(
      host: 'rm-zf8e67a77o9ujad37yo.mysql.kualalumpur.rds.aliyuncs.com',
      port: 3306,
      user: 'db_acc',
      password: 'Hack1234',
      db: 'db',
    );

    return await MySqlConnection.connect(settings);
  }

  Future<int> authenticateUser(String email, String password) async {
    var conn = await openConnection();
    var results = await conn
        .query('SELECT id, password FROM users WHERE email = ?', [email]);

    await conn.close();

    if (results.isEmpty) {
      return 0;
    }

    var hashedPassword = results.first['password'];
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);

    if (digest.toString() == hashedPassword) {
      print(results.first['id']);
      return results.first['id'];
    } else {
      return 0;
    }
  }

  Future<void> registerUser(
      String username, String email, String password) async {
    var conn = await openConnection();

    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);

    await conn.query(
        'INSERT INTO users (username, email, password) VALUES (?, ?, ?)',
        [username, email, digest.toString()]);

    await conn.close();
  }

  Future<Results> fetchData() async {
    var conn = await openConnection();
    var results = await conn.query('SELECT * FROM users');
    await conn.close();
    return results;
  }

  Future<List<int>> fetchLocation(List<String> selectedTags) async {
    var conn = await openConnection();

    // Construct the SQL query with placeholders
    final sql = '''
    SELECT DISTINCT Loc_id
    FROM location_tag
    WHERE tag IN (${List.filled(selectedTags.length, '?').join(', ')})
  ''';

    // Execute the query with the selected tags
    var results = await conn.query(sql, selectedTags);

    // Extract the location IDs from the results
    List<int> locationIds = results.map((row) => row[0] as int).toList();

    await conn.close();
    return locationIds;
  }

  Future<void> addScheduleAndLocations(List<int> locationIds) async {
    final conn = await openConnection();

    try {
      // Start a transaction
      await conn.transaction((transaction) async {
        // Insert a new record into the schedule table
        var result = await transaction.query(
          'INSERT INTO schedule (User_id) VALUES (?)',
          [1], // Set User_id to 1
        );

        // Retrieve the auto-incremented Schedule_id
        int? newScheduleId = result.insertId;

        // Insert records into the location_schedule table
        for (int locId in locationIds) {
          await transaction.query(
            'INSERT INTO location_schedule (Loc_id, Schedule_id) VALUES (?, ?)',
            [locId, newScheduleId],
          );
        }
      });

      print('Schedule and locations added successfully.');
    } catch (e) {
      print('Error: $e');
    } finally {
      await conn.close();
    }
  }

  Future<Results> fetchTag() async {
    var conn = await openConnection();
    var results = await conn.query('SELECT * FROM tag');
    await conn.close();
    return results;
  }

  Future<Results> fetchSchedule(int id) async {
    var conn = await openConnection();
    var results = await conn.query(
        'SELECT l.Name, l.Cost, l.Longitude, l.Latitude, l.Loc_id, ls.Schedule_id FROM location l JOIN location_schedule ls ON l.Loc_id = ls.Loc_id WHERE ls.Schedule_id = 1;');
    await conn.close();
    return results;
  }

  Future<Results> fetchDescription(int Loc_id) async {
    var conn = await openConnection();
    var results = await conn.query(
        'SELECT Name, Description, Cost, Review, start_time, end_time, Loc_id FROM location WHERE Loc_id = ?',
        [Loc_id]);
    await conn.close();
    return results;
  }

  Future<Results> deleteLocation(int Loc_id, int Schedule_id) async {
    var conn = await openConnection();
    var results = await conn.query(
        'DELETE FROM location_schedule WHERE Loc_id = ? AND Schedule_id = ?',
        [Loc_id, Schedule_id]);
    await conn.close();
    return results;
  }

  Future<Results> addLocation(int Loc_id, int Schedule_id) async {
    var conn = await openConnection();
    var results = await conn.query(
        'INSERT INTO location_schedule VALUES (?, ?, 1)',
        [Loc_id, Schedule_id]);
    await conn.close();
    return results;
  }

  Future<Results> replanning(int Schedule_id) async {
    var conn = await openConnection();
    List<int> idAdded = List.generate(18, (index) => index + 1);
    var results = await conn.query(
        'SELECT Loc_id FROM location_schedule WHERE Schedule_id = ?',
        [Schedule_id]);
    List<int> takenBackList = [];
    for (var row in results) {
      takenBackList.add(row['Loc_id'] as int);
    }


    // Produce a list of integers in idAdded but not in takenBackList
    List<int> availableList = idAdded.where((id) => !takenBackList.contains(id)).toList();

    int deleteAndAdded = takenBackList.length - 3;
    var results2 = await conn.query(
        'DELETE FROM location_schedule WHERE Schedule_id = ? AND Loc_id IN (?, ?, ?, ?)',
        [Schedule_id, takenBackList[3], takenBackList[4], takenBackList[5], takenBackList[6]]);

    for(int i = 0; i<4 ; i++){
      var results3 = await conn.query(
          'INSERT INTO location_schedule VALUES(?, ?, 1)',
          [ availableList[i], Schedule_id]);
    }

    await conn.close();

    return results;
  }
}
