part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeTabChanged extends HomeEvent {
  final int index;

  const HomeTabChanged(this.index);

  @override
  List<Object?> get props => [index];
}
