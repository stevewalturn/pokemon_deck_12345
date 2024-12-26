import 'package:flutter/material.dart';
import 'package:pokemon_deck/features/card_search/card_search_viewmodel.dart';
import 'package:pokemon_deck/features/card_search/widgets/search_filters.dart';
import 'package:pokemon_deck/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';

class CardSearchView extends StackedView<CardSearchViewModel> {
  const CardSearchView({super.key});

  @override
  Widget builder(
    BuildContext context,
    CardSearchViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Cards'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: viewModel.clearFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search cards...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: viewModel.updateSearchQuery,
                ),
                verticalSpaceMedium,
                SearchFilters(
                  types: viewModel.types,
                  rarities: viewModel.rarities,
                  selectedType: viewModel.selectedType,
                  selectedRarity: viewModel.selectedRarity,
                  onTypeSelected: viewModel.updateSelectedType,
                  onRaritySelected: viewModel.updateSelectedRarity,
                ),
                verticalSpaceMedium,
                ElevatedButton(
                  onPressed: viewModel.searchCards,
                  child: const Text('Search'),
                ),
              ],
            ),
          ),
          if (viewModel.errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                viewModel.errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(
            child: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : viewModel.searchResults.isEmpty
                    ? const Center(
                        child: Text(
                          'No results found.\nTry adjusting your search criteria.',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: viewModel.searchResults.length,
                        itemBuilder: (context, index) {
                          final card = viewModel.searchResults[index];
                          return Card(
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: () => viewModel.navigateToCardDetails(
                                card.id,
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      card.imageUrl,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            size: 50,
                                          ),
                                        );
                                      },
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      card.name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  @override
  CardSearchViewModel viewModelBuilder(BuildContext context) =>
      CardSearchViewModel();

  @override
  void onViewModelReady(CardSearchViewModel viewModel) =>
      viewModel.initialize();
}
