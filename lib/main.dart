import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_sky/bloc/bodies_cubit/bodies_cubit.dart';
import 'package:our_sky/bloc/planet_cubit/planet_cubit.dart';
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
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Menu(),
      ),
    ),
  );
}
