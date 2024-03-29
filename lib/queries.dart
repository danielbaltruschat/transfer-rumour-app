import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

//const ipOfAPI = "http://10.140.1.48:8000";
const ipOfAPI = "https://home.baltruschat.de:8000";

http.Client getClient() => http.Client();

class QueryLocal {
  static Future<List<String>> getFavourites(saveKey) async {
    // keys: favourite_transfers, favourite_players, favourite_teams
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favourites = prefs.getStringList(saveKey) ?? [];
    return favourites;
  }

  static Future<void> removeFavourite(saveKey, valueToRemove) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> temp = prefs.getStringList(saveKey) as List<String>;
    if (temp.contains(valueToRemove.toString())) {
      await prefs.setStringList(
          saveKey, temp..remove(valueToRemove.toString()));
    }
  }

  static Future<void> addFavourite(saveKey, valueToAdd) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> temp = prefs.getStringList(saveKey) ?? [];
    if (!temp.contains(valueToAdd.toString())) {
      await prefs.setStringList(saveKey, temp..add(valueToAdd.toString()));
    }
  }
}

class TransferNotFoundException implements Exception {
  String cause;
  TransferNotFoundException(this.cause);
}

class QueryServer {
  static Future<Map<String, dynamic>> getTeamInfoByTeamID(teamID) async {
    http.Client client = getClient();
    final response = await client.get(Uri.parse('$ipOfAPI/team_by_id/$teamID'));
    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> teamInfo =
          (jsonDecode(response.body) as List<dynamic>)
              .cast<Map<String, dynamic>>();
      return teamInfo[0];
    } else {
      throw Exception('Failed to load teams');
    }
  }

  static Future<Map<String, dynamic>> getPlayerInfoByPlayerID(playerID) async {
    http.Client client = getClient();
    final response =
        await client.get(Uri.parse('$ipOfAPI/player_by_id/$playerID'));
    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> playerInfo =
          (jsonDecode(response.body) as List<dynamic>)
              .cast<Map<String, dynamic>>();
      return playerInfo[0];
    } else {
      throw Exception('Failed to load players');
    }
  }

  static Future<Map<String, dynamic>> getTransferByTransferID(
      transferID) async {
    http.Client client = getClient();
    final response =
        await client.get(Uri.parse('$ipOfAPI/transfer_by_id/$transferID'));
    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> transfers =
          (jsonDecode(response.body) as List<dynamic>)
              .cast<Map<String, dynamic>>();
      if (transfers.isEmpty) {
        throw TransferNotFoundException('Transfer not found');
      }
      return transfers[0];
    } else {
      throw Exception('Failed to load transfers');
    }
  }

  static Future<List<Map<String, dynamic>>> getAllTransfers() async {
    http.Client client = getClient();
    final response = await client.get(Uri.parse('$ipOfAPI/all_transfers'));
    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> transfers =
          (jsonDecode(response.body) as List<dynamic>)
              .cast<Map<String, dynamic>>();
      return transfers;
    } else {
      throw Exception('Failed to load transfers');
    }
  }

  static Future<List<Map<String, dynamic>>> getTransfersByTeamID(teamID) async {
    http.Client client = getClient();
    final response =
        await client.get(Uri.parse('$ipOfAPI/transfer_by_team_id/$teamID'));
    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> transfers =
          (jsonDecode(response.body) as List<dynamic>)
              .cast<Map<String, dynamic>>();
      return transfers;
    } else {
      throw Exception('Failed to load transfers');
    }
  }

  static Future<List<Map<String, dynamic>>> getTransfersByPlayerID(
      playerID) async {
    http.Client client = getClient();
    final response =
        await client.get(Uri.parse('$ipOfAPI/transfer_by_player_id/$playerID'));
    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> transfers =
          (jsonDecode(response.body) as List<dynamic>)
              .cast<Map<String, dynamic>>();
      return transfers;
    } else {
      throw Exception('Failed to load transfers');
    }
  }

  static Future<List<Map<String, dynamic>>> searchPlayers(query) async {
    http.Client client = getClient();
    query = "%$query%";
    final response =
        await client.get(Uri.parse('$ipOfAPI/search_players/$query'));
    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> transfers =
          (jsonDecode(response.body) as List<dynamic>)
              .cast<Map<String, dynamic>>();
      return transfers;
    } else {
      throw Exception('Failed to load players');
    }
  }

  static Future<List<Map<String, dynamic>>> searchTeams(query) async {
    http.Client client = getClient();
    query = "%$query%";
    final response =
        await client.get(Uri.parse('$ipOfAPI/search_teams/$query'));
    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> transfers =
          (jsonDecode(response.body) as List<dynamic>)
              .cast<Map<String, dynamic>>();
      return transfers;
    } else {
      throw Exception('Failed to load teams');
    }
  }

  static Future<List<Map<String, dynamic>>> getSources(transferID) async {
    http.Client client = getClient();
    final response = await client
        .get(Uri.parse('$ipOfAPI/get_sources_by_transfer_id/$transferID'));
    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> transfers =
          (jsonDecode(response.body) as List<dynamic>)
              .cast<Map<String, dynamic>>();
      return transfers;
    } else {
      throw Exception('Failed to load teams');
    }
  }
}
