import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
//import 'dart:convert';
//import 'dart:async'; // provides the future class
// provides the fun we will use to make HTTP GET requests

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  int currencyRate;
  String selectedCurrency = 'USD';
  String selectedCryptoCurrency = '';

  DropdownButton<String> andriodDropDownButton() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (int i = 0; i < currenciesList.length; i++) {
      String currency = currenciesList[i];
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
          print(value);
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> cupertinoItems = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      cupertinoItems.add(newItem);
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        selectedCurrency = currenciesList[selectedIndex];
        getData();
        print(selectedIndex);
      },
      children: cupertinoItems,
    );
  }

  /*
  Widget getPicker() {
    if (Platform.isIOS) {
      return iOSPicker();
    } else if (Platform.isAndroid) {
      return andriodDropDownButton();
    }
  }
   */

  CoinData coinData = CoinData(); // creating an object of CoinData class

  Map<String, String> coinValues = {};
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      var currency = await coinData.getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = currency;
      });
    } catch (e) {
      print(e);
    }
    //double currencyCovert = currency['rate'];
    //currencyRate = currencyCovert.toInt();
    //print(currencyRate);
    //return currencyRate;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Column makeCards() {
    List<CryptoCard> cryptoCards = [];

    for (String crypto in cryptoList) {
      cryptoCards.add(CryptoCard(
        cryptoCurrency: crypto,
        currencyRate: isWaiting ? '?' : coinValues[crypto],
        selectedCurrency: selectedCurrency,
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          makeCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : andriodDropDownButton(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  CryptoCard({
    @required this.cryptoCurrency,
    @required this.currencyRate,
    @required this.selectedCurrency,
  });

  final String currencyRate;
  final String cryptoCurrency;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $currencyRate $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
