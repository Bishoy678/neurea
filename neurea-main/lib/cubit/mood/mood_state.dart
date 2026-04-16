import 'package:equatable/equatable.dart';

abstract class MoodState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MoodInitial extends MoodState {}

class MoodLoading extends MoodState {}

class MoodLoaded extends MoodState {
  final List<Map<String, dynamic>> moodHistory;
  final int streak;
  final String? todayMood;

  MoodLoaded({required this.moodHistory, required this.streak, this.todayMood});

  @override
  List<Object?> get props => [moodHistory, streak, todayMood];
}

class MoodSaved extends MoodState {}

class MoodError extends MoodState {
  final String message;
  MoodError(this.message);

  @override
  List<Object?> get props => [message];
}
