library forex_currency_conversion;

import 'dart:async';

import 'package:http/http.dart';
import 'dart:convert';
import '/extensions.dart';

/// A Calculator.
class Forex {
  ///default currency used as source value reference of the conversions. This value will be used if none is defined when calling the class functions.
  final String defaultSourceCurrency;

  ///default currency used as destination value reference of the conversions. This value will be used if none is defined when calling the class functions.
  final String defaultDestinationCurrency;

  ///default number of decimals to be returned on the currency values and conversions. This value will be used if none is defined when calling the class functions.
  final int defaultNumberOfDecimals;

  ///force the code to already check the currency values/codes on initialization. Note that, as this is calls an async unawaited function, you'll need to wait some time before using the list of currencies.
  final bool initializeOnCreation;
  Map<String, dynamic> _rates = {};
  List<String> _keys = [];

  ///parameter to expose if the currency list of values update went ok.
  String? updateError;

  Forex({
    this.defaultSourceCurrency = 'USD',
    this.defaultDestinationCurrency = 'BRL',
    this.defaultNumberOfDecimals = 2,
    this.initializeOnCreation = false,
  }) {
    if (initializeOnCreation) {
      //TODO add listener to check when this finishes
      unawaited(_fetchCurrencies());
    }
  }

  /// function that fetches all avaliable currencies from API.
  Future<void> _fetchCurrencies() async {
    final Uri baseUri = Uri.parse('http://www.convertmymoney.com/rates.json');
    try {
      final Response response = await get(baseUri);
      final Map<String, dynamic> jsonResponse =
          json.decode(response.body) as Map<String, dynamic>;
      _rates = jsonResponse.remove("rates") as Map<String, dynamic>;
      _keys = _rates.keys.toList();
      updateError = null;
    } catch (e) {
      updateError = e.toString();
    }
  }

  /// checks if the currencies list is empty. If yes, calls _fetchCurrencies().
  Future<void> _checkCurrenciesList() async {
    if (_rates.isEmpty) {
      await _fetchCurrencies();
    }
  }

  /// resets currencies list.
  Future<String?> updatePrices({bool blockIfUpdateError = false}) async {
    if (!(blockIfUpdateError && updateError != null)) {
      await _fetchCurrencies();
    }
    return updateError;
  }

  /// converts amount from one currency into another using current forex prices.
  Future<double> getCurrencyConverted(
      {String? sourceCurrency,
      String? destinationCurrency,
      double sourceAmount = 1,
      int? numberOfDecimals,
      bool blockIfUpdateError = false}) async {
    if (!(blockIfUpdateError && updateError != null)) {
      await _checkCurrenciesList();
      if (updateError != null) {
        return 0;
      }
    }
    final String localSourceCurrency = sourceCurrency ?? defaultSourceCurrency;
    final String localDestinationCurrency =
        destinationCurrency ?? defaultDestinationCurrency;
    if (!_keys.contains(localSourceCurrency)) {
      throw Exception(
          "Source Currency provided is invalid. Please Use ISO-4217 currency codes only.");
    }
    if (!_keys.contains(localDestinationCurrency)) {
      throw Exception(
          "Destination Currency provided is invalid. Please Use ISO-4217 currency codes only.");
    }

    final double totalDollarsOfSourceCurrency =
        sourceAmount / _rates[localSourceCurrency];
    return (totalDollarsOfSourceCurrency * _rates[localDestinationCurrency])
        .toPrecision(numberOfDecimals ?? defaultNumberOfDecimals);
    //TODO add error
    //TODO remove exceptions
  }

  /// returns a Map containing prices of all currencies with their currency_code as key.
  Future<Map<String, double>> getAllCurrenciesPrices(
      {int? numberOfDecimals, bool blockIfUpdateError = false}) async {
    if (!(blockIfUpdateError && updateError != null)) {
      await _checkCurrenciesList();
    }
    final Map<String, double> result = <String, double>{};
    final int decimals = numberOfDecimals ?? defaultNumberOfDecimals;
    for (final element in _keys) {
      result[element] =
          double.parse(_rates[element].toString()).toPrecision(decimals);
    }
    return result;
    //TODO add error return
  }

  /// returns a list of all supported currencies.
  Future<List<String>> getAvailableCurrencies(
      {bool blockIfUpdateError = false}) async {
    if (!(blockIfUpdateError && updateError != null)) {
      await _checkCurrenciesList();
    }
    return _keys;
    //TODO add error return
  }
}
