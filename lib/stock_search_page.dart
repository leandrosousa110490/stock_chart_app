import 'package:flutter/material.dart';
import 'package:interactive_chart/interactive_chart.dart';
import 'services/stock_service.dart';
import 'full_screen_chart_page.dart';
import 'settings_page.dart';

class StockSearchPage extends StatefulWidget {
  final Function(ThemeMode) toggleTheme;  // Required parameter

  StockSearchPage({required this.toggleTheme});  // Ensure the required parameter is defined

  @override
  _StockSearchPageState createState() => _StockSearchPageState();
}

class _StockSearchPageState extends State<StockSearchPage> {
  String _searchText = '';
  List<CandleData> _stockPrices = [];
  bool _isLoading = false;
  String? _error;

  final StockService _stockService = StockService();

  Future<void> _searchStock() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final stockData = await _stockService.fetchStockData(_searchText.toUpperCase());

      setState(() {
        _stockPrices = stockData;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Price Chart'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    toggleTheme: widget.toggleTheme,
                    currentTheme: Theme.of(context).brightness == Brightness.dark
                        ? ThemeMode.dark
                        : ThemeMode.light,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (text) {
                _searchText = text;
              },
              decoration: InputDecoration(
                labelText: 'Search Stock Symbol',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _searchStock,
              child: Text('Search'),
            ),
            SizedBox(height: 16),
            if (_isLoading) CircularProgressIndicator(),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _error!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            Expanded(
              child: _stockPrices.isNotEmpty
                  ? Column(
                      children: [
                        Expanded(
                          child: InteractiveChart(
                            candles: _stockPrices,
                            style: ChartStyle(),
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to the full screen chart page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenChartPage(
                                  stockPrices: _stockPrices,
                                ),
                              ),
                            );
                          },
                          child: Text('View Full Screen'),
                        ),
                      ],
                    )
                  : Center(
                      child: Text('No stock data found. Search for a valid stock symbol.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
