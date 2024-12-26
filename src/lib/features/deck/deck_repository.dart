import 'package:pokemon_deck/models/pokemon_card.dart';
import 'package:pokemon_deck/models/pokemon_deck.dart';
import 'package:shared_preferences.dart';
import 'dart:convert';

class DeckRepository {
  final SharedPreferences _prefs;
  static const String _deckKey = 'pokemon_decks';

  DeckRepository(this._prefs);

  Future<List<PokemonDeck>> getAllDecks() async {
    try {
      final decksJson = _prefs.getStringList(_deckKey) ?? [];
      return decksJson
          .map((json) => PokemonDeck.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      throw Exception('Failed to load decks. Please try again.');
    }
  }

  Future<void> saveDeck(PokemonDeck deck) async {
    try {
      final decks = await getAllDecks();
      final existingIndex = decks.indexWhere((d) => d.id == deck.id);

      if (existingIndex != -1) {
        decks[existingIndex] = deck;
      } else {
        decks.add(deck);
      }

      final decksJson = decks.map((deck) => jsonEncode(deck.toJson())).toList();
      await _prefs.setStringList(_deckKey, decksJson);
    } catch (e) {
      throw Exception('Failed to save deck. Please try again.');
    }
  }

  Future<void> deleteDeck(String deckId) async {
    try {
      final decks = await getAllDecks();
      decks.removeWhere((deck) => deck.id == deckId);

      final decksJson = decks.map((deck) => jsonEncode(deck.toJson())).toList();
      await _prefs.setStringList(_deckKey, decksJson);
    } catch (e) {
      throw Exception('Failed to delete deck. Please try again.');
    }
  }

  Future<void> addCardToDeck(String deckId, PokemonCard card) async {
    try {
      final decks = await getAllDecks();
      final deckIndex = decks.indexWhere((deck) => deck.id == deckId);

      if (deckIndex == -1) {
        throw Exception('Deck not found');
      }

      final updatedDeck = decks[deckIndex].copyWith(
        cards: [...decks[deckIndex].cards, card],
        updatedAt: DateTime.now(),
      );

      decks[deckIndex] = updatedDeck;
      final decksJson = decks.map((deck) => jsonEncode(deck.toJson())).toList();
      await _prefs.setStringList(_deckKey, decksJson);
    } catch (e) {
      throw Exception('Failed to add card to deck. Please try again.');
    }
  }

  Future<void> removeCardFromDeck(String deckId, String cardId) async {
    try {
      final decks = await getAllDecks();
      final deckIndex = decks.indexWhere((deck) => deck.id == deckId);

      if (deckIndex == -1) {
        throw Exception('Deck not found');
      }

      final updatedDeck = decks[deckIndex].copyWith(
        cards:
            decks[deckIndex].cards.where((card) => card.id != cardId).toList(),
        updatedAt: DateTime.now(),
      );

      decks[deckIndex] = updatedDeck;
      final decksJson = decks.map((deck) => jsonEncode(deck.toJson())).toList();
      await _prefs.setStringList(_deckKey, decksJson);
    } catch (e) {
      throw Exception('Failed to remove card from deck. Please try again.');
    }
  }
}
