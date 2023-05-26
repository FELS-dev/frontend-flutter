import 'dart:convert';
import 'package:http/http.dart';
import 'package:sqflite/sqflite.dart';
import '../models/choice.dart';
import '../models/stand.dart';
import '../models/treasure_hunt.dart';
import '../models/visitor.dart';
import '../database/database_helper.dart';

class ApiService {
  final String _baseUrl = "http://10.0.2.2:3000";
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<List<Stand>> getStands() async {
    Client client = Client();
    var url = Uri.parse('$_baseUrl/stands');
    try {
      var response = await client.get(url);

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)['data']['stands'];
        List<Stand> standsList =
            jsonResponse.map((item) => Stand.fromJson(item)).toList();

        // Insert or update stands in the local database
        for (Stand stand in standsList) {
          await _databaseHelper.insertStand(stand);
        }

        // Get treasure hunts and choices
        for (var item in jsonResponse) {
          if (item['treasure_hunt'] != null) {
            for (var hunt in item['treasure_hunt']) {
              TreasureHunt treasureHunt = TreasureHunt.fromJson(hunt);
              treasureHunt.standId = item['id'];
              await _databaseHelper.insertTreasureHunt(treasureHunt);
              if (hunt['choices'] != null) {
                for (var choice in hunt['choices']) {
                  Choice choiceItem = Choice.fromJson(choice);
                  choiceItem.huntId = hunt['id'];
                  await _databaseHelper.insertChoice(choiceItem);
                }
              }
            }
          }
        }
        client.close();
        return standsList;
      } else {
        client.close();
        throw Exception('Failed to load stands');
      }
    } catch (e) {
      // If network request fails, load stands from local database
      return await _databaseHelper.getStands();
    }
  }

  Future<void> addVisitor() async {
    // Check if a visitor already exists in the database
    bool exists = await _databaseHelper.visitorExists();

    // If a visitor does not exist, add a new one
    if (!exists) {
      Client client = Client();
      var url = Uri.parse('$_baseUrl/visitors');

      // Convert the visitor object to JSON
      var visitorJson = json.encode({});

      // Send a POST request to add the visitor
      var response = await client.post(url, body: visitorJson);

      if (response.statusCode == 200) {
        // Visitor added successfully, update the local cache
        var jsonResponse = json.decode(response.body);
        var addedVisitor = Visitor.fromJson(jsonResponse['data']);

        await _databaseHelper.insertVisitor(addedVisitor);
      } else {
        throw Exception('Failed to add visitor');
      }

      client.close();
    }
  }

  Future<List<TreasureHunt>> getQuestion(int standId) async {
    List<TreasureHunt> question =
        await _databaseHelper.getTreasureHuntsByStandId(standId);
    return question;
  }

  Future<List<Choice>> getChoices(int questionId) async {
    List<Choice> choices = await _databaseHelper.getChoicesByHuntId(questionId);
    return choices;
  }
}
