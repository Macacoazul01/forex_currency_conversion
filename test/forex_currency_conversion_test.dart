import 'package:flutter_test/flutter_test.dart';

import 'package:forex_currency_conversion/forex_currency_conversion.dart';

void main() {
  test('Checks price of USD with itself', () async {
    final fx = Forex();
    final response = await fx.getAllCurrenciesPrices();
    expect(response["USD"], 1.0);
  });
}
