import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Import the dart:convert library

class StockHistory {
  StockHistory._();

  static Future<void> saveStockHistory(
      List<Map<String, dynamic>> history) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString =
        jsonEncode(history); // Serialize the list of maps to JSON
    prefs.setString('stockHistory', jsonString);
  }

  static Future<List<Map<String, dynamic>>> getStockHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('stockHistory');
    if (jsonString != null) {
      final history = jsonDecode(jsonString) as List<dynamic>;
      return history.cast<Map<String, dynamic>>();
    } else {
      return [];
    }
  }

  static Future<void> addToStockHistory(Map<String, dynamic> newItem) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getStockHistory();

    String newItemId = newItem['itemId'];

    bool containsDuplicate = history.any((entry) {
      return entry['itemId'] == newItemId;
    });

    if (!containsDuplicate) {
      history.insert(0, newItem);
      await saveStockHistory(history);
    }
  }

  // Function to update a specific key-value pair for an item based on its id
  static Future<void> updateStockItem(
      String itemId, String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getStockHistory();

    // Find the item by id
    for (int i = 0; i < history.length; i++) {
      if (history[i]['itemId'] == itemId) {
        history[i][key] = value;
        break;
      }
    }

    // Save the updated history
    await saveStockHistory(history);
  }

  static Future<void> clearStockHistory(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getStockHistory();
    history.removeWhere((entry) => entry['itemId'] == itemId);
    await saveStockHistory(history);
  }

  static Future<void> clearAllStockHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('stockHistory');
  }
}
