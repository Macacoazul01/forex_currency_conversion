# forex_currency_conversion
![Build Status](https://img.shields.io/github/actions/workflow/status/Macacoazul01/forex_currency_conversion/dart.yml)
[![pub package](https://img.shields.io/pub/v/forex_currency_conversion.svg)](https://pub.dev/packages/forex_currency_conversion)

A Flutter package to quickly fetch Forex prices and perform currency conversions.

## Features

 - List of all forex prices in the open market.
 - Convert money from one currency to another using open market prices.

## Getting started

```dart
import 'package:forex_currency_conversion/forex_currency_conversion.dart';
```

## Usage


If you want the latest prices of all currencies with respect to price of USD, you can do it with minimal hassle.

```dart
  final fx = Forex();
  Map<String, double> allPrices = await fx.getAllCurrenciesPrices();
  print("Exchange rate of PKR: ${allPrices['PKR']}");
  print("Exchange rate of EUR: ${allPrices['EUR']}");
  print("Exchange rate of TRY: ${allPrices['TRY']}");
```

If you want to check the list of all the supported currencies, you can do it easily.

```dart
  final fx = Forex();
  List<String> availableCurrencies = await fx.getAvailableCurrencies();
  print("The list of all available currencies: ${availableCurrencies}");
```

For a simple currency conversion, you can use the following method for instant conversion. You must make sure you are entering only supported currencies, which can be obtained through the method provided above.

```dart
  final fx = Forex();
  double myPriceInPKR = await fx.getCurrencyConverted("USD", "PKR", 252.5);
  print("252.5 USD in PKR: ${myPriceInPKR}");
```

You can initialize the class with default values for source and destination currencies. Also for the number of decimal places.

```dart
  final fx = Forex(defaultDestinationCurrency: 'PKR', defaultSourceCurrency: 'EUR', defaultNumberOfDecimals: 1);
```

You can initialize the class already looking for the currency prices (use this only if you don't pretend to use the prices right after the initialization, as this is an async unawaited method):

```dart
  final fx = Forex(initializeOnCreation: true);
```

## Listen to currency list update and result

You can check the currency list update status and if there was an error during the call to the API:

```dart
  final fx = Forex();
  //get the ValueNotifier of the currency list update, to listen when the function starts/stops downloading data.
  ValueNotifier<bool> fx.getRunNotifier;

  //get the current status of the currency list update. `true` if it's still donwloading data.
  bool fx.getRunStatus;

  ///get the ValueNotifier of the currency list update result, to listen if the function ended or not in an error.
  ValueNotifier<String?> fx.getErrorNotifier;

  //check if the latest call to the currency list update function ended in an error. `null` if everything went ok.
  String? fx.getRunError;
```

## Additional information

This package uses real-time currency rates from a third-party prices provider convertmymoney.com. The forex prices are bound to their terms and conditions.
