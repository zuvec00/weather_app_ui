import 'dart:convert';

import 'package:weather_app_project/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/3.0/onecall';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(double latitude, double longitude) async {
    final response = await http.get(
      Uri.parse(
          '$BASE_URL?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric'),
    );
    if (response.statusCode == 200) {
      print('Response Body undecoded: ${response.body}');
      print(jsonDecode(response.body));
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data${response.body}');
    }
  }
}
