class Product {
  final String id;
  final String name;
  final String imageAsset;
  final double pricePerDay;
  final double rating;
  final String owner;
  final String description;
  final String? category;
  final bool isBooked;

  const Product({
    required this.id,
    required this.name,
    required this.imageAsset,
    required this.pricePerDay,
    required this.rating,
    required this.owner,
    this.description = 'Barang ini adalah lorem ipsum dolores',
    this.category,
    this.isBooked = false,
  });
}
