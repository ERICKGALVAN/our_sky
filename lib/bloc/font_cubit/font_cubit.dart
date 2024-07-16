import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'font_state.dart';

class FontCubit extends Cubit<FontState> {
  FontCubit() : super(FontInitial());

  void setFont(String font) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('font', font);
    emit(FontChange(font));
  }

  void initFont() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? font = prefs.getString('font');

    emit(FontChange(font));
  }
}
