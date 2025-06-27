import 'package:flutter/material.dart';
import 'dart:async';
import 'package:worldchef_mobile/src/core/utils/analytics_logger.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _showStripeSheet = false;

  void _onPayPressed() {
    AnalyticsLogger.logEvent('checkout_pay_pressed');
    setState(() {
      _showStripeSheet = true; // Optimistic launch placeholder
    });

    // Simulate async Stripe call
    Future.delayed(const Duration(seconds: 2), () {
      final success = true; // Pretend success path
      if (!mounted) return;
      if (success) {
        AnalyticsLogger.logEvent('checkout_success');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment successful!')),
        );
      } else {
        AnalyticsLogger.logEvent('checkout_error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment failed. Please try again.')),
        );
      }
      setState(() {
        _showStripeSheet = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Stack(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: _onPayPressed,
              child: const Text('Pay'),
            ),
          ),
          if (_showStripeSheet)
            Positioned.fill(
              child: Container(
                key: const Key('stripeSheet'),
                color: Colors.black.withOpacity(0.5),
                alignment: Alignment.center,
                child: const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text(
                      'Stripe Sheet Placeholder',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
