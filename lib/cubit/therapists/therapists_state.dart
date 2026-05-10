import 'package:equatable/equatable.dart';

abstract class TherapistsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TherapistsInitial extends TherapistsState {}

class TherapistsLoading extends TherapistsState {}

class TherapistsLoaded extends TherapistsState {
  final List<Map<String, dynamic>> therapists;
  final List<Map<String, dynamic>> filtered;
  final Set<String> favorites;
  final String selectedCategory;

  TherapistsLoaded({
    required this.therapists,
    required this.filtered,
    required this.favorites,
    required this.selectedCategory,
  });

  @override
  List<Object?> get props => [
    therapists,
    filtered,
    favorites,
    selectedCategory,
  ];
}

class TherapistsError extends TherapistsState {
  final String message;
  TherapistsError(this.message);

  @override
  List<Object?> get props => [message];
}
