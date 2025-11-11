class Place {
  String name;
  String state;
  String category;
  String description;
  String image_url;
  num latitude;
  num longitude;
  String contact;
  num rating;

  Place({
    required this.name,
    required this.state,
    required this.category,
    required this.description,
    required this.image_url,
    required this.latitude,
    required this.longitude,
    required this.contact,
    required this.rating,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'] ?? '',
      state: json['state'] ?? '',
      image_url: json['image_url'] ?? '',
      description: json['description'] ?? '',
      contact: json['contact'] ?? '',
      category: json['category'] ?? '',
      latitude: json['latitude'],
      longitude: json['longitude'],
      rating: json['rating'],
    );
  }
}
