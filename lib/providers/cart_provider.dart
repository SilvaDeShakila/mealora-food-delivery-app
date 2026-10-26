import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/restaurant_data.dart';
import '../models/cart_item.dart';
import '../models/food_item.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items =>
      _items.values.map((item) => item.copy()).toList();

  int get itemCount =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _items.values.fold(0.0, (sum, item) => sum + item.total);

  bool get isEmpty => _items.isEmpty;

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('cravego_cart');
    if (raw == null) return;

    try {
      final saved = jsonDecode(raw) as List<dynamic>;
      _items.clear();

      for (final entry in saved) {
        final data = Map<String, dynamic>.from(entry as Map);
        final id = data['foodId'] as String;
        final quantity = data['quantity'] as int;

        for (final food in foodItems) {
          if (food.id == id && quantity > 0) {
            _items[id] = CartItem(food: food, quantity: quantity);
            break;
          }
        }
      }
      notifyListeners();
    } catch (_) {
      _items.clear();
    }
  }

  Future<void> addItem(FoodItem food) async {
    if (_items.containsKey(food.id)) {
      _items[food.id]!.quantity++;
    } else {
      _items[food.id] = CartItem(food: food);
    }
    notifyListeners();
    await _saveCart();
  }

  Future<void> increaseQuantity(String foodId) async {
    final item = _items[foodId];
    if (item == null) return;
    item.quantity++;
    notifyListeners();
    await _saveCart();
  }

  Future<void> decreaseQuantity(String foodId) async {
    final item = _items[foodId];
    if (item == null) return;

    if (item.quantity <= 1) {
      _items.remove(foodId);
    } else {
      item.quantity--;
    }
    notifyListeners();
    await _saveCart();
  }

  Future<void> removeItem(String foodId) async {
    _items.remove(foodId);
    notifyListeners();
    await _saveCart();
  }

  Future<void> clearCart() async {
    _items.clear();
    notifyListeners();
    await _saveCart();
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _items.values.map((item) => {
      'foodId': item.food.id,
      'quantity': item.quantity,
    }).toList();
    await prefs.setString('cravego_cart', jsonEncode(data));
  }
}
