import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_project/models/weather_model.dart';
import 'package:weather_app_project/services/weather_service.dart';

import 'package:weather_app_project/pages/saved_locations.dart';
import 'package:weather_app_project/widgets/forecast_widget..dart';

class WeatherPage extends StatefulWidget {
  final Weather? weatherObject;
  final List<ForecastWeather>? forecastWeatherObject;
  const WeatherPage(
      {super.key, this.weatherObject, this.forecastWeatherObject});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService("e03ae067c4af9060d65a71859a23ec44");
  Weather? _weather;

  List<ForecastWeather> dailyForecastData = [];

  Future<void> _initializeData() async {
    await _fetchForecastWeather();
    await _fetchWeather();
  }

  _fetchWeather() async {
    Map<String, double> location = await _weatherService.getCurrentLocation();
    print(location);
    try {
      final weather = await _weatherService.getWeather(
        location['latitude'],
        location['longitude'],
      );
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  _fetchForecastWeather() async {
    Map<String, double> location = await _weatherService.getCurrentLocation();
    final List<DateTime> dates = [
      DateTime.now().add(
        const Duration(days: 1),
      ),
      DateTime.now().add(
        const Duration(days: 2),
      ),
      DateTime.now().add(
        const Duration(days: 3),
      ),
      DateTime.now().add(
        const Duration(days: 4),
      ),
    ];
    for (var date in dates) {
      //get timestamps
      final int timestamp = date.millisecondsSinceEpoch ~/ 1000;
      print(timestamp);
      final ForecastWeather result = await _weatherService.getForecastWeather(
          location['latitude'], location['longitude'], timestamp);
      dailyForecastData.add(result);
    }
    // setState(() {});

    print(dailyForecastData);
  }

  String? getCityName(String? timezone) {
    if (timezone == null) {
      return null;
    }
    List<String> parts = timezone.split('/');

    String result = parts.length > 1 ? parts[1] : parts[0];
    return result;
  }

  String? getCurrentDate(int? timestamp, bool moreInfo) {
    if (timestamp == null) {
      return null;
    }
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    String formattedDate = moreInfo
        ? DateFormat('M/d/yyyy hh:mm a').format(dateTime)
        : DateFormat('MMMM d').format(dateTime);

    return formattedDate;
  }

  String? getForecastDate(int? timestamp) {
    if (timestamp == null) {
      return null;
    }
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    String formattedDate = DateFormat('EEE d').format(dateTime);

    return formattedDate;
  }

  String getWeatherBackgorund(String? mainCondition) {
    print(mainCondition);
    if (mainCondition == null) return 'assets/images/clear.png';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/images/clouds.png';
      case 'mist':
        return 'assets/images/mist.png';
      case 'smoke':
      case 'haze':
        return 'assets/images/haze.png';
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
        return 'assets/images/thunder_storm.png';
      case 'drizzle':
        return 'assets/images/thunder_storm.png';
      case 'shower rain':
        return 'assets/images/thunder_storm.png';
      case 'thunderstorm':
        return 'assets/images/thunder_storm.png';
      case 'clear':
        return 'assets/images/clear.png';
      default:
        return 'assets/images/clear.png';
    }
  }

  String getWeatherIcon(String? mainCondition) {
    if (mainCondition == null) return 'assets/images/sun.png';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/images/cloudy.png';
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'fog':
        return 'assets/images/cloudy.png';
      case 'rain':
        return 'assets/images/rain.png';
      case 'drizzle':
        return 'assets/images/rain.png';
      case 'shower rain':
        return 'assets/images/rain.png';
      case 'thunderstorm':
        return 'assets/images/storm.png';
      case 'clear':
        return 'assets/images/sun.png';
      default:
        return 'assets/images/sun.png';
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    bool weatherObj = widget.weatherObject != null;
    bool forecastWeatherObj = widget.forecastWeatherObject != null;
    print('weatherModel:$weatherObj');
    return Scaffold(
        body: Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3), BlendMode.overlay),
          fit: BoxFit.cover,
          image: AssetImage(
            getWeatherBackgorund(weatherObj
                ? widget.weatherObject?.mainCondition
                : _weather?.mainCondition),
          ),
        ),
      ),
      child: Column(children: [
        SizedBox(
          height: 86.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  color: Colors.white,
                  size: 31.44.sp,
                ),
                SizedBox(
                  width: 4.w,
                ),
                Text(
                  getCityName(weatherObj
                          ? widget.weatherObject?.cityName
                          : _weather?.cityName) ??
                      'loading city...',
                  style: TextStyle(fontSize: 18.sp),
                )
              ],
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SavedLocations()));
                },
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 32.sp,
                ))
          ],
        ),
        SizedBox(
          height: 61.52.h,
        ),
        InkWell(
          onTap: () {
            _fetchForecastWeather();
          },
          child: Text(
            getCurrentDate(
                    weatherObj
                        ? widget.weatherObject?.dateTime
                        : _weather?.dateTime,
                    false) ??
                'loading date ...',
            style: TextStyle(
              fontSize: 40.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          'Updated as of ${getCurrentDate(weatherObj ? widget.weatherObject?.dateTime : _weather?.dateTime, true) ?? 'loading date...'}',
          style: TextStyle(
            fontSize: 16.sp,
            //fontWeight: FontWeight.bold,
          ),
        ),
        Image.asset(
          getWeatherIcon(weatherObj
              ? widget.weatherObject?.mainCondition
              : _weather?.mainCondition),
          height: 94.h,
        ),
        Text(
          '${weatherObj ? widget.weatherObject?.mainCondition : _weather?.mainCondition}',
          style: TextStyle(
            fontSize: 40.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        RichText(
          text: TextSpan(
            //style: DefaultTextStyle.of(context).style,
            children: [
              TextSpan(
                text:
                    '${weatherObj ? widget.weatherObject?.temperature : _weather?.temperature}',
                style: GoogleFonts.roboto(fontSize: 86.sp, color: Colors.white),
              ),
              TextSpan(
                text: '˚C',
                style: GoogleFonts.roboto(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    fontFeatures: [FontFeature.superscripts()]),
                // textScaleFactor: 0.8,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 62.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Icon(
                  Icons.water_drop_outlined,
                  size: 30.w,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  'HUMIDITY',
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  '${weatherObj ? widget.weatherObject?.humidity : _weather?.humidity}%',
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                )
              ],
            ),
            Column(
              children: [
                Icon(
                  Icons.air_rounded,
                  size: 30.w,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  'WIND',
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  '${weatherObj ? widget.weatherObject?.windSpeed : _weather?.windSpeed}km/h',
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                )
              ],
            ),
            Column(
              children: [
                Icon(
                  Icons.thermostat_rounded,
                  size: 30.w,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  'FEELS LIKE',
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  '${weatherObj ? widget.weatherObject?.feelsLike : _weather?.feelsLike}˚',
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                )
              ],
            ),
          ],
        ),
        SizedBox(
          height: 28.h,
        ),
        Container(
          height: 155.h,
          //width: 345.w,
          padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 18.h),
          decoration: BoxDecoration(
              color: Color(0xFF525252).withOpacity(0.6),
              borderRadius: BorderRadius.circular(24.w)),
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: forecastWeatherObj
                        ? widget.forecastWeatherObject!.length
                        : dailyForecastData.length,
                    itemBuilder: ((context, index) {
                      return ForecastWidget(
                        dateTime: getForecastDate(forecastWeatherObj
                                ? widget.forecastWeatherObject![index].dateTime
                                : dailyForecastData[index].dateTime) ??
                            '',
                        temperature: forecastWeatherObj
                            ? widget.forecastWeatherObject![index].temperature
                            : dailyForecastData[index].temperature,
                        windSpeed: forecastWeatherObj
                            ? widget.forecastWeatherObject![index].windSpeed
                            : dailyForecastData[index].windSpeed,
                        weatherIcon: getWeatherIcon(forecastWeatherObj
                            ? widget.forecastWeatherObject![index].mainCondition
                            : dailyForecastData[index].mainCondition),
                      );
                    })),
              ),
            ],
          ),
        )
      ]),
    ));
  }
}
