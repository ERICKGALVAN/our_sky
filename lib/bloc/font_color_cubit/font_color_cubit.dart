import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'font_color_state.dart';

class FontColorCubit extends Cubit<FontColorState> {
  FontColorCubit() : super(FontColorInitial());

  void setFontColor(String fontColor) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('fontColor', fontColor);
    emit(FontColorChange(fontColor));
  }

  void initFontColor() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? fontColor = prefs.getString('fontColor');

    emit(FontColorChange(fontColor));
  }
}
