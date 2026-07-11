import 'package:flutter_bloc/flutter_bloc.dart';
import 'linked_master_view_state.dart';


class LinkedMasterViewCubit extends Cubit<LinkedMasterViewState> {
  LinkedMasterViewCubit() : super(const LinkedMasterViewState());

  void selectComponent(int? componentId) {
    if (componentId == null) {
      emit(state.copyWith(clearSelectedComponentId: true));
    } else {
      emit(state.copyWith(selectedComponentId: componentId));
    }
  }

  void selectView(LinkedView view) {
    emit(state.copyWith(view: view));
  }
}
