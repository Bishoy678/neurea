import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neurea/cubit/therapists/therapists_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TherapistsCubit extends Cubit<TherapistsState> {
  TherapistsCubit() : super(TherapistsInitial());

  List<Map<String, dynamic>> _allTherapists = [];
  List<Map<String, dynamic>> _filtered = [];
  Set<String> _favorites = {};
  String _selectedCategory = 'All';
  String _searchQuery = '';

  Future<void> loadTherapists() async {
    emit(TherapistsLoading());
    try {
      final response = await Supabase.instance.client
          .from('therapists')
          .select();
      _allTherapists = List<Map<String, dynamic>>.from(response);
      _filtered = List.from(_allTherapists);
      _applyFilters();
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
    _applyFilters();
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void _applyFilters() {
    var filtered = List<Map<String, dynamic>>.from(_allTherapists);
    
    if (_selectedCategory != 'All') {
      filtered = filtered.where((t) {
        final specialty = t['specialty']?.toString().toLowerCase() ?? '';
        return specialty.contains(_selectedCategory.toLowerCase());
      }).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((t) {
        final name = t['name']?.toString().toLowerCase() ?? '';
        final specialty = t['specialty']?.toString().toLowerCase() ?? '';
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || specialty.contains(query);
      }).toList();
    }
    
    _filtered = filtered;
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