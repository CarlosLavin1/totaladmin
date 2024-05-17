class Item {
  final int itemId;
  final String? name;
  final int quantity;
  final String? description;
  final double price;
  final String? justification;
  final String? location;
  final String? rejectedReason;
  final String? itemStatus;
  final int statusId;

  Item({
    required this.itemId,
    this.name,
    required this.quantity,
    this.description,
    required this.price,
    this.justification,
    this.location,
    this.rejectedReason,
    this.itemStatus,
    required this.statusId,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemId: json['itemId'],
      name: json['name'],
      quantity: json['quantity'],
      description: json['description'],
      price: json['price'].toDouble(),
      justification: json['justification'],
      location: json['location'],
      rejectedReason: json['rejectedReason'],
      itemStatus: json['itemStatus'],
      statusId: json['statusId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'name': name,
      'quantity': quantity,
      'description': description,
      'price': price,
      'justification': justification,
      'location': location,
      'rejectedReason': rejectedReason,
      'itemStatus': itemStatus,
      'statusId': statusId,
    };
  }

  double get subtotal => price * quantity;
  double get tax => subtotal * 0.05;
  double get grandTotal => subtotal + tax;

  @override
  String toString() {
    return 'Item{itemId: $itemId, name: $name, quantity: $quantity, price: $price}';
  }
}
