import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _rapidApiKey = '24405c5fb7msh97c7ea8a489bcfdp1b30e9jsn4eee0bca0075';
  static const String _rapidApiHost = 'https://weather-api167.p.rapidapi.com/weather/current';

  Future<Map<String, dynamic>> getCurrentWeather() async {
    final response = await http.get(
      Uri.parse('https://$_rapidApiHost/api/weather/current?place=London%2CGB&units=metric&lang=en&mode=json'),
      headers: {
        'Accept': 'application/json',
        'x-rapidapi-host': _rapidApiHost,
        'x-rapidapi-key': _rapidApiKey,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data: ${response.statusCode}');
    }
  }
}