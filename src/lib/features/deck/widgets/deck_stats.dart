import 'package:flutter/material.dart';
import 'package:pokemon_deck/models/pokemon_deck.dart';
import 'package:pokemon_deck/ui/common/ui_helpers.dart';

class DeckStats extends StatelessWidget {
  final PokemonDeck deck;

  const DeckStats({
    required this.deck,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final typeDistribution = _calculateTypeDistribution();
    final averageHP = _calculateAverageHP();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Deck Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            verticalSpaceMedium,
            _buildStatRow('Total Cards', deck.cards.length.toString()),
            verticalSpaceSmall,
            _buildStatRow('Average HP', averageHP.toStringAsFixed(1)),
            verticalSpaceSmall,
            const Text(
              'Type Distribution:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            verticalSpaceSmall,
            ...typeDistribution.entries.map(
              (entry) => _buildTypeRow(entry.key, entry.value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeRow(String type, int count) {
    final percentage = (count / deck.cards.length * 100).toStringAsFixed(1);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(type),
          Text('$count ($percentage%)'),
        ],
      ),
    );
  }

  Map<String, int> _calculateTypeDistribution() {
    final distribution = <String, int>{};
    for (final card in deck.cards) {
      for (final type in card.types) {
        distribution[type] = (distribution[type] ?? 0) + 1;
      }
    }
    return Map.fromEntries(
      distribution.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
    );
  }

  double _calculateAverageHP() {
    if (deck.cards.isEmpty) return 0;
    final totalHP = deck.cards.fold(0, (sum, card) => sum + card.hp);
    return totalHP / deck.cards.length;
  }
}
