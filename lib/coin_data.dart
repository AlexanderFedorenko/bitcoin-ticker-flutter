import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const bitcoinAverageURL =
    'https://apiv2.bitcoinaverage.com/indices/global/ticker';

class CoinData {
  var lastPrice = {};

  CoinData() {
    cryptoList.forEach((String value) {
      lastPrice[value] = '?';
    });
  }

  Future getCoinData(String currency) async {
    cryptoList.forEach((String value) {
      lastPrice[value] = '?';
    });

    await Future.wait(cryptoList.map((String crypto) async {
      lastPrice[crypto] = await getCoinDataByCryptoAndFiat(crypto, currency);
    }));
  }

  Future getCoinDataByCryptoAndFiat(String crypto, String fiat) async {
    http.Response response = await http.get('$bitcoinAverageURL/$crypto$fiat');

    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      return decodedData['last'].toStringAsFixed(0);
    } else {
      print(response.statusCode);
      throw 'Problem with the get request';
    }
  }
}
