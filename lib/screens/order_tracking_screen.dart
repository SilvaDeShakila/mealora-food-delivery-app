
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/food_order.dart';
import '../providers/order_provider.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({
    super.key,
    required this.order,
  });

  final FoodOrder order;

  @override
  State<OrderTrackingScreen> createState() =>
      _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  static const Color _orange = Color(0xFFE87524);
  static const Color _cream = Color(0xFFFFFBF5);
  static const int _deliveryDurationSeconds = 180;

  Timer? _refreshTimer;

  static const List<OrderStatus> _steps = [
    OrderStatus.placed,
    OrderStatus.confirmed,
    OrderStatus.preparing,
    OrderStatus.onTheWay,
    OrderStatus.delivered,
  ];

  static const List<String> _titles = [
    'Order Placed',
    'Order Confirmed',
    'Preparing Your Food',
    'On the Way',
    'Delivered',
  ];

  static const List<String> _descriptions = [
    'Your order has been received successfully.',
    'The restaurant has accepted your order.',
    'Your meal is being freshly prepared.',
    'Your delivery is on the way to you.',
    'Your order has been delivered. Enjoy your meal!',
  ];

  static const List<IconData> _icons = [
    Icons.receipt_long,
    Icons.check_circle_outline,
    Icons.soup_kitchen_outlined,
    Icons.delivery_dining,
    Icons.home_outlined,
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<OrderProvider>().refreshSimulatedStatuses();
    });

    _refreshTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) {
        if (!mounted) return;

        context.read<OrderProvider>().refreshSimulatedStatuses();
      },
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  String _formatElapsed(Duration elapsed) {
    if (elapsed.inSeconds < 0) return 'Just now';

    if (elapsed.inMinutes < 1) {
      return '${elapsed.inSeconds} sec ago';
    }

    final hours = elapsed.inHours;
    final minutes = elapsed.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m ago';
    }

    return '${elapsed.inMinutes} min ago';
  }

  String _formatRemaining(int seconds) {
    if (seconds <= 0) return 'Arrived';

    if (seconds < 60) {
      return 'Less than 1 min';
    }

    final minutes = (seconds / 60).ceil();
    return '$minutes min';
  }

  @override
  Widget build(BuildContext context) {
    final currentOrder = context
            .watch<OrderProvider>()
            .orders
            .where((item) => item.id == widget.order.id)
            .firstOrNull ??
        widget.order;

    final currentIndex = _steps.indexOf(currentOrder.status);
    final isCancelled =
        currentOrder.status == OrderStatus.cancelled;
    final isDelivered =
        currentOrder.status == OrderStatus.delivered;

    final elapsed = DateTime.now().difference(
      currentOrder.createdAt,
    );

    final remainingSeconds = (
      _deliveryDurationSeconds - elapsed.inSeconds
    ).clamp(0, _deliveryDurationSeconds);

    final progress = isCancelled
        ? 0.0
        : isDelivered
            ? 1.0
            : (currentIndex + 1) / _steps.length;

    final itemCount = currentOrder.items.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    final currentTitle = isCancelled
        ? 'Order Cancelled'
        : _titles[currentIndex < 0 ? 0 : currentIndex];

    final currentDescription = isCancelled
        ? 'This order has been cancelled.'
        : _descriptions[currentIndex < 0 ? 0 : currentIndex];

    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: _cream,
        title: const Text(
          'Track Order',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Main tracking card.
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFF20252D),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB16D)
                            .withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Icon(
                        isCancelled
                            ? Icons.cancel_outlined
                            : isDelivered
                                ? Icons.check_circle_outline
                                : Icons.delivery_dining,
                        color: const Color(0xFFFFB16D),
                        size: 32,
                      ),
                    ),
                    const Spacer(),
                    if (!isCancelled && !isDelivered)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF27864A)
                              .withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.circle,
                              color: Color(0xFF75D69A),
                              size: 8,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'LIVE DEMO',
                              style: TextStyle(
                                color: Color(0xFF75D69A),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  currentTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  currentDescription,
                  style: const TextStyle(
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 22),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.white24,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(
                      Color(0xFFFF9B50),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Order progress',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${(progress * 100).round()}%',
                      style: const TextStyle(
                        color: Color(0xFFFFB16D),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Estimated arrival.
          if (!isCancelled)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFF0E8DF),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE8D5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      isDelivered
                          ? Icons.check_circle_outline
                          : Icons.schedule,
                      color: _orange,
                      size: 27,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          isDelivered
                              ? 'Delivery completed'
                              : 'Estimated arrival',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          isDelivered
                              ? 'Enjoy your meal!'
                              : 'In ${_formatRemaining(remainingSeconds)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Placed ${_formatElapsed(elapsed)}',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 28),

          const Text(
            'Order progress',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),

          if (isCancelled)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.cancel_outlined, color: Colors.red),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'This order was cancelled.',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            ...List.generate(_steps.length, (index) {
              final completed = currentIndex >= index;
              final isCurrent = currentIndex == index;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 48,
                      child: Column(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(
                              milliseconds: 300,
                            ),
                            width: isCurrent ? 46 : 42,
                            height: isCurrent ? 46 : 42,
                            decoration: BoxDecoration(
                              color: completed
                                  ? _orange
                                  : const Color(0xFFF0E8DF),
                              shape: BoxShape.circle,
                              border: isCurrent
                                  ? Border.all(
                                      color: _orange.withValues(
                                        alpha: 0.25,
                                      ),
                                      width: 4,
                                    )
                                  : null,
                            ),
                            child: Icon(
                              completed
                                  ? Icons.check
                                  : _icons[index],
                              color: completed
                                  ? Colors.white
                                  : Colors.black45,
                              size: 21,
                            ),
                          ),
                          if (index < _steps.length - 1)
                            Expanded(
                              child: Container(
                                width: 2,
                                color: currentIndex > index
                                    ? _orange
                                    : const Color(0xFFE8DED3),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 3,
                          bottom: 26,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              _titles[index],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isCurrent
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                                color: completed
                                    ? Colors.black87
                                    : Colors.black45,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              _descriptions[index],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                height: 1.4,
                              ),
                            ),
                            if (isCurrent)
                              const Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(
                                  'CURRENT STATUS',
                                  style: TextStyle(
                                    color: _orange,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

          const SizedBox(height: 4),

          // Delivery details.
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFF0E8DF),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Delivery details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                _DetailRow(
                  icon: Icons.receipt_outlined,
                  label: 'Order ID',
                  value: currentOrder.id,
                ),
                const SizedBox(height: 12),
                _DetailRow(
                  icon: Icons.shopping_bag_outlined,
                  label: 'Items ordered',
                  value: '$itemCount item${itemCount == 1 ? '' : 's'}',
                ),
                const SizedBox(height: 12),
                _DetailRow(
                  icon: Icons.location_on_outlined,
                  label: 'Delivery address',
                  value: currentOrder.deliveryAddress,
                ),
                const SizedBox(height: 12),
                _DetailRow(
                  icon: Icons.payments_outlined,
                  label: 'Order total',
                  value:
                      'Rs. ${currentOrder.total.toStringAsFixed(2)}',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back to My Orders'),
            style: OutlinedButton.styleFrom(
              foregroundColor: _orange,
              minimumSize: const Size.fromHeight(50),
              side: const BorderSide(color: _orange),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: const Color(0xFFE87524),
          size: 20,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
