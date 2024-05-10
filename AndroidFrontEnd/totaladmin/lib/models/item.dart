class Item {
  final int itemId;
  final String name;
  final int quantity;
  final String description;
  final double price;
  final String justification;
  final String location;
  final String? rejectedReason;
  final String itemStatus;
  final int statusId;
  final int rowVersion;

  Item({
    required this.itemId,
    required this.name,
    required this.quantity,
    required this.description,
    required this.price,
    required this.justification,
    required this.location,
    this.rejectedReason,
    required this.itemStatus,
    required this.statusId,
    required this.rowVersion,
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
      rowVersion: json['rowVersion'],
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
      'rowVersion': rowVersion,
    };
  }

  double get subtotal => price * quantity;
  double get tax => subtotal * 0.05;
  double get grandTotal => subtotal + tax;
}
