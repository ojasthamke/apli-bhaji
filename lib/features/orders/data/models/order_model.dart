class OrderModel {
  final int? id;
  final int customerId;
  final double totalAmount;
  final double discount;
  final double finalAmount;
  final String status; // Delivered, Pending, Cancelled
  final DateTime dateTime;
  final DateTime updatedAt;

  OrderModel({
    this.id,
    required this.customerId,
    required this.totalAmount,
    required this.discount,
    required this.finalAmount,
    required this.status,
    required this.dateTime,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'totalAmount': totalAmount,
      'discount': discount,
      'finalAmount': finalAmount,
      'status': status,
      'dateTime': dateTime.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'],
      customerId: map['customerId'],
      totalAmount: map['totalAmount'],
      discount: map['discount'],
      finalAmount: map['finalAmount'],
      status: map['status'],
      dateTime: DateTime.parse(map['dateTime']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}

class OrderItemModel {
  final int? id;
  final int orderId;
  final int itemId;
  final double quantity;
  final double price;
  final double mrp;
  final double total;

  OrderItemModel({
    this.id,
    required this.orderId,
    required this.itemId,
    required this.quantity,
    required this.price,
    required this.mrp,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'itemId': itemId,
      'quantity': quantity,
      'price': price,
      'mrp': mrp,
      'total': total,
    };
  }

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      id: map['id'],
      orderId: map['orderId'],
      itemId: map['itemId'],
      quantity: map['quantity'],
      price: map['price'],
      mrp: map['mrp'],
      total: map['total'],
    );
  }
}
