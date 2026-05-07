// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neurea/Medicain/Care_Plan_Screen.dart';
import 'package:neurea/cubit/therapists/therapists_cubit.dart';
import 'package:neurea/cubit/therapists/therapists_state.dart';
import 'package:neurea/therapists/presentation/screens/Therapist_list_Card.dart';
import 'package:neurea/therapists/presentation/screens/favorite_therapists_screen.dart';
import 'package:neurea/therapists/presentation/screens/therapist_details_screen.dart';

class TherapistsListScreen extends StatelessWidget {
  const TherapistsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TherapistsCubit()..loadTherapists(),
      child: const _TherapistsListBody(),
    );
  }
}

class _TherapistsListBody extends StatefulWidget {
  const _TherapistsListBody();

  @override
  State<_TherapistsListBody> createState() => _TherapistsListBodyState();
}

class _TherapistsListBodyState extends State<_TherapistsListBody> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCarePlanForTherapist(BuildContext context, Map<String, dynamic> therapist) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CarePlanScreen(
          therapistName: therapist['name'] ?? '',
          therapistImage: therapist['image'] ?? '',
          specialty: therapist['specialty'] ?? '',
          therapistId: therapist['id']?.toString() ?? '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TherapistsCubit, TherapistsState>(
      buildWhen: (prev, curr) => prev != curr,
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = context.read<TherapistsCubit>();
        final isLoading = state is TherapistsLoading;
        final filtered = state is TherapistsLoaded
            ? state.filtered
            : <Map<String, dynamic>>[];
        final therapists = state is TherapistsLoaded
            ? state.therapists
            : <Map<String, dynamic>>[];
        final favorites = state is TherapistsLoaded
            ? state.favorites
            : <String>{};
        final selectedCategory = state is TherapistsLoaded
            ? state.selectedCategory
            : 'All';

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: const Text(
              'All Therapists',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Image.asset(
                  'assets/medicine_profile.png',
                  width: 24,
                  height: 24,
                ),
                onPressed: () {
              
                  if (filtered.isNotEmpty) {
                    _openCarePlanForTherapist(context, filtered[0]);
                  } else if (therapists.isNotEmpty) {
                    _openCarePlanForTherapist(context, therapists[0]);
                  } else {
        
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CarePlanScreen(
                          therapistName: '',
                          therapistImage: '',
                          specialty: '',
                          therapistId: '',
                        ),
                      ),
                    );
                  }
                },
              ),
             
              IconButton(
                icon: Icon(
                  favorites.isEmpty ? Icons.favorite_border : Icons.favorite,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: cubit,
                        child: FavTherapistsScreen(
                          therapists: therapists,
                          favorites: favorites,
                          onToggleFavorite: (id) => cubit.toggleFavorite(id),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
           
              ColoredBox(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (q) => cubit.search(q),
                    decoration: InputDecoration(
                      hintText: 'Search doctor or specialty....',
                      hintStyle: const TextStyle(
                        color: Color(0xFFAAAAAA),
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF5C2D91),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              
              ColoredBox(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: ['All', 'Anxiety', 'Depression', 'Trauma', 'Family']
                          .map(
                            (cat) => Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: GestureDetector(
                                onTap: () => cubit.filterByCategory(cat),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selectedCategory == cat
                                        ? const Color(0xFF5C2D91)
                                        : Colors.white,
                                    border: selectedCategory == cat
                                        ? null
                                        : Border.all(
                                            color: const Color(0xFFE6E6E6),
                                          ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    cat,
                                    style: TextStyle(
                                      color: selectedCategory == cat
                                          ? Colors.white
                                          : const Color(0xFF4D5D64),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
             
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF5C2D91),
                        ),
                      )
                    : filtered.isEmpty
                        ? const Center(
                            child: Text(
                              'No therapists found',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ScrollConfiguration(
                            behavior: const ScrollBehavior().copyWith(overscroll: false),
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final therapist = filtered[index];
                                final isFav = favorites.contains(
                                  therapist['id'].toString(),
                                );
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => TherapistDetailsScreen(
                                          therapist: therapist,
                                        ),
                                      ),
                                    ),
                                    child: TherapistListCard(
                                      name: therapist['name'],
                                      specialty: therapist['specialty'],
                                      location: therapist['location'],
                                      rating: (therapist['rating'] as num?)?.toDouble() ?? 0.0,
                                      reviews: (therapist['reviews'] as num?)?.toInt() ?? 0,
                                      imagePath: therapist['image'],
                                      isFavorite: isFav,
                                      onFavoritePressed: () => cubit.toggleFavorite(
                                        therapist['id'].toString(),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
        );
      },
    );
  }
}