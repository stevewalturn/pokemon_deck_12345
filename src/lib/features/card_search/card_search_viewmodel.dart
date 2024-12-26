import 'package:pokemon_deck/app/app.locator.dart';
import 'package:pokemon_deck/models/pokemon_card.dart';
import 'package:pokemon_deck/services/pokemon_api_service.dart';
import 'package:stacked/stacked.dart';

class CardSearchViewModel extends BaseViewModel {
  final _pokemonApiService = locator<PokemonApiService>();

  List<PokemonCard> _searchResults = [];
  List<String> _types = [];
  List<String> _rarities = [];
  String _searchQuery = '';
  String? _selectedType;
  String? _selectedRarity;
  bool _isLoading = false;
  String? _errorMessage;

  List<PokemonCard> get searchResults => _searchResults;
  List<String> get types => _types;
  List<String> get rarities => _rarities;
  String get searchQuery => _searchQuery;
  String? get selectedType => _selectedType;
  String? get selectedRarity => _selectedRarity;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final futures = await Future.wait([
        _pokemonApiService.getTypes(),
        _pokemonApiService.getRarities(),
      ]);

      _types = futures[0];
      _rarities = futures[1];
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load filter options. Please try again later.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateSelectedType(String? type) {
    _selectedType = type;
    notifyListeners();
  }

  void updateSelectedRarity(String? rarity) {
    _selectedRarity = rarity;
    notifyListeners();
  }

  Future<void> searchCards() async {
    if (_searchQuery.isEmpty &&
        _selectedType == null &&
        _selectedRarity == null) {
      _errorMessage = 'Please enter a search term or select filters';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _searchResults = await _pokemonApiService.searchCards(
        query: _searchQuery,
        types: _selectedType,
        rarity: _selectedRarity,
      );

      if (_searchResults.isEmpty) {
        _errorMessage = 'No cards found matching your criteria';
      }
    } catch (e) {
      _errorMessage = 'Failed to search cards. Please try again later.';
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedType = null;
    _selectedRarity = null;
    _searchResults = [];
    _errorMessage = null;
    notifyListeners();
  }
}
