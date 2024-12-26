import 'package:flutter/material.dart';
import 'package:pokemon_deck/ui/common/app_colors.dart';
import 'package:pokemon_deck/ui/common/ui_helpers.dart';

class SearchFilters extends StatelessWidget {
  final List<String> types;
  final List<String> rarities;
  final String? selectedType;
  final String? selectedRarity;
  final Function(String?) onTypeSelected;
  final Function(String?) onRaritySelected;

  const SearchFilters({
    required this.types,
    required this.rarities,
    required this.selectedType,
    required this.selectedRarity,
    required this.onTypeSelected,
    required this.onRaritySelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Filters',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        verticalSpaceSmall,
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                value: selectedType,
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('All Types'),
                  ),
                  ...types.map(
                    (type) => DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    ),
                  ),
                ],
                onChanged: onTypeSelected,
              ),
            ),
            horizontalSpaceSmall,
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Rarity',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                value: selectedRarity,
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('All Rarities'),
                  ),
                  ...rarities.map(
                    (rarity) => DropdownMenuItem<String>(
                      value: rarity,
                      child: Text(rarity),
                    ),
                  ),
                ],
                onChanged: onRaritySelected,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
