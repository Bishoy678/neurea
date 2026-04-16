class TherapistModel {
  final String id;
  final String name;
  final String specialty;
  final String location;
  final double rating;
  final int reviews;
  final String image;
  final String about;
  final int patients;
  final int experience;
  final double price;
  final bool isOnline;
  final DateTime createdAt;

  TherapistModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.image,
    required this.about,
    required this.patients,
    required this.experience,
    required this.price,
    required this.isOnline,
    required this.createdAt,
  });

  factory TherapistModel.fromJson(Map<String, dynamic> json) {
    return TherapistModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      specialty: json['specialty']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviews: (json['reviews'] as num?)?.toInt() ?? 0,
      image: json['image']?.toString() ?? '',
      about: json['about']?.toString() ?? '',
      patients: (json['patients'] as num?)?.toInt() ?? 0,
      experience: (json['experience'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      isOnline: json['is_online'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'location': location,
      'rating': rating,
      'reviews': reviews,
      'image': image,
      'about': about,
      'patients': patients,
      'experience': experience,
      'price': price,
      'is_online': isOnline,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
