import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokemon_deck/models/pokemon_card.dart';
import 'package:stacked/stacked_annotations.dart';

class PokemonApiService implements InitializableDependency {
  static const String baseUrl = 'https://api.pokemontcg.io/v2';
  final String apiKey;
  final http.Client _client;

  PokemonApiService({required this.apiKey}) : _client = http.Client();

  @override
  Future<void> init() async {
    // Validate API key and connection
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/cards?pageSize=1'),
        headers: {'X-Api-Key': apiKey},
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to initialize Pokemon API service: Invalid API key');
      }
    } catch (e) {
      throw Exception('Failed to connect to Pokemon API: ${e.toString()}');
    }
  }

  Future<List<PokemonCard>> searchCards({
    String? query,
    String? types,
    String? subtypes,
    String? rarity,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'pageSize': pageSize.toString(),
        if (query != null && query.isNotEmpty) 'q': 'name:$query*',
        if (types != null) 'q': 'types:$types',
        if (subtypes != null) 'q': 'subtypes:$subtypes',
        if (rarity != null) 'q': 'rarity:$rarity',
      };

      final uri =
          Uri.parse('$baseUrl/cards').replace(queryParameters: queryParams);
      final response = await _client.get(
        uri,
        headers: {'X-Api-Key': apiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final cards = (data['data'] as List)
            .map((card) => PokemonCard.fromJson(card as Map<String, dynamic>))
            .toList();
        return cards;
      } else if (response.statusCode == 429) {
        throw Exception('Rate limit exceeded. Please try again later.');
      } else {
        throw Exception('Failed to search cards. Please try again.');
      }
    } catch (e) {
      throw Exception('Failed to search cards: ${e.toString()}');
    }
  }

  Future<PokemonCard> getCardById(String id) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/cards/$id'),
        headers: {'X-Api-Key': apiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return PokemonCard.fromJson(data['data'] as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw Exception('Card not found');
      } else {
        throw Exception('Failed to get card details. Please try again.');
      }
    } catch (e) {
      throw Exception('Failed to get card details: ${e.toString()}');
    }
  }

  Future<List<String>> getTypes() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/types'),
        headers: {'X-Api-Key': apiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return List<String>.from(data['data'] as List);
      } else {
        throw Exception('Failed to get card types. Please try again.');
      }
    } catch (e) {
      throw Exception('Failed to get card types: ${e.toString()}');
    }
  }

  Future<List<String>> getRarities() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/rarities'),
        headers: {'X-Api-Key': apiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return List<String>.from(data['data'] as List);
      } else {
        throw Exception('Failed to get card rarities. Please try again.');
      }
    } catch (e) {
      throw Exception('Failed to get card rarities: ${e.toString()}');
    }
  }

  void dispose() {
    _client.close();
  }
}
