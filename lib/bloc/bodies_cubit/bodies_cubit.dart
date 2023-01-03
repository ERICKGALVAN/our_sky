import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:our_sky/models/bodies_model.dart';

import '../../services/astronomy_service.dart';

part 'bodies_cubit_state.dart';

class BodiesCubit extends Cubit<BodiesCubitState> {
  BodiesModel? bodiesModel;
  BodiesCubit() : super(BodiesCubitInitial());

  Future<void> getBodies(String latitude, String longitude, int elevation,
      String fromDate, String toDate, String time) async {
    try {
      bodiesModel = await AstronomyService().getBodies(
        latitude,
        longitude,
        elevation,
        fromDate,
        toDate,
        time,
      );
    } catch (e) {
      log(e.toString());
    }
  }
}
