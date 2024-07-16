import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_sky/bloc/background_cubit/background_cubit.dart';
import 'package:our_sky/bloc/bodies_cubit/bodies_cubit.dart';
import 'package:our_sky/bloc/font_color_cubit/font_color_cubit.dart';
import 'package:our_sky/bloc/font_cubit/font_cubit.dart';
import 'package:our_sky/bloc/planet_cubit/planet_cubit.dart';
import 'package:our_sky/bloc/selection_background/selection_background_cubit.dart';
import 'package:our_sky/ui/menu.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<BodiesCubit>(
          create: (context) => BodiesCubit(),
        ),
        BlocProvider(
          create: (context) => PlanetCubit(),
        ),
        BlocProvider(
          create: (context) => BackgroundCubit()..initBackground(),
        ),
        BlocProvider(
          create: (context) => SelectionBackgroundCubit(),
        ),
        BlocProvider(
          create: (context) => FontCubit()..initFont(),
        ),
        BlocProvider(
          create: (context) => FontColorCubit()..initFontColor(),
        ),
      ],
      child: BlocBuilder<BackgroundCubit, BackgroundState>(
        builder: (context, state) {
          return BlocBuilder<FontCubit, FontState>(
            builder: (context, state) {
              return BlocBuilder<FontColorCubit, FontColorState>(
                builder: (context, state) {
                  return const MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home: Menu(),
                  );
                },
              );
            },
          );
        },
      ),
    ),
  );
}
