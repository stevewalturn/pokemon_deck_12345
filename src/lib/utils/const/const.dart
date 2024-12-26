// API Configuration
const String pokemonApiBaseUrl = 'https://api.pokemontcg.io/v2';
const int defaultPageSize = 20;
const int maxCardsPerDeck = 60;

// Error Messages
const String errorLoadingCards =
    'Failed to load cards. Please check your internet connection and try again.';
const String errorSavingDeck = 'Failed to save deck. Please try again.';
const String errorDeletingDeck = 'Failed to delete deck. Please try again.';
const String errorLoadingDeck =
    'Failed to load deck details. Please try again.';
const String errorCardNotFound = 'Card not found. Please try again.';
const String errorInvalidDeckSize =
    'A deck must contain between 1 and 60 cards.';
const String errorEmptyDeckName = 'Please enter a deck name.';
const String errorDuplicateDeckName =
    'A deck with this name already exists. Please choose a different name.';

// Success Messages
const String successDeckSaved = 'Deck saved successfully!';
const String successDeckDeleted = 'Deck deleted successfully!';
const String successCardAdded = 'Card added to deck successfully!';
const String successCardRemoved = 'Card removed from deck successfully!';

// Validation Constants
const int minDeckNameLength = 3;
const int maxDeckNameLength = 50;
const int maxDeckDescriptionLength = 500;

// UI Constants
const double cardAspectRatio = 0.71; // Standard Pokemon card ratio
const double cardGridSpacing = 8.0;
const double cardListItemHeight = 80.0;
const int gridCrossAxisCount = 2;

// Storage Keys
const String storageKeyDecks = 'pokemon_decks';
const String storageKeySettings = 'pokemon_settings';

// Pokemon Card Types
const List<String> pokemonCardTypes = [
  'Colorless',
  'Darkness',
  'Dragon',
  'Fairy',
  'Fighting',
  'Fire',
  'Grass',
  'Lightning',
  'Metal',
  'Psychic',
  'Water',
];

// Pokemon Card Rarities
const List<String> pokemonCardRarities = [
  'Common',
  'Uncommon',
  'Rare',
  'Rare Holo',
  'Rare Ultra',
  'Rare Secret',
];

// Default Values
const String defaultDeckDescription = 'No description provided.';
const String defaultErrorMessage =
    'An unexpected error occurred. Please try again.';
