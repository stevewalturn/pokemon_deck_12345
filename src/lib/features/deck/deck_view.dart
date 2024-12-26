import 'package:flutter/material.dart';
import 'package:pokemon_deck/features/deck/deck_viewmodel.dart';
import 'package:pokemon_deck/features/deck/widgets/card_list_item.dart';
import 'package:pokemon_deck/features/deck/widgets/deck_stats.dart';
import 'package:pokemon_deck/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';

class DeckView extends StackedView<DeckViewModel> {
  final String? deckId;

  const DeckView({this.deckId, super.key});

  @override
  Widget builder(
    BuildContext context,
    DeckViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.deck?.name ?? 'New Deck'),
        actions: [
          if (viewModel.deck != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => viewModel.deleteDeck(),
            ),
        ],
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : viewModel.hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        viewModel.modelError.toString(),
                        textAlign: TextAlign.center,
                      ),
                      verticalSpaceMedium,
                      ElevatedButton(
                        onPressed: viewModel.initialize,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: viewModel.nameController,
                        decoration: const InputDecoration(
                          labelText: 'Deck Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      verticalSpaceMedium,
                      TextField(
                        controller: viewModel.descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      verticalSpaceMedium,
                      if (viewModel.deck != null) ...[
                        DeckStats(deck: viewModel.deck!),
                        verticalSpaceMedium,
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cards (${viewModel.deck?.cards.length ?? 0})',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: viewModel.navigateToCardSearch,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Cards'),
                          ),
                        ],
                      ),
                      verticalSpaceMedium,
                      if (viewModel.deck?.cards.isEmpty ?? true)
                        const Center(
                          child: Text(
                            'No cards in deck yet.\nTap "Add Cards" to start building your deck!',
                            textAlign: TextAlign.center,
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: viewModel.deck!.cards.length,
                          separatorBuilder: (context, index) =>
                              verticalSpaceSmall,
                          itemBuilder: (context, index) {
                            final card = viewModel.deck!.cards[index];
                            return CardListItem(
                              card: card,
                              onTap: () =>
                                  viewModel.navigateToCardDetails(card.id),
                              onRemove: () =>
                                  viewModel.removeCardFromDeck(card.id),
                            );
                          },
                        ),
                    ],
                  ),
                ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: viewModel.saveDeck,
          child: Text(viewModel.deck == null ? 'Create Deck' : 'Save Changes'),
        ),
      ),
    );
  }

  @override
  DeckViewModel viewModelBuilder(BuildContext context) =>
      DeckViewModel(deckId: deckId);

  @override
  void onViewModelReady(DeckViewModel viewModel) => viewModel.initialize();
}
