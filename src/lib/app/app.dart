import 'package:pokemon_deck/features/card_details/card_details_view.dart';
import 'package:pokemon_deck/features/card_search/card_search_view.dart';
import 'package:pokemon_deck/features/deck/deck_view.dart';
import 'package:pokemon_deck/features/deck/deck_repository.dart';
import 'package:pokemon_deck/services/pokemon_api_service.dart';
import 'package:pokemon_deck/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:pokemon_deck/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:pokemon_deck/ui/views/home/home_view.dart';
import 'package:pokemon_deck/ui/views/startup/startup_view.dart';
import 'package:shared_preferences.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView, initial: true),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: DeckView),
    MaterialRoute(page: CardSearchView),
    MaterialRoute(page: CardDetailsView),
  ],
  dependencies: [
    InitializableSingleton(
      classType: PokemonApiService,
      asType: PokemonApiService,
      resolveUsing: PokemonApiService(apiKey: 'your-api-key-here'),
    ),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: BottomSheetService),
    PresolveValue<SharedPreferences>(
      presolveUsing: SharedPreferences.getInstance,
    ),
    LazySingleton(
      classType: DeckRepository,
      resolveUsing: DeckRepository(locator<SharedPreferences>()),
    ),
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
  ],
)
class App {}
