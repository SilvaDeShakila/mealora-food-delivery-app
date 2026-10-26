import '../models/restaurant.dart';
import '../models/food_item.dart';

const restaurants = <Restaurant>[
  Restaurant(
    id: 'r1',
    name: 'The Burger House',
    cuisine: 'Burgers • American',
    imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=900',
    rating: 4.8,
    deliveryTime: '20–30 min',
    deliveryFee: 150,
    priceLevel: 'Rs.',
    isFeatured: true,
  ),
  Restaurant(
    id: 'r2',
    name: 'Bella Italia',
    cuisine: 'Pizza • Italian',
    imageUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=900',
    rating: 4.7,
    deliveryTime: '25–35 min',
    deliveryFee: 200,
    priceLevel: 'Rs.',
    isFeatured: true,
  ),
  Restaurant(
    id: 'r3',
    name: 'Green Bowl',
    cuisine: 'Healthy • Salads',
    imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=900',
    rating: 4.6,
    deliveryTime: '15–25 min',
    deliveryFee: 100,
    priceLevel: 'Rs.',
  ),
  Restaurant(
    id: 'r4',
    name: 'Wok & Roll',
    cuisine: 'Asian • Noodles',
    imageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=900',
    rating: 4.5,
    deliveryTime: '20–30 min',
    deliveryFee: 180,
    priceLevel: 'Rs.',
  ),
];

const foodItems = <FoodItem>[
  FoodItem(
    id: 'f1', restaurantId: 'r1',
    name: 'Classic Smash Burger',
    description: 'Juicy beef patty, cheddar, lettuce and house sauce.',
    imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800',
    price: 1450, category: 'Burgers', isPopular: true,
  ),
  FoodItem(
    id: 'f2', restaurantId: 'r1',
    name: 'Crispy Chicken Burger',
    description: 'Crispy chicken, fresh greens and creamy mayo.',
    imageUrl: 'https://images.unsplash.com/photo-1606755962773-d324e0a13086?w=800',
    price: 1250, category: 'Burgers',
  ),
  FoodItem(
    id: 'f3', restaurantId: 'r1',
    name: 'Loaded Fries',
    description: 'Golden fries topped with cheese and herbs.',
    imageUrl: 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=800',
    price: 750, category: 'Sides',
    isVegetarian: true,
  ),
  FoodItem(
    id: 'f4', restaurantId: 'r2',
    name: 'Margherita Pizza',
    description: 'Tomato, mozzarella and fragrant basil.',
    imageUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=800',
    price: 1800, category: 'Pizza', isPopular: true,
    isVegetarian: true,
  ),
  FoodItem(
    id: 'f5', restaurantId: 'r2',
    name: 'Pepperoni Pizza',
    description: 'Classic pepperoni with melted mozzarella.',
    imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=800',
    price: 2200, category: 'Pizza',
  ),
  FoodItem(
    id: 'f6', restaurantId: 'r3',
    name: 'Rainbow Power Bowl',
    description: 'Fresh greens, avocado, grains and sesame dressing.',
    imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800',
    price: 1350, category: 'Healthy',
    isVegetarian: true,
  ),
  FoodItem(
    id: 'f7', restaurantId: 'r4',
    name: 'Chicken Noodles',
    description: 'Stir-fried noodles, vegetables and tender chicken.',
    imageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=800',
    price: 1200, category: 'Asian',
  ),
];

