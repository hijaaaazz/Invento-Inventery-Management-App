class Product {
  final String name;
  final String category;
  final String description;
  final String unit;
  final double rate;
  final double price;
  final double minlimit;
  final double maxlimit;
  final double stock;
  final String userId; // Add this line

  Product({
    required this.name,
    required this.category,
    required this.description,
    required this.unit,
    required this.rate,
    required this.price,
    required this.minlimit,
    required this.maxlimit,
    this.stock = 0,
    required this.userId, // Include userId as a required parameter
  });
}
