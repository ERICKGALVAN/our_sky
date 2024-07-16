import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'background_state.dart';

class BackgroundCubit extends Cubit<BackgroundState> {
  BackgroundCubit() : super(BackgroundInitial());

  final List<String> backgrounds = [
    'assets/beach.jpg',
    'assets/camp.jpeg',
    'assets/city_big.jpg',
    'assets/city_night.jpg',
    'assets/city_snow.jpg',
    'assets/newyork.jpg',
    'assets/snow.jpg',
  ];

  void setBackgroundImage(String imagePath) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('background', imagePath);
    emit(BackgroundImage(imagePath));
  }

  void initBackground() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? imagePath = prefs.getString('background');
    if (imagePath != null) {
      emit(BackgroundImage(imagePath));
    }
  }
}
