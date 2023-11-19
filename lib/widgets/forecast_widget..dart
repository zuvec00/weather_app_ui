import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForecastWidget extends StatelessWidget {
  final String dateTime;
  final String weatherIcon;
  final int temperature;
  final double windSpeed;
  const ForecastWidget(
      {super.key,
      required this.dateTime,
      required this.temperature,
      required this.windSpeed,
      required this.weatherIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 40.w),
      child: Column(
        children: [
          Text(
            dateTime,
            style: TextStyle(fontSize: 14.sp),
          ),
          SizedBox(
            height: 12.h,
          ),
          Image.asset(
            weatherIcon,
            height: 32.h,
          ),
          SizedBox(
            height: 7.h,
          ),
          Text(
            '$temperature˚',
            style: TextStyle(fontSize: 16.sp),
          ),
          SizedBox(
            height: 7.h,
          ),
          Text(
            '$windSpeed',
            style: TextStyle(fontSize: 10.sp),
          ),
          Text(
            'km/h',
            style: TextStyle(fontSize: 10.sp),
          )
        ],
      ),
    );
  }
}
