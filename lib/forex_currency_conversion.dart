library forex_currency_conversion;

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'dart:convert';
import '/extensions.dart';

/// A Calculator.
class Forex {
  //Initial parameters
  ///default currency used as source value reference of the conversions. This value will be used if none is defined when calling the class functions.
  final String defaultSourceCurrency;

  ///default currency used as destination value reference of the conversions. This value will be used if none is defined when calling the class functions.
  final String defaultDestinationCurrency;

  ///default number of decimals to be returned on the currency values and conversions. This value will be used if none is defined when calling the class functions.
  final int defaultNumberOfDecimals;

  ///force the code to already check the currency values/codes on initialization. Note that, as this is calls an async unawaited function, you'll need to wait some time before using the list of currencies.
  final bool initializeOnCreation;

  //Local variables
  final ValueNotifier<bool> _runNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<String?> _errorNotifier = ValueNotifier<String?>(null);
  Map<String, dynamic> _rates = {};
  List<String> _keys = [];

  //Getters
  ///get the ValueNotifier of the currency list update, to listen when the function starts/stops downloading data.
  ValueNotifier<bool> get getRunNotifier => _runNotifier;

  ///get the current status of the currency list update. `true` if it's still donwloading data.
  bool get getRunStatus => _runNotifier.value;

  ///get the ValueNotifier of the currency list update result, to listen if the function ended in an error.
  ValueNotifier<String?> get getErrorNotifier => _errorNotifier;

  ///check if the latest call to the currency list update function ended or not in an error. `null` if everything went ok.
  String? get getRunError => _errorNotifier.value;

  Forex({
    this.defaultSourceCurrency = 'USD',
    this.defaultDestinationCurrency = 'BRL',
    this.defaultNumberOfDecimals = 2,
    this.initializeOnCreation = false,
  }) {
    if (initializeOnCreation) {
      unawaited(_fetchCurrencies());
    }
  }

  /// function that fetches all avaliable currencies from API.
  Future<void> _fetchCurrencies() async {
    if (!getRunStatus) {
      _runNotifier.value = true;
      final Uri baseUri = Uri.parse('http://www.convertmymoney.com/rates.json');
      try {
        final Response response = await get(baseUri);
        final Map<String, dynamic> jsonResponse =
            json.decode(response.body) as Map<String, dynamic>;
        _rates = jsonResponse.remove("rates") as Map<String, dynamic>;
        _keys = _rates.keys.toList();
        _errorNotifier.value = null;
      } catch (e) {
        _errorNotifier.value = e.toString();
      }
      _runNotifier.value = false;
    }
  }

  /// checks if the currencies list is empty. If yes, calls _fetchCurrencies().
  Future<void> _checkCurrenciesList() async {
    if (_rates.isEmpty) {
      await _fetchCurrencies();
    }
  }

  /// resets currencies list.
  Future<void> updatePrices({bool blockIfUpdateError = false}) async {
    if (!(blockIfUpdateError && getRunError != null)) {
      await _fetchCurrencies();
    }
  }

  /// converts amount from one currency into another using current forex prices.
  Future<double> getCurrencyConverted(
      {String? sourceCurrency,
      String? destinationCurrency,
      double sourceAmount = 1,
      int? numberOfDecimals,
      bool blockIfUpdateError = false}) async {
    if (!(blockIfUpdateError && getRunError != null)) {
      await _checkCurrenciesList();
    }
    final String localSourceCurrency = sourceCurrency ?? defaultSourceCurrency;
    final String localDestinationCurrency =
        destinationCurrency ?? defaultDestinationCurrency;
    if (!_keys.contains(localSourceCurrency)) {
      _errorNotifier.value ??= "Source Currency provided was not found. Please Use ISO-4217 currency codes only.";
      return 0;
    }
    if (!_keys.contains(localDestinationCurrency)) {
      _errorNotifier.value ??=
          "Destination Currency provided was not found. Please Use ISO-4217 currency codes only.";
      return 0;
    }
    final double totalDollarsOfSourceCurrency =
        sourceAmount / _rates[localSourceCurrency];
    return (totalDollarsOfSourceCurrency * _rates[localDestinationCurrency])
        .toPrecision(numberOfDecimals ?? defaultNumberOfDecimals);
  }

  /// returns a Map containing prices of all currencies with their currency_code as key.
  Future<Map<String, double>> getAllCurrenciesPrices(
      {int? numberOfDecimals, bool blockIfUpdateError = false}) async {
    if (!(blockIfUpdateError && getRunError != null)) {
      await _checkCurrenciesList();
    }
    final Map<String, double> result = <String, double>{};
    final int decimals = numberOfDecimals ?? defaultNumberOfDecimals;
    for (final element in _keys) {
      result[element] =
          double.parse(_rates[element].toString()).toPrecision(decimals);
    }
    return result;
  }

  /// returns a list of all supported currencies.
  Future<List<String>> getAvailableCurrencies(
      {bool blockIfUpdateError = false}) async {
    if (!(blockIfUpdateError && getRunError != null)) {
      await _checkCurrenciesList();
    }
    return _keys;
  }
}
