// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neurea/cubit/therapists/therapists_cubit.dart';
import 'package:neurea/cubit/therapists/therapists_state.dart';
import 'package:neurea/therapists/presentation/screens/Therapist_list_Card.dart';
import 'package:neurea/therapists/presentation/screens/therapist_details_screen.dart';

class FavTherapistsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> therapists;
  final Set<String> favorites;
  final Function(String) onToggleFavorite;

  const FavTherapistsScreen({
    super.key,
    required this.therapists,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return const _FavBody();
  }
}

class _FavBody extends StatefulWidget {
  const _FavBody();

  @override
  State<_FavBody> createState() => _FavBodyState();
}

class _FavBodyState extends State<_FavBody> {
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TherapistsCubit, TherapistsState>(
      buildWhen: (prev, curr) => prev != curr,
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = context.read<TherapistsCubit>();

        final allTherapists = state is TherapistsLoaded
            ? state.therapists
            : <Map<String, dynamic>>[];
        final favorites = state is TherapistsLoaded
            ? state.favorites
            : <String>{};

        final favTherapists = allTherapists
            .where((t) => favorites.contains(t['id'].toString()))
            .where((t) {
              if (selectedCategory == 'All') return true;
              final specialty = t['specialty']?.toString().toLowerCase() ?? '';
              return specialty.contains(selectedCategory.toLowerCase());
            })
            .toList();

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Fav. Therapists',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: const [
              Icon(Icons.favorite, color: Colors.black),
              SizedBox(width: 12),
            ],
          ),
          body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(), 
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              children: [
                ColoredBox(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      onChanged: (q) => cubit.search(q),
                      decoration: InputDecoration(
                        hintText: 'Search doctor or specialty...',
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
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children:
                            ['All', 'Anxiety', 'Depression', 'Trauma', 'Family']
                                .map(
                                  (cat) => Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: GestureDetector(
                                      onTap: () =>
                                          setState(() => selectedCategory = cat),
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
                if (favTherapists.isEmpty)
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No favorite therapists yet',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tap the ♡ on any therapist to save them',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), 
                    padding: const EdgeInsets.all(16),
                    itemCount: favTherapists.length,
                    itemBuilder: (context, index) {
                      final therapist = favTherapists[index];
                      final id = therapist['id'].toString();
                      final isFav = favorites.contains(id);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TherapistListCard(
                          name: therapist['name']?.toString() ?? '',
                          specialty: therapist['specialty']?.toString() ?? '',
                          location: therapist['location']?.toString() ?? '',
                          rating: (therapist['rating'] as num?)?.toDouble() ?? 0.0,
                          reviews: (therapist['reviews'] as num?)?.toInt() ?? 0,
                          imagePath: therapist['image']?.toString() ?? '',
                          isFavorite: isFav,
                          onFavoritePressed: () => cubit.toggleFavorite(id),
                          onDetailsPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TherapistDetailsScreen(therapist: therapist),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}