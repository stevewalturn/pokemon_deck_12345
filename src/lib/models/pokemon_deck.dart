import 'package:equatable/equatable.dart';
import 'package:pokemon_deck/models/pokemon_card.dart';

class PokemonDeck extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<PokemonCard> cards;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PokemonDeck({
    required this.id,
    required this.name,
    required this.description,
    required this.cards,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PokemonDeck.fromJson(Map<String, dynamic> json) {
    return PokemonDeck(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      cards: (json['cards'] as List)
          .map((card) => PokemonCard.fromJson(card as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cards': cards.map((card) => card.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  PokemonDeck copyWith({
    String? id,
    String? name,
    String? description,
    List<PokemonCard>? cards,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PokemonDeck(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      cards: cards ?? this.cards,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, description, cards, createdAt, updatedAt];
}
