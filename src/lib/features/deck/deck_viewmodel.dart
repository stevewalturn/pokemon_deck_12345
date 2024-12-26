import 'package:flutter/material.dart';
import 'package:pokemon_deck/app/app.locator.dart';
import 'package:pokemon_deck/app/app.router.dart';
import 'package:pokemon_deck/models/pokemon_deck.dart';
import 'package:pokemon_deck/features/deck/deck_repository.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';

class DeckViewModel extends BaseViewModel {
  final String? deckId;
  final _deckRepository = locator<DeckRepository>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  PokemonDeck? _deck;
  String? _errorMessage;

  DeckViewModel({this.deckId});

  PokemonDeck? get deck => _deck;
  String? get errorMessage => _errorMessage;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> initialize() async {
    setBusy(true);
    try {
      if (deckId != null) {
        final decks = await _deckRepository.getAllDecks();
        _deck = decks.firstWhere((d) => d.id == deckId);
        nameController.text = _deck!.name;
        descriptionController.text = _deck!.description;
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load deck details. Please try again.';
    } finally {
      setBusy(false);
    }
  }

  Future<void> saveDeck() async {
    if (nameController.text.isEmpty) {
      _errorMessage = 'Please enter a deck name';
      notifyListeners();
      return;
    }

    setBusy(true);
    try {
      final now = DateTime.now();
      final updatedDeck = PokemonDeck(
        id: _deck?.id ?? const Uuid().v4(),
        name: nameController.text,
        description: descriptionController.text,
        cards: _deck?.cards ?? [],
        createdAt: _deck?.createdAt ?? now,
        updatedAt: now,
      );

      await _deckRepository.saveDeck(updatedDeck);
      _navigationService.back();
    } catch (e) {
      _errorMessage = 'Failed to save deck. Please try again.';
    } finally {
      setBusy(false);
    }
  }

  Future<void> deleteDeck() async {
    final response = await _dialogService.showConfirmationDialog(
      title: 'Delete Deck',
      description: 'Are you sure you want to delete this deck?',
      confirmationTitle: 'Delete',
      cancelTitle: 'Cancel',
    );

    if (response?.confirmed ?? false) {
      setBusy(true);
      try {
        await _deckRepository.deleteDeck(deckId!);
        _navigationService.back();
      } catch (e) {
        _errorMessage = 'Failed to delete deck. Please try again.';
      } finally {
        setBusy(false);
      }
    }
  }

  Future<void> removeCardFromDeck(String cardId) async {
    setBusy(true);
    try {
      await _deckRepository.removeCardFromDeck(deckId!, cardId);
      await initialize();
    } catch (e) {
      _errorMessage = 'Failed to remove card from deck. Please try again.';
    } finally {
      setBusy(false);
    }
  }

  void navigateToCardSearch() {
    _navigationService.navigateToCardSearchView();
  }

  void navigateToCardDetails(String cardId) {
    _navigationService.navigateToCardDetailsView(cardId: cardId);
  }
}
