import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'selection_background_state.dart';

class SelectionBackgroundCubit extends Cubit<SelectionBackgroundState> {
  SelectionBackgroundCubit() : super(SelectionBackgroundInitial());

  void reset() {
    emit(SelectionBackgroundInitial());
  }

  void changeBackground(String imagePath) {
    emit(SelectionBackgroundChanged(imagePath));
  }
}
