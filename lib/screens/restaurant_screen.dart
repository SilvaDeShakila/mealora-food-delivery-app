import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/restaurant.dart';
import '../data/restaurant_data.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';
import '../utils/app_constants.dart';

class RestaurantScreen extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantScreen({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    final menu = foodItems
        .where((food) => food.restaurantId == restaurant.id)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 230,
            pinned: true,
            backgroundColor: AppConstants.dark,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                restaurant.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    restaurant.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppConstants.dark,
                      child: const Icon(
                        Icons.restaurant_rounded,
                        size: 80,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Consumer<CartProvider>(
                builder: (context, cart, _) => Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Center(
                    child: Badge(
                      isLabelVisible: cart.itemCount > 0,
                      label: Text('${cart.itemCount}'),
                      child: IconButton(
                        tooltip: 'View cart',
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
                        icon: const Icon(Icons.shopping_bag_outlined),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.cuisine,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppConstants.muted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFFFB800), size: 21),
                      const SizedBox(width: 4),
                      Text(
                        restaurant.rating.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.schedule_rounded,
                          size: 18, color: AppConstants.muted),
                      const SizedBox(width: 5),
                      Text(restaurant.deliveryTime),
                      const SizedBox(width: 16),
                      const Icon(Icons.delivery_dining_rounded,
                          size: 20, color: AppConstants.orange),
                      const SizedBox(width: 4),
                      Text('Rs. ${restaurant.deliveryFee.toStringAsFixed(0)}'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Explore the menu',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      color: AppConstants.dark,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${menu.length} delicious choices waiting for you',
                    style: const TextStyle(color: AppConstants.muted),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          if (menu.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: Text('No menu items available yet.')),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final food = menu[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFF1EAE2)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              food.imageUrl,
                              width: 112,
                              height: 118,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 112,
                                height: 118,
                                color: const Color(0xFFFFE7DB),
                                child: const Icon(
                                  Icons.fastfood_rounded,
                                  size: 38,
                                  color: AppConstants.orange,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (food.isPopular)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFE7DB),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'BESTSELLER',
                                      style: TextStyle(
                                        color: AppConstants.orange,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.7,
                                      ),
                                    ),
                                  ),
                                if (food.isPopular)
                                  const SizedBox(height: 5),
                                Text(
                                  food.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: AppConstants.dark,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  food.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    height: 1.35,
                                    color: AppConstants.muted,
                                  ),
                                ),
                                const SizedBox(height: 9),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Rs. ${food.price.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                          color: AppConstants.dark,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 36,
                                      child: FilledButton(
                                        style: FilledButton.styleFrom(
                                          backgroundColor: AppConstants.orange,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(11),
                                          ),
                                        ),
                                        onPressed: () async {
                                          await context
                                              .read<CartProvider>()
                                              .addItem(food);

                                          if (!context.mounted) return;

                                          ScaffoldMessenger.of(context)
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    '${food.name} added to cart'),
                                                duration: const Duration(
                                                    seconds: 2),
                                              ),
                                            );
                                        },
                                        child: const Text(
                                          '+ Add',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: menu.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
