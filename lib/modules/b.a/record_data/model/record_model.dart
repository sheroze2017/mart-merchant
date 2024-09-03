class RecordModel {
  int id;
  String name;
  int quantityGm;
  double pricePkr;
  int stock;

  RecordModel({
    required this.id,
    required this.name,
    required this.quantityGm,
    required this.pricePkr,
    required this.stock,
  });

  // Convert a RecordModel object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity_gm': quantityGm,
      'price_pkr': pricePkr,
      'stock': stock,
    };
  }

  // Convert a Map to a RecordModel object
  factory RecordModel.fromMap(Map<String, dynamic> map) {
    return RecordModel(
      id: map['id'] ?? 0,
      name: map['name'],
      quantityGm: map['quantity_gm'],
      pricePkr: map['price_pkr'],
      stock: map['stock'],
    );
  }
}
