import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:meloplay/src/app.dart';
import 'package:meloplay/src/bloc/favorites/favorites_bloc.dart';
import 'package:meloplay/src/bloc/home/home_bloc.dart';
import 'package:meloplay/src/bloc/player/player_bloc.dart';
import 'package:meloplay/src/bloc/recents/recents_bloc.dart';
import 'package:meloplay/src/bloc/song/song_bloc.dart';
import 'package:meloplay/src/bloc/theme/theme_bloc.dart';
import 'package:meloplay/src/core/di/service_locator.dart';
import 'package:meloplay/src/data/repositories/player_repository.dart';
import 'package:meloplay/src/data/services/hive_box.dart';

Future<void> main() async {
  // initialize flutter engine
  WidgetsFlutterBinding.ensureInitialized();

  // initialize dependency injection
  init();

  // set portrait orientation
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  // ask for permission to access media if not granted
  if (!await Permission.mediaLibrary.isGranted) {
    await Permission.mediaLibrary.request();
  }

  // initialize hive
  await Hive.initFlutter();
  await Hive.openBox(HiveBox.boxName);

  // initialize audio service
  await sl<JustAudioPlayer>().init();

  // run app
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<HomeBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<ThemeBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<SongBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<FavoritesBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<PlayerBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<RecentsBloc>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
