import 'package:vg_coffee/app/app.dart';
import 'package:vg_coffee/bootstrap.dart';

void main() {
  bootstrap((coffeeRepository) => App(coffeeRepository: coffeeRepository));
}
