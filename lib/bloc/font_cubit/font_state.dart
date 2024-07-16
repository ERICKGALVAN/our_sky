part of 'font_cubit.dart';

@immutable
abstract class FontState {}

class FontInitial extends FontState {}

class FontChange extends FontState {
  final String? font;

  FontChange(this.font);
}
