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

  _fetchWeather() async {
    Map<String, double> location = await _weatherService.getCurrentLocation();
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

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      color: Colors.blue,
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
        Text(
          getCurrentDate(_weather?.dateTime, false) ?? 'loading date ...',
          style: TextStyle(
            fontSize: 40.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Updated as of ${getCurrentDate(_weather?.dateTime, true) ?? 'loading date...'}',
          style: TextStyle(
            fontSize: 16.sp,
            //fontWeight: FontWeight.bold,
          ),
        ),
      ]),
    ));
  }
}
