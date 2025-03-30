class WeatherData {
  final double temp;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String description;
  final String icon;
  final DateTime date;
  final AirQuality? airQuality;

  WeatherData({
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
    required this.date,
    this.airQuality,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temp: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      date: DateTime.parse(json['dt_txt']),
      airQuality: json['air_quality'] != null 
          ? AirQuality.fromJson(json['air_quality']) 
          : null,
    );
  }
}

class AirQuality {
  final double co;
  final double no2;
  final double o3;
  final double pm25;
  final double pm10;
  final int aqi;

  AirQuality({
    required this.co,
    required this.no2,
    required this.o3,
    required this.pm25,
    required this.pm10,
    required this.aqi,
  });

  factory AirQuality.fromJson(Map<String, dynamic> json) {
    return AirQuality(
      co: json['co'].toDouble(),
      no2: json['no2'].toDouble(),
      o3: json['o3'].toDouble(),
      pm25: json['pm2_5'].toDouble(),
      pm10: json['pm10'].toDouble(),
      aqi: json['aqi'],
    );
  }
}