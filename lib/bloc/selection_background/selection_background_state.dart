part of 'selection_background_cubit.dart';

@immutable
abstract class SelectionBackgroundState {}

class SelectionBackgroundInitial extends SelectionBackgroundState {}

class SelectionBackgroundChanged extends SelectionBackgroundState {
  final String selectedBackgroundPath;

  SelectionBackgroundChanged(this.selectedBackgroundPath);
}
