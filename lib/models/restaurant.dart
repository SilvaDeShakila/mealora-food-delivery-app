class Restaurant {
  final String id;
  final String name;
  final String cuisine;
  final String imageUrl;
  final double rating;
  final String deliveryTime;
  final double deliveryFee;
  final String priceLevel;
  final bool isFeatured;

  const Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.imageUrl,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.priceLevel,
    this.isFeatured = false,
  });
}
