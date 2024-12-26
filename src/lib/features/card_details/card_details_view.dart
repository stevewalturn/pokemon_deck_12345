import 'package:flutter/material.dart';
import 'package:pokemon_deck/features/card_details/card_details_viewmodel.dart';
import 'package:pokemon_deck/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';

class CardDetailsView extends StackedView<CardDetailsViewModel> {
  final String cardId;

  const CardDetailsView({required this.cardId, super.key});

  @override
  Widget builder(
    BuildContext context,
    CardDetailsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.card?.name ?? 'Card Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: viewModel.navigateBack,
        ),
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
                      Center(
                        child: Hero(
                          tag: 'card_${viewModel.card!.id}',
                          child: Image.network(
                            viewModel.card!.imageUrlHiRes,
                            height: 300,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const SizedBox(
                                height: 300,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const SizedBox(
                                height: 300,
                                child: Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 50,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      verticalSpaceLarge,
                      _buildInfoSection(
                        'Card Information',
                        [
                          _buildInfoRow('Name', viewModel.card!.name),
                          _buildInfoRow('HP', viewModel.card!.hp.toString()),
                          _buildInfoRow('Types', viewModel.getFormattedTypes()),
                          _buildInfoRow(
                            'Weaknesses',
                            viewModel.getFormattedWeaknesses(),
                          ),
                          _buildInfoRow(
                            'Resistances',
                            viewModel.getFormattedResistances(),
                          ),
                          _buildInfoRow(
                            'Retreat Cost',
                            viewModel.card!.retreatCost,
                          ),
                        ],
                      ),
                      verticalSpaceMedium,
                      if (viewModel.card!.attacks.isNotEmpty) ...[
                        const Text(
                          'Attacks',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        verticalSpaceSmall,
                        Text(
                          viewModel.getFormattedAttacks(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        verticalSpaceSmall,
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  CardDetailsViewModel viewModelBuilder(BuildContext context) =>
      CardDetailsViewModel(cardId: cardId);

  @override
  void onViewModelReady(CardDetailsViewModel viewModel) =>
      viewModel.initialize();
}
