import 'cart_item.dart';

enum OrderStatus {
  placed,
  confirmed,
  preparing,
  onTheWay,
  delivered,
  cancelled,
}

class FoodOrder {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String deliveryAddress;
  final DateTime createdAt;
  final OrderStatus status;

  FoodOrder({
    required this.id,
    required List<CartItem> items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.deliveryAddress,
    required this.createdAt,
    this.status = OrderStatus.placed,
  }) : items = items.map((item) => item.copy()).toList();
}
