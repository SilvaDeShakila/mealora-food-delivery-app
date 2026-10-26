import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import 'orders_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cardholderController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  String _paymentMethod = 'Cash on Delivery';
  bool _isPlacingOrder = false;

  static const Color _orange = Color(0xFFE87524);
  static const Color _cream = Color(0xFFFFFBF5);
  static const double _deliveryFee = 250.0;

  bool get _isCardPayment => _paymentMethod == 'Card Payment (Demo)';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cardholderController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final subtotal = cart.subtotal;
    final total = subtotal + (cart.isEmpty ? 0 : _deliveryFee);

    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: _cream,
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: cart.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  _sectionTitle(Icons.location_on_outlined, 'Delivery details'),
                  const SizedBox(height: 14),
                  _inputField(
                    controller: _nameController,
                    label: 'Full name',
                    hint: 'Enter your name',
                    icon: Icons.person_outline,
                    validator: (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Please enter your name'
                            : null,
                  ),
                  const SizedBox(height: 14),
                  _inputField(
                    controller: _phoneController,
                    label: 'Phone number',
                    hint: 'Enter your contact number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().length < 9) {
                        return 'Enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  _inputField(
                    controller: _addressController,
                    label: 'Delivery address',
                    hint: 'House number, street, city',
                    icon: Icons.home_outlined,
                    maxLines: 3,
                    validator: (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Please enter your delivery address'
                            : null,
                  ),
                  const SizedBox(height: 26),
                  _sectionTitle(Icons.payment_outlined, 'Payment method'),
                  const SizedBox(height: 12),
                  _paymentOption(
                    title: 'Cash on Delivery',
                    subtitle: 'Pay cash when your order arrives',
                    icon: Icons.money,
                  ),
                  const SizedBox(height: 10),
                  _paymentOption(
                    title: 'Card Payment (Demo)',
                    subtitle: 'Try a simulated card payment',
                    icon: Icons.credit_card_outlined,
                  ),
                  if (_isCardPayment) ...[
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: _panelDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.credit_card,
                                color: _orange,
                                size: 26,
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  'Card details',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE8D5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'DEMO',
                                  style: TextStyle(
                                    color: _orange,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Use the sample details below. No real payment '
                            'will be made, and card details will not be saved.',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 18),
                          _inputField(
                            controller: _cardholderController,
                            label: 'Cardholder name',
                            hint: 'Demo User',
                            icon: Icons.person_outline,
                            validator: (value) {
                              if (!_isCardPayment) return null;
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter the cardholder name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          _inputField(
                            controller: _cardNumberController,
                            label: 'Card number',
                            hint: '4242 4242 4242 4242',
                            icon: Icons.credit_card,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (!_isCardPayment) return null;
                              final digits =
                                  (value ?? '').replaceAll(RegExp(r'\s'), '');
                              if (digits != '4242424242424242') {
                                return 'Use the demo card number shown above';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _inputField(
                                  controller: _expiryController,
                                  label: 'Expiry date',
                                  hint: '12/30',
                                  icon: Icons.calendar_month_outlined,
                                  keyboardType: TextInputType.datetime,
                                  validator: (value) {
                                    if (!_isCardPayment) return null;
                                    if (value?.trim() != '12/30') {
                                      return 'Use 12/30';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _inputField(
                                  controller: _cvvController,
                                  label: 'CVV',
                                  hint: '123',
                                  icon: Icons.lock_outline,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (!_isCardPayment) return null;
                                    if (value?.trim() != '123') {
                                      return 'Use 123';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF5E9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: _orange,
                                  size: 19,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Demo only: use 4242 4242 4242 4242, '
                                    '12/30 and CVV 123. Do not enter a real card.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 26),
                  _sectionTitle(Icons.receipt_long_outlined, 'Order summary'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: _panelDecoration(),
                    child: Column(
                      children: [
                        ...cart.items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.food.name} × ${item.quantity}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                Text(
                                  'Rs. ${(item.food.price * item.quantity).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(height: 24),
                        _summaryRow(
                          'Subtotal',
                          'Rs. ${subtotal.toStringAsFixed(2)}',
                        ),
                        const SizedBox(height: 10),
                        _summaryRow(
                          'Delivery fee',
                          'Rs. ${_deliveryFee.toStringAsFixed(2)}',
                        ),
                        const Divider(height: 24),
                        _summaryRow(
                          'Total',
                          'Rs. ${total.toStringAsFixed(2)}',
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 56,
                    child: FilledButton(
                      onPressed: _isPlacingOrder ? null : _placeOrder,
                      style: FilledButton.styleFrom(
                        backgroundColor: _orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isPlacingOrder
                          ? const SizedBox(
                              height: 23,
                              width: 23,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              _isCardPayment
                                  ? 'Pay Demo • Rs. ${total.toStringAsFixed(2)}'
                                  : 'Place Order • Rs. ${total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Your order details will be saved on this device.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFFFE8D5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: _orange),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      inputFormatters: keyboardType == TextInputType.number
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: _orange),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFF0E8DF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFF0E8DF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: _orange, width: 1.5),
        ),
      ),
    );
  }

  Widget _paymentOption({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final selected = _paymentMethod == title;

    return InkWell(
      onTap: () => setState(() => _paymentMethod = title),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFF0E4) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? _orange : const Color(0xFFF0E8DF),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: _orange, size: 27),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? _orange : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _panelDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFF0E8DF)),
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.normal,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: FontWeight.w900,
            color: isTotal ? _orange : Colors.black87,
          ),
        ),
      ],
    );
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final cart = context.read<CartProvider>();
    if (cart.isEmpty) return;

    setState(() => _isPlacingOrder = true);

    try {
      if (_isCardPayment) {
        final confirmed = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => AlertDialog(
            icon: const Icon(
              Icons.verified_outlined,
              color: Color(0xFF27864A),
              size: 42,
            ),
            title: const Text('Confirm Demo Payment'),
            content: const Text(
              'This is a simulated payment only. No money will be charged '
              'and your card details will not be saved.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: _orange,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Confirm Demo Payment'),
              ),
            ],
          ),
        );

        if (confirmed != true) return;

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Demo payment successful! No money was charged.'),
            backgroundColor: Color(0xFF27864A),
          ),
        );
      }

      await context.read<OrderProvider>().placeOrder(
        items: cart.items,
        deliveryFee: _deliveryFee,
        address: _addressController.text,
        paymentMethod: _paymentMethod,
      );
      await cart.clearCart();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isCardPayment
                ? 'Demo payment successful and order placed!'
                : 'Your order has been placed successfully!',
          ),
          backgroundColor: const Color(0xFF27864A),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => OrdersScreen(
            onExploreFood: () => Navigator.pop(context),
          ),
        ),
        (route) => route.isFirst,
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not place order: $error')),
      );
    } finally {
      if (mounted) setState(() => _isPlacingOrder = false);
    }
  }
}
