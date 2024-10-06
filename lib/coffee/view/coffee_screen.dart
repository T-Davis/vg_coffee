import 'package:flutter/material.dart';
import 'package:vg_coffee/l10n/l10n.dart';

class CoffeeScreen extends StatelessWidget {
  const CoffeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CoffeeView();
  }
}

class CoffeeView extends StatelessWidget {
  const CoffeeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.coffeeAppBarTitle)),
      body: const Center(child: Text('Coffee Screen')),
    );
  }
}
