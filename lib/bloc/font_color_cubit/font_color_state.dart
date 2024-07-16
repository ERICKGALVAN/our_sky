part of 'font_color_cubit.dart';

@immutable
abstract class FontColorState {}

class FontColorInitial extends FontColorState {}

class FontColorChange extends FontColorState {
  final String? fontColor;

  FontColorChange(this.fontColor);
}
