import 'package:flutter/material.dart';
import 'package:pokemon_deck/ui/common/ui_helpers.dart';
import 'package:pokemon_deck/ui/views/home/home_viewmodel.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemon Deck Builder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: viewModel.navigateToCardSearch,
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
                        onPressed: viewModel.refreshDecks,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: viewModel.refreshDecks,
                  child: viewModel.decks.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'No decks yet!\nTap the + button to create your first deck.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                              verticalSpaceMedium,
                              ElevatedButton(
                                onPressed: viewModel.navigateToCreateDeck,
                                child: const Text('Create New Deck'),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: viewModel.decks.length,
                          separatorBuilder: (context, index) =>
                              verticalSpaceSmall,
                          itemBuilder: (context, index) {
                            final deck = viewModel.decks[index];
                            return Card(
                              child: ListTile(
                                title: Text(deck.name),
                                subtitle: Text(
                                  '${deck.cards.length} cards • Last updated: ${_formatDate(deck.updatedAt)}',
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () =>
                                    viewModel.navigateToEditDeck(deck.id),
                              ),
                            );
                          },
                        ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.navigateToCreateDeck,
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) => viewModel.initialize();
}
