import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _apiKey = '17b898f0809c026e0b5a970cb1c353b5';
  static const String _apiUrl = 'https://api.openweathermap.org/data/3.0/onecall';

  Future<Map<String, dynamic>> getMansouraWeather() async {
    double latitude = 31.0409;
    double longitude = 31.3785;

    try {
      final response = await http.get(
        Uri.parse('$_apiUrl?lat=$latitude&lon=$longitude&exclude=minutely,hourly,alerts&units=metric&lang=ar&appid=$_apiKey'),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseWeatherData(data);
      } else {
        throw Exception('فشل في جلب البيانات: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('حدث خطأ: $e');
    }
  }

  Map<String, dynamic> _parseWeatherData(Map<String, dynamic> data) {
    final current = data['current'];
    final daily = data['daily'][0]; // أول يوم في التوقعات
    
    return {
      'current': {
        'temp': current['temp'],
        'feels_like': current['feels_like'],
        'humidity': current['humidity'],
        'wind_speed': current['wind_speed'],
        'weather': current['weather'][0]['description'],
        'icon': current['weather'][0]['icon'],
        'sunrise': DateTime.fromMillisecondsSinceEpoch(current['sunrise'] * 1000),
        'sunset': DateTime.fromMillisecondsSinceEpoch(current['sunset'] * 1000),
      },
      'daily': {
        'temp': {
          'day': daily['temp']['day'],
          'min': daily['temp']['min'],
          'max': daily['temp']['max'],
        },
        'weather': daily['weather'][0]['main'],
      },
    };
  }
}