class Property {
  final int? id;
  final String title;
  final String address;
  final String? description;
  final double price;
  final String? imagePath;

  Property({
    this.id,
    required this.title,
    required this.address,
    this.description,
    required this.price,
    this.imagePath,
  });

  Property copyWith({
    int? id,
    String? title,
    String? address,
    String? description,
    double? price,
    String? imagePath,
  }) => Property(
    id: id ?? this.id,
    title: title ?? this.title,
    address: address ?? this.address,
    description: description ?? this.description,
    price: price ?? this.price,
    imagePath: imagePath ?? this.imagePath,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'address': address,
    'description': description,
    'price': price,
    'imagePath': imagePath,
  }..removeWhere((key, value) => value == null);

  factory Property.fromMap(Map<String, dynamic> map) => Property(
    id: map['id'] as int?,
    title: map['title'] as String,
    address: map['address'] as String,
    description: map['description'] as String?,
    price: (map['price'] as num).toDouble(),
    imagePath: map['imagePath'] as String?,
  );
}
