import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> _predictPrice(String stockSymbol) async {
  final apiKey = 'YOUR_ALPHA_VANTAGE_API_KEY';
  final url =
      'https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=$stockSymbol&interval=5min&apikey=$apiKey';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final timeSeries = data['Time Series (5min)'];
      if (timeSeries != null) {
        // Get the most recent price
        final latestEntry = timeSeries.entries.first.value;
        final price = latestEntry['4. close'];
        setState(() {
          _predictedPrice = "\$$price";
        });
      } else {
        setState(() {
          _predictedPrice = 'Data not available for $stockSymbol.';
        });
      }
    } else {
      setState(() {
        _predictedPrice = 'Error fetching data: ${response.statusCode}';
      });
    }
  } catch (e) {
    setState(() {
      _predictedPrice = 'Failed to fetch data: $e';
    });
  }
}
