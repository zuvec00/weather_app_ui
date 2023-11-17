import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_project/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/3.0/onecall';
  // static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(latitude, longitude) async {
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

  Future<Map<String, double>> getCurrentLocation() async {
    //get permission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    Map<String, double> positionValues = {
      'latitude': position.latitude,
      'longitude': position.longitude
    };
    return positionValues;

    //convert the loaction into a list of placemark objects
  }

  Future<ForecastWeather> getForecastWeather(
    latitude,
    longitude,
    dateTime,
  ) async {
    final response = await http.get(
      Uri.parse(
          '$BASE_URL/timemachine?lat=$latitude&lon=$longitude&dt=$dateTime&appid=$apiKey&units=metric'),
    );
    if (response.statusCode == 200) {
      print('Response Body for forecast weather undecoded: ${response.body}');
      return ForecastWeather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load forecast weather data${response.body}');
    }
  }
}
