import 'package:vg_coffee/core/common_libs.dart';

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
    return const Center(
      child: Text('Coffee Screen'),
    );
  }
}
