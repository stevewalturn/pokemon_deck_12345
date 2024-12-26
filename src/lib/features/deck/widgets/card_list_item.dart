import 'package:flutter/material.dart';
import 'package:pokemon_deck/models/pokemon_card.dart';
import 'package:pokemon_deck/ui/common/ui_helpers.dart';

class CardListItem extends StatelessWidget {
  final PokemonCard card;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const CardListItem({
    required this.card,
    required this.onTap,
    required this.onRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              SizedBox(
                width: 60,
                height: 80,
                child: Image.network(
                  card.imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.broken_image, size: 30),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              horizontalSpaceMedium,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    verticalSpaceTiny,
                    Text(
                      'Type: ${card.types.join(", ")}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    verticalSpaceTiny,
                    Text(
                      'HP: ${card.hp}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                color: Colors.red,
                onPressed: onRemove,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
