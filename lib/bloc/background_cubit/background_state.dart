part of 'background_cubit.dart';

@immutable
abstract class BackgroundState {}

class BackgroundInitial extends BackgroundState {}

class BackgroundImage extends BackgroundState {
  BackgroundImage(this.imagePath);
  final String imagePath;
}
