class Weather {
  final double feelsLike;
  final double humidity;
  final double temperature;
  final double windSpeed;
  final int dateTime;
  final String cityName;
  final String mainCondition;

  Weather(
      {required this.feelsLike,
      required this.humidity,
      required this.temperature,
      required this.windSpeed,
      required this.dateTime,
      required this.cityName,
      required this.mainCondition});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      feelsLike: json['current']['feels_like'],
      humidity: json['current']['humidity'],
      temperature: json['current']['temperature'],
      windSpeed: json['current']['wind_speed'],
      dateTime: json['current']['dt'],
      cityName: json['timezone'],
      mainCondition: json['current']['weather'][0]['main'],
    );
  }
}
