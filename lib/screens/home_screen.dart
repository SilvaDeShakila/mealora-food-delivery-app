import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/restaurant_data.dart';
import '../providers/cart_provider.dart';
import '../utils/app_constants.dart';
import '../widgets/restaurant_card.dart';
import 'restaurant_screen.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;
  String _search = '';
  String _category = 'All';

  final _categories = const [
    ('All', Icons.grid_view_rounded),
    ('Burgers', Icons.lunch_dining_rounded),
    ('Pizza', Icons.local_pizza_rounded),
    ('Healthy', Icons.eco_rounded),
    ('Asian', Icons.ramen_dining_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = restaurants.where((restaurant) {
      final query = _search.toLowerCase();
      final matchesSearch = restaurant.name.toLowerCase().contains(query) ||
          restaurant.cuisine.toLowerCase().contains(query);
      final matchesCategory = _category == 'All' ||
          restaurant.cuisine.toLowerCase().contains(_category.toLowerCase());
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedTab,
          children: [
            AnimatedOpacity(
              opacity: _selectedTab == 0 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              child: _buildHome(filtered),
            ),
            AnimatedOpacity(
              opacity: _selectedTab == 1 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              child: CartScreen(
                onExploreRestaurants: () => setState(() => _selectedTab = 0),
              ),
            ),
            AnimatedOpacity(
              opacity: _selectedTab == 2 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              child: OrdersScreen(
                onExploreFood: () => setState(() => _selectedTab = 0),
              ),
            ),
            AnimatedOpacity(
              opacity: _selectedTab == 3 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              child: const ProfileScreen(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildNavigation(),
    );
  }

  Widget _buildHome(List filtered) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 12),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppConstants.orange,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.restaurant_menu_rounded,
                        color: Colors.white, size: 27),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mealora',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: AppConstants.dark)),
                        Text('GOOD FOOD. GOOD MOOD.',
                            style: TextStyle(
                                fontSize: 9,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.muted)),
                      ],
                    ),
                  ),
                  Consumer<CartProvider>(
                    builder: (_, cart, __) => Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: IconButton(
                        onPressed: () => setState(() => _selectedTab = 1),
                        icon: Badge(
                          isLabelVisible: cart.itemCount > 0,
                          label: Text('${cart.itemCount}'),
                          child: const Icon(Icons.shopping_bag_outlined),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppConstants.dark,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  children: [
                    const Positioned(
                      right: -8,
                      bottom: -12,
                      child: Icon(Icons.fastfood_rounded,
                          size: 105, color: Color(0xFF45403B)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppConstants.orange,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text('TASTY DEALS',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  letterSpacing: 1.2)),
                        ),
                        const SizedBox(height: 16),
                        const Text('Cravings?\nWe got you.',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 29,
                                height: 1.12,
                                fontWeight: FontWeight.w900)),
                        const SizedBox(height: 10),
                        const Text('Discover your next favourite meal.',
                            style: TextStyle(
                                color: Color(0xFFD0C8C0), fontSize: 12)),
                        const SizedBox(height: 16),
                        const Row(
                          children: [
                            Icon(Icons.bolt_rounded,
                                color: AppConstants.orange, size: 18),
                            SizedBox(width: 5),
                            Text('Fresh picks. Fast delivery.',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                onChanged: (value) => setState(() => _search = value),
                decoration: const InputDecoration(
                  hintText: 'Search restaurants or cuisines...',
                  prefixIcon: Icon(Icons.search_rounded),
                  suffixIcon: Icon(Icons.tune_rounded),
                ),
              ),
              const SizedBox(height: 26),
              const Text('Explore categories',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppConstants.dark)),
              const SizedBox(height: 14),
              SizedBox(height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, index) {
                    final item = _categories[index];
                    final active = _category == item.$1;
                    return GestureDetector(
                      onTap: () => setState(() => _category = item.$1),
                      child: SizedBox(
                        width: 68,
                        child: Column(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: 58,
                              height: 58,
                              decoration: BoxDecoration(
                                color: active
                                    ? AppConstants.orange
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(19),
                                border: Border.all(
                                    color: active
                                        ? AppConstants.orange
                                        : const Color(0xFFF0ECE6)),
                              ),
                              child: Icon(item.$2,
                                  color: active
                                      ? Colors.white
                                      : AppConstants.dark,
                                  size: 25),
                            ),
                            const SizedBox(height: 7),
                            Text(item.$1,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: active
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: AppConstants.dark)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(
                    child: Text('Popular near you',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppConstants.dark)),
                  ),
                  Text('${filtered.length} places',
                      style: const TextStyle(
                          color: AppConstants.muted, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 15),
            ]),
          ),
        ),
        if (filtered.isEmpty)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: Text('No restaurants found. Try another search.',
                    textAlign: TextAlign.center),
              ),
            ),
          )
        else
          SliverToBoxAdapter(
            child: SizedBox(
              height: 275,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                scrollDirection: Axis.horizontal,
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (_, index) => RestaurantCard(
                  restaurant: filtered[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RestaurantScreen(
                          restaurant: filtered[index],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 28)),
      ],
    );
  }


  Widget _buildNavigation() {
    const items = [
      (Icons.home_rounded, 'Home'),
      (Icons.shopping_bag_outlined, 'Cart'),
      (Icons.receipt_long_rounded, 'Orders'),
      (Icons.person_outline_rounded, 'Profile'),
    ];

    return NavigationBar(
      selectedIndex: _selectedTab,
      onDestinationSelected: (index) =>
          setState(() => _selectedTab = index),
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFFFFE7DB),
      destinations: items
          .map((item) => NavigationDestination(
                icon: Icon(item.$1),
                label: item.$2,
              ))
          .toList(),
    );
  }
}





