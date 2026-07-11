import 'package:equatable/equatable.dart';

enum LinkedView { componentOperation, machine }


class LinkedMasterViewState extends Equatable {
  final int? selectedComponentId;
  final LinkedView view;

  const LinkedMasterViewState({
    this.selectedComponentId,
    this.view = LinkedView.componentOperation,
  });

  LinkedMasterViewState copyWith({
    int? selectedComponentId,
    bool clearSelectedComponentId = false,
    LinkedView? view,
  }) {
    return LinkedMasterViewState(
      selectedComponentId:
          clearSelectedComponentId ? null : (selectedComponentId ?? this.selectedComponentId),
      view: view ?? this.view,
    );
  }

  @override
  List<Object?> get props => [selectedComponentId, view];
}
