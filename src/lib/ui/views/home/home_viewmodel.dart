import 'package:pokemon_deck/app/app.locator.dart';
import 'package:pokemon_deck/app/app.router.dart';
import 'package:pokemon_deck/features/deck/deck_repository.dart';
import 'package:pokemon_deck/models/pokemon_deck.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _deckRepository = locator<DeckRepository>();
  final _navigationService = locator<NavigationService>();

  List<PokemonDeck> _decks = [];
  String? _errorMessage;

  List<PokemonDeck> get decks => _decks;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    setBusy(true);
    try {
      _decks = await _deckRepository.getAllDecks();
      _decks.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load decks. Please try again.';
    } finally {
      setBusy(false);
    }
  }

  void navigateToCreateDeck() {
    _navigationService.navigateToDeckView();
  }

  void navigateToEditDeck(String deckId) {
    _navigationService.navigateToDeckView(deckId: deckId);
  }

  void navigateToCardSearch() {
    _navigationService.navigateToCardSearchView();
  }

  Future<void> refreshDecks() async {
    await initialize();
  }
}
