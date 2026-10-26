import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/restaurant_data.dart';
import '../models/cart_item.dart';
import '../models/food_order.dart';

class OrderProvider extends ChangeNotifier {
  final List<FoodOrder> _orders = [];

  List<FoodOrder> get orders => List.unmodifiable(_orders);

  OrderStatus _simulatedStatus(DateTime createdAt) {
    final elapsed = DateTime.now().difference(createdAt).inSeconds;

    if (elapsed < 30) return OrderStatus.placed;
    if (elapsed < 60) return OrderStatus.confirmed;
    if (elapsed < 120) return OrderStatus.preparing;
    if (elapsed < 180) return OrderStatus.onTheWay;
    return OrderStatus.delivered;
  }

  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('cravego_orders');
    if (raw == null) return;

    try {
      final saved = jsonDecode(raw) as List<dynamic>;
      _orders.clear();

      for (final entry in saved) {
        final data = Map<String, dynamic>.from(entry as Map);
        final items = <CartItem>[];

        for (final rawItem in data['items'] as List<dynamic>) {
          final itemData = Map<String, dynamic>.from(rawItem as Map);
          final id = itemData['foodId'] as String;
          final quantity = itemData['quantity'] as int;

          for (final food in foodItems) {
            if (food.id == id) {
              items.add(CartItem(food: food, quantity: quantity));
              break;
            }
          }
        }

        final createdAt = DateTime.parse(data['createdAt'] as String);
        final statusName = data['status'] as String? ?? 'placed';
        final savedStatus = OrderStatus.values.firstWhere(
          (value) => value.name == statusName,
          orElse: () => OrderStatus.placed,
        );

        final status = savedStatus == OrderStatus.cancelled
            ? OrderStatus.cancelled
            : _simulatedStatus(createdAt);

        _orders.add(FoodOrder(
          id: data['id'] as String,
          items: items,
          subtotal: (data['subtotal'] as num).toDouble(),
          deliveryFee: (data['deliveryFee'] as num).toDouble(),
          total: (data['total'] as num).toDouble(),
          deliveryAddress: data['deliveryAddress'] as String,
          createdAt: createdAt,
          status: status,
          paymentMethod:
              data['paymentMethod'] as String? ?? 'Cash on Delivery',
        ));
      }

      await _saveOrders();
      notifyListeners();
    } catch (error) {
      debugPrint('Could not load saved orders: $error');
    }
  }

  Future<FoodOrder> placeOrder({
    required List<CartItem> items,
    required double deliveryFee,
    required String address,
    String paymentMethod = 'Cash on Delivery',
  }) async {
    if (items.isEmpty) {
      throw ArgumentError('Cannot place an empty order.');
    }
    if (address.trim().isEmpty) {
      throw ArgumentError('Delivery address is required.');
    }

    final subtotal = items.fold<double>(
      0,
      (sum, item) => sum + item.total,
    );
    final now = DateTime.now();

    final order = FoodOrder(
      id: 'ML${now.millisecondsSinceEpoch}',
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      total: subtotal + deliveryFee,
      deliveryAddress: address.trim(),
      createdAt: now,
      status: OrderStatus.placed,
      paymentMethod: paymentMethod,
    );

    _orders.insert(0, order);
    notifyListeners();
    await _saveOrders();
    return order;
  }

  Future<void> refreshSimulatedStatuses() async {
    var changed = false;

    for (var i = 0; i < _orders.length; i++) {
      final order = _orders[i];
      if (order.status == OrderStatus.cancelled) continue;

      final newStatus = _simulatedStatus(order.createdAt);
      if (newStatus == order.status) continue;

      _orders[i] = FoodOrder(
        id: order.id,
        items: order.items,
        subtotal: order.subtotal,
        deliveryFee: order.deliveryFee,
        total: order.total,
        deliveryAddress: order.deliveryAddress,
        createdAt: order.createdAt,
        status: newStatus,
        paymentMethod: order.paymentMethod,
      );
      changed = true;
    }

    if (changed) {
      notifyListeners();
      await _saveOrders();
    }
  }

  Future<void> updateStatus(
    String orderId,
    OrderStatus status,
  ) async {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index == -1) return;

    final old = _orders[index];
    _orders[index] = FoodOrder(
      id: old.id,
      items: old.items,
      subtotal: old.subtotal,
      deliveryFee: old.deliveryFee,
      total: old.total,
      deliveryAddress: old.deliveryAddress,
      createdAt: old.createdAt,
      status: status,
      paymentMethod: old.paymentMethod,
    );

    notifyListeners();
    await _saveOrders();
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _orders.map((order) => {
      'id': order.id,
      'items': order.items.map((item) => {
        'foodId': item.food.id,
        'quantity': item.quantity,
      }).toList(),
      'subtotal': order.subtotal,
      'deliveryFee': order.deliveryFee,
      'total': order.total,
      'deliveryAddress': order.deliveryAddress,
      'createdAt': order.createdAt.toIso8601String(),
      'status': order.status.name,
      'paymentMethod': order.paymentMethod,
    }).toList();

    await prefs.setString('cravego_orders', jsonEncode(data));
  }
}
