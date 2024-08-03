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
        'SELECT l.Name, l.Cost, l.Longitude, l.Latitude FROM location l JOIN location_schedule ls ON l.Loc_id = ls.Loc_id WHERE ls.Schedule_id = ( SELECT Schedule_id FROM schedule WHERE User_id = 116);',
        [id]);
    await conn.close();
    return results;
  }
}
