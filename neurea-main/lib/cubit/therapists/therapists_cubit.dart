import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neurea/cubit/therapists/therapists_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TherapistsCubit extends Cubit<TherapistsState> {
  TherapistsCubit() : super(TherapistsInitial());

  List<Map<String, dynamic>> _allTherapists = [];
  List<Map<String, dynamic>> _filtered = [];
  Set<String> _favorites = {};
  String _selectedCategory = 'All';

  Future<void> loadTherapists() async {
    emit(TherapistsLoading());
    try {
      final response = await Supabase.instance.client
          .from('therapists')
          .select();
      _allTherapists = List<Map<String, dynamic>>.from(response);
      _filtered = List.from(_allTherapists);
      _emitLoaded();
    } catch (e) {
      emit(TherapistsError(e.toString()));
    }
  }

  void setTherapists(
    List<Map<String, dynamic>> therapists,
    Set<String> favorites,
  ) {
    _allTherapists = therapists;
    _filtered = List.from(therapists);
    _favorites = Set<String>.from(favorites);
    _emitLoaded();
  }

  void search(String query) {
    if (query.isEmpty) {
      _applyCategory(_selectedCategory);
      return;
    }
    _filtered = _allTherapists.where((t) {
      final name = t['name']?.toString().toLowerCase() ?? '';
      final specialty = t['specialty']?.toString().toLowerCase() ?? '';
      return name.contains(query.toLowerCase()) ||
          specialty.contains(query.toLowerCase());
    }).toList();
    _emitLoaded();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyCategory(category);
  }

  void _applyCategory(String category) {
    if (category == 'All') {
      _filtered = List.from(_allTherapists);
    } else {
      _filtered = _allTherapists.where((t) {
        final specialty = t['specialty']?.toString().toLowerCase() ?? '';
        return specialty.contains(category.toLowerCase());
      }).toList();
    }
    _emitLoaded();
  }

  void toggleFavorite(String id) {
    if (_favorites.contains(id)) {
      _favorites = Set.from(_favorites)..remove(id);
    } else {
      _favorites = Set.from(_favorites)..add(id);
    }
    emit(
      TherapistsLoaded(
        therapists: _allTherapists,
        filtered: _filtered,
        favorites: _favorites,
        selectedCategory: _selectedCategory,
      ),
    );
  }

  void _emitLoaded() {
    if (isClosed) return;
    emit(
      TherapistsLoaded(
        therapists: _allTherapists,
        filtered: _filtered,
        favorites: _favorites,
        selectedCategory: _selectedCategory,
      ),
    );
  }
}
