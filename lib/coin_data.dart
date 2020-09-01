import 'dart:convert'; //provides the json variable we will use to decode the JSON string response
import 'package:http/http.dart' as http;

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

const List<String> cryptoList = ['BTC', 'ETH', 'LTC', 'XMR',];

const apiURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = 'C4F7386E-ECD2-482D-BAC4-BFEEDE6775EB';

class CoinData {
  Future<Map<String, String>> getCoinData(String selectedCurrency) async {
    Map<String, String> cryptoPrices = {};

    for (String crypto in cryptoList) {
      http.Response response =
          await http.get('$apiURL/$crypto/$selectedCurrency?apikey=$apiKey');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var decodeData = data['rate'];
        cryptoPrices[crypto] = decodeData.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'cannot access this data please check the url or your connection';
      }
    }
    return cryptoPrices;
  }
}
