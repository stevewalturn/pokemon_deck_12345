import 'package:pokemon_deck/main/bootstrap.dart';
import 'package:pokemon_deck/models/enums/flavor.dart';
import 'package:pokemon_deck/ui/views/app/app_view.dart';

void main() {
  bootstrap(
    builder: () => const AppView(),
    flavor: Flavor.production,
  );
}
