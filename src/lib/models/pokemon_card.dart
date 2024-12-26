import 'package:equatable/equatable.dart';

class PokemonCard extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final String imageUrlHiRes;
  final String supertype;
  final List<String> subtypes;
  final String number;
  final String rarity;
  final String series;
  final String set;
  final String setCode;
  final List<String> types;
  final int hp;
  final List<Attack> attacks;
  final List<Weakness> weaknesses;
  final List<Resistance> resistances;
  final String retreatCost;

  const PokemonCard({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.imageUrlHiRes,
    required this.supertype,
    required this.subtypes,
    required this.number,
    required this.rarity,
    required this.series,
    required this.set,
    required this.setCode,
    required this.types,
    required this.hp,
    required this.attacks,
    required this.weaknesses,
    required this.resistances,
    required this.retreatCost,
  });

  factory PokemonCard.fromJson(Map<String, dynamic> json) {
    return PokemonCard(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      imageUrlHiRes: json['imageUrlHiRes'] as String,
      supertype: json['supertype'] as String,
      subtypes: List<String>.from(json['subtypes'] as List),
      number: json['number'] as String,
      rarity: json['rarity'] as String,
      series: json['series'] as String,
      set: json['set'] as String,
      setCode: json['setCode'] as String,
      types: List<String>.from(json['types'] as List),
      hp: int.parse(json['hp'] as String),
      attacks: (json['attacks'] as List?)
              ?.map((attack) => Attack.fromJson(attack as Map<String, dynamic>))
              .toList() ??
          [],
      weaknesses: (json['weaknesses'] as List?)
              ?.map((weakness) =>
                  Weakness.fromJson(weakness as Map<String, dynamic>))
              .toList() ??
          [],
      resistances: (json['resistances'] as List?)
              ?.map((resistance) =>
                  Resistance.fromJson(resistance as Map<String, dynamic>))
              .toList() ??
          [],
      retreatCost: json['retreatCost']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'imageUrlHiRes': imageUrlHiRes,
      'supertype': supertype,
      'subtypes': subtypes,
      'number': number,
      'rarity': rarity,
      'series': series,
      'set': set,
      'setCode': setCode,
      'types': types,
      'hp': hp.toString(),
      'attacks': attacks.map((attack) => attack.toJson()).toList(),
      'weaknesses': weaknesses.map((weakness) => weakness.toJson()).toList(),
      'resistances':
          resistances.map((resistance) => resistance.toJson()).toList(),
      'retreatCost': retreatCost,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        imageUrlHiRes,
        supertype,
        subtypes,
        number,
        rarity,
        series,
        set,
        setCode,
        types,
        hp,
        attacks,
        weaknesses,
        resistances,
        retreatCost,
      ];
}

class Attack extends Equatable {
  final String name;
  final List<String> cost;
  final int convertedEnergyCost;
  final String damage;
  final String text;

  const Attack({
    required this.name,
    required this.cost,
    required this.convertedEnergyCost,
    required this.damage,
    required this.text,
  });

  factory Attack.fromJson(Map<String, dynamic> json) {
    return Attack(
      name: json['name'] as String,
      cost: List<String>.from(json['cost'] as List),
      convertedEnergyCost: json['convertedEnergyCost'] as int,
      damage: json['damage'] as String,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cost': cost,
      'convertedEnergyCost': convertedEnergyCost,
      'damage': damage,
      'text': text,
    };
  }

  @override
  List<Object?> get props => [name, cost, convertedEnergyCost, damage, text];
}

class Weakness extends Equatable {
  final String type;
  final String value;

  const Weakness({
    required this.type,
    required this.value,
  });

  factory Weakness.fromJson(Map<String, dynamic> json) {
    return Weakness(
      type: json['type'] as String,
      value: json['value'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
    };
  }

  @override
  List<Object?> get props => [type, value];
}

class Resistance extends Equatable {
  final String type;
  final String value;

  const Resistance({
    required this.type,
    required this.value,
  });

  factory Resistance.fromJson(Map<String, dynamic> json) {
    return Resistance(
      type: json['type'] as String,
      value: json['value'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
    };
  }

  @override
  List<Object?> get props => [type, value];
}
