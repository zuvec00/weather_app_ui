import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_project/models/weather_model.dart';
import 'package:weather_app_project/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService("e03ae067c4af9060d65a71859a23ec44");
  Weather? _weather;
  ForecastWeather? _forecastWeather;

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
    if (mainCondition == null) return 'assets/images/clear_icon.png';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/images/cloud_icon.png';
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'fog':
      case 'rain':
        return 'assets/images/rain_icon.png';
      case 'drizzle':
        return 'assets/images/rain_icon.png';
      case 'shower rain':
        return 'assets/images/rain_icon.png';
      case 'thunderstorm':
        return 'assets/images/rain_icon.png';
      case 'clear':
        return 'assets/images/clear_icon.png';
      default:
        return 'assets/images/clear_icon.png';
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    // _fetchForecastWeather();
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
            getWeatherBackgorund(_weather?.mainCondition),
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
                  getCityName(_weather?.cityName) ?? 'loading city...',
                  style: TextStyle(fontSize: 18.sp),
                )
              ],
            ),
            Icon(
              Icons.menu,
              color: Colors.white,
              size: 32.sp,
            )
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
            getCurrentDate(_weather?.dateTime, false) ?? 'loading date ...',
            style: TextStyle(
              fontSize: 40.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          'Updated as of ${getCurrentDate(_weather?.dateTime, true) ?? 'loading date...'}',
          style: TextStyle(
            fontSize: 16.sp,
            //fontWeight: FontWeight.bold,
          ),
        ),
        Icon(Icons.sunny, color: Colors.amber),
        Text(
          _weather?.mainCondition ?? 'loading weather...',
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
                text: '${_weather?.temperature}' ?? 'loading temperature',
                style: TextStyle(fontSize: 86.sp, color: Colors.white),
              ),
              TextSpan(
                text: '˚C',
                style: TextStyle(
                    fontSize: 24.sp,
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
                  '${_weather?.humidity}%' ?? 'loading humidity...',
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
                  '${_weather?.windSpeed}km/h' ?? 'loading windspeed...',
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
                  '${_weather?.feelsLike}˚' ?? 'loading temp...',
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
          height: 153.h,
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
                    itemCount: dailyForecastData.length,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 40.w),
                        child: Column(
                          children: [
                            Text(
                              getForecastDate(dailyForecastData[index].dateTime)
                                  .toString(),
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            // Image.asset(getWeatherIcon(
                            //   dailyForecastData[index].mainCondition),height: 32.h,),
                            SizedBox(
                              height: 7.h,
                            ),
                            Text(
                              '${dailyForecastData[index].temperature}˚',
                              style: TextStyle(fontSize: 16.sp),
                            ),
                            SizedBox(
                              height: 7.h,
                            ),
                            Text(
                              '${dailyForecastData[index].temperature}',
                              style: TextStyle(fontSize: 10.sp),
                            ),
                            Text(
                              'km/h',
                              style: TextStyle(fontSize: 10.sp),
                            )
                          ],
                        ),
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
