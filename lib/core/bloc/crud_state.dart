import 'package:equatable/equatable.dart';

abstract class CrudState<T> extends Equatable {
  const CrudState();
  @override
  List<Object?> get props => [];
}

class CrudInitial<T> extends CrudState<T> {
  const CrudInitial();
}

class CrudLoading<T> extends CrudState<T> {
  const CrudLoading();
}

class CrudLoaded<T> extends CrudState<T> {
  final List<T> items;
  const CrudLoaded(this.items);
  @override
  List<Object?> get props => [items];
}

class CrudError<T> extends CrudState<T> {
  final String message;
  const CrudError(this.message);
  @override
  List<Object?> get props => [message];
}
