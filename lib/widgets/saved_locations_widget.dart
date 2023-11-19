import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SavedLocationsWidget extends StatelessWidget {
  final String cityName;
  final String mainCondition;
  final String weatherIcon;
  final int humidity;
  final int temperature;
  final double windSpeed;
  const SavedLocationsWidget(
      {super.key,
      required this.cityName,
      required this.mainCondition,
      required this.weatherIcon,
      required this.humidity,
      required this.temperature,
      required this.windSpeed});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 24.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
            color: const Color(0xB2AAA5A5),
            borderRadius: BorderRadius.circular(24.w)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 16.h),
            Text(cityName,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: 8.h),
            Text(
              mainCondition,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 22.h),
            RichText(
              text: TextSpan(
                //style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                    text: 'Humidity ',
                    style: GoogleFonts.roboto(
                        fontSize: 16.sp, color: Colors.white.withOpacity(0.8)),
                  ),
                  TextSpan(
                    text: '$humidity%',
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    // textScaleFactor: 0.8,
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.h),
            RichText(
              text: TextSpan(
                //style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                    text: 'Wind ',
                    style: GoogleFonts.roboto(
                        fontSize: 16.sp, color: Colors.white.withOpacity(0.8)),
                  ),
                  TextSpan(
                    text: '${windSpeed}km/h',
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    // textScaleFactor: 0.8,
                  ),
                ],
              ),
            ),
            SizedBox(height: 17.h),
          ]),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            SizedBox(height: 16.h),
            Image.asset(weatherIcon, height: 56.w),
            RichText(
              text: TextSpan(
                //style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                    text: '$temperature',
                    style: GoogleFonts.roboto(
                        fontSize: 48.sp, color: Colors.white),
                  ),
                  TextSpan(
                    text: '˚C',
                    style: GoogleFonts.roboto(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        fontFeatures: []),
                    // textScaleFactor: 0.8,
                  ),
                ],
              ),
            ),
            SizedBox(height: 25.h),
          ])
        ]));
  }
}
