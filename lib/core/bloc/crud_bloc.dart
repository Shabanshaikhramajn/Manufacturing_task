import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../base/base_repository.dart';
import 'crud_event.dart';
import 'crud_state.dart';

class CrudBloc<T> extends Bloc<CrudEvent<T>, CrudState<T>> {
  final BaseRepository<T> repository;

  CrudBloc(this.repository) : super(CrudInitial<T>()) {
    on<LoadAll<T>>(onLoadAllItems);
    on<AddItem<T>>(onAddItem);
    on<UpdateItem<T>>(onUpdateItem);
    on<DeleteItem<T>>(onDeleteItem);
  }

  Future<void> onLoadAllItems(LoadAll<T> event, Emitter<CrudState<T>> emit) async {
    emit(CrudLoading<T>());
    try {
      final items = await repository.getAll();
      emit(CrudLoaded<T>(items));
    } catch (e) {
      emit(CrudError<T>(e.toString()));
    }
  }

  Future<void> onAddItem(AddItem<T> event, Emitter<CrudState<T>> emit) async {
    try {
      await repository.add(event.item);
      final items = await repository.getAll();
      emit(CrudLoaded<T>(items));
    } catch (e) {
      emit(CrudError<T>(e.toString()));
    }
  }

  Future<void> onUpdateItem(UpdateItem<T> event, Emitter<CrudState<T>> emit) async {
    try {
      await repository.update(event.item);
      final items = await repository.getAll();
      emit(CrudLoaded<T>(items));
    } catch (e) {
      emit(CrudError<T>(e.toString()));
    }
  }

  Future<void> onDeleteItem(DeleteItem<T> event, Emitter<CrudState<T>> emit) async {
    try {
      await repository.delete(event.id);
      final items = await repository.getAll();
      emit(CrudLoaded<T>(items));
    } catch (e,stackTrace) {
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());

      emit(CrudError<T>(e.toString()));
    }
  }
}
