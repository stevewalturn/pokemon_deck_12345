import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokemon_deck/app/app.bottomsheets.dart';
import 'package:pokemon_deck/app/app.dialogs.dart';
import 'package:pokemon_deck/app/app.locator.dart';
import 'package:pokemon_deck/models/enums/flavor.dart';
import 'package:pokemon_deck/utils/flavors/flavors.dart';

Future<void> bootstrap({
  required FutureOr<Widget> Function() builder,
  required Flavor flavor,
}) async {
  await runZonedGuarded(
    () async {
      Flavors.flavor = flavor;
      WidgetsFlutterBinding.ensureInitialized();

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);

      await setupLocator();
      setupDialogUi();
      setupBottomSheetUi();

      runApp(
        await builder(),
      );
    },
    (exception, stackTrace) async {},
  );
}
