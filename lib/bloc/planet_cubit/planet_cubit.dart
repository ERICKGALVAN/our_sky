import 'dart:developer';

import 'package:bloc/bloc.dart';

import '../../models/planet_model.dart';
import '../../services/astronomy_service.dart';

part 'planet_cubit_state.dart';

class PlanetCubit extends Cubit<PlanetCubitState> {
  PlanetModel? planetInformation;
  PlanetCubit() : super(PlanetCubitInitial());

  Future<void> getPlanetInformation(String planetName) async {
    try {
      planetInformation =
          await AstronomyService().getPlanetInformation(planetName);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
