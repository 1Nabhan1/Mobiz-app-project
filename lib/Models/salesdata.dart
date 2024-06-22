import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Import the dart:convert library

class SaleskHistory {
  SaleskHistory._();

  static Future<void> saveSalesHistory(
      List<Map<String, dynamic>> history) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString =
        jsonEncode(history); // Serialize the list of maps to JSON
    prefs.setString('salesHistory', jsonString);
  }

  static Future<List<Map<String, dynamic>>> getSalesHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('salesHistory');
    if (jsonString != null) {
      final history = jsonDecode(jsonString) as List<dynamic>;
      return history.cast<Map<String, dynamic>>();
    } else {
      return [];
    }
  }

  static Future<void> addToSalesHistory(Map<String, dynamic> newItem) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getSalesHistory();

    String newItemId = newItem['icode'];

    bool containsDuplicate = history.any((entry) {
      return entry['icode'] == newItemId;
    });

    if (!containsDuplicate) {
      history.insert(0, newItem);
      await saveSalesHistory(history);
    }
  }

  static Future<void> clearSalesHistory(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getSalesHistory();
    history.removeWhere((entry) => entry['icode'] == itemId);
    await saveSalesHistory(history);
  }

  static Future<void> clearAllSalesHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('salesHistory');
  }

  // Function to update a specific key-value pair for an item based on its id
  static Future<void> updateSaleItem(
      String itemId, String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getSalesHistory();

    // Find the item by id
    for (int i = 0; i < history.length; i++) {
      if (history[i]['icode'] == itemId) {
        history[i][key] = value;
        break;
      }
    }

    // Save the updated history
    await saveSalesHistory(history);
  }
}
