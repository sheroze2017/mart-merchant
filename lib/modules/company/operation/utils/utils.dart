import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:http/http.dart' as http;

class PlaceService {
  final String apiKey;

  PlaceService(this.apiKey);

  Future<List<Map<String, String>>> getPlaceSuggestions(String input) async {
    final url = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/autocomplete/json',
      {
        'input': input,
        'key': apiKey,
      },
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final predictions = jsonResponse['predictions'] as List<dynamic>;

      return predictions.map((place) {
        return {
          'description': place['description'] as String,
          'placeId': place['place_id'] as String,
        };
      }).toList();
    } else {
      throw Exception('Failed to load place suggestions');
    }
  }

  Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
    final url = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/details/json',
      {
        'place_id': placeId,
        'key': apiKey,
      },
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['result'];
    } else {
      throw Exception('Failed to load place details');
    }
  }
}
