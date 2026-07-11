import 'package:equatable/equatable.dart';

abstract class CrudEvent<T> extends Equatable {
  const CrudEvent();
  @override
  List<Object?> get props => [];
}

class LoadAll<T> extends CrudEvent<T> {
  const LoadAll();
}

class AddItem<T> extends CrudEvent<T> {
  final T item;
  const AddItem(this.item);
  @override
  List<Object?> get props => [item];
}

class UpdateItem<T> extends CrudEvent<T> {
  final T item;
  const UpdateItem(this.item);
  @override
  List<Object?> get props => [item];
}

class DeleteItem<T> extends CrudEvent<T> {
  final int id;
  const DeleteItem(this.id);
  @override
  List<Object?> get props => [id];
}
