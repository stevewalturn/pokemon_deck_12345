import 'package:pokemon_deck/app/app.locator.dart';
import 'package:pokemon_deck/models/pokemon_card.dart';
import 'package:pokemon_deck/services/pokemon_api_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CardDetailsViewModel extends BaseViewModel {
  final String cardId;
  final _pokemonApiService = locator<PokemonApiService>();
  final _navigationService = locator<NavigationService>();

  PokemonCard? _card;
  String? _errorMessage;

  CardDetailsViewModel({required this.cardId});

  PokemonCard? get card => _card;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    setBusy(true);
    try {
      _card = await _pokemonApiService.getCardById(cardId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load card details. Please try again.';
    } finally {
      setBusy(false);
    }
  }

  void navigateBack() {
    _navigationService.back();
  }

  String getFormattedTypes() {
    if (_card == null || _card!.types.isEmpty) return 'N/A';
    return _card!.types.join(', ');
  }

  String getFormattedWeaknesses() {
    if (_card == null || _card!.weaknesses.isEmpty) return 'None';
    return _card!.weaknesses.map((w) => '${w.type} (${w.value})').join(', ');
  }

  String getFormattedResistances() {
    if (_card == null || _card!.resistances.isEmpty) return 'None';
    return _card!.resistances.map((r) => '${r.type} (${r.value})').join(', ');
  }

  String getFormattedAttacks() {
    if (_card == null || _card!.attacks.isEmpty) return 'None';
    return _card!.attacks
        .map((a) =>
            '${a.name} - ${a.damage} damage (Energy: ${a.convertedEnergyCost})')
        .join('\n');
  }
}
