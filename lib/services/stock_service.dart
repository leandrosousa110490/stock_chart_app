import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:interactive_chart/interactive_chart.dart';

class StockService {
  final String _apiKey = '5LQMTJMBSE4AS0FL'; // Replace this with your API Key

  // Fetch stock data from Alpha Vantage and convert it to CandleData
  Future<List<CandleData>> fetchStockData(String stockSymbol) async {
    final url = Uri.parse(
        'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=$stockSymbol&apikey=$_apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data.containsKey('Time Series (Daily)')) {
        List<CandleData> stockData = [];
        Map<String, dynamic> timeSeries = data['Time Series (Daily)'];
        
        // Parse the data into a list of CandleData
        timeSeries.forEach((date, values) {
          stockData.add(CandleData(
            timestamp: DateTime.parse(date).millisecondsSinceEpoch,
            open: double.parse(values['1. open']),
            high: double.parse(values['2. high']),
            low: double.parse(values['3. low']),
            close: double.parse(values['4. close']),
            volume: double.parse(values['5. volume']),
          ));
        });
        
        return stockData.reversed.toList(); // Reverse to get oldest first
      } else {
        throw Exception('No stock data available.');
      }
    } else {
      throw Exception('Failed to fetch stock data. Status code: ${response.statusCode}');
    }
  }
}
