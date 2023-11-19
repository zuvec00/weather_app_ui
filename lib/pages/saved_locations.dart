import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app_project/models/weather_model.dart';
import 'package:weather_app_project/pages/weather_page.dart';
import 'package:weather_app_project/services/weather_service.dart';
import 'package:weather_app_project/widgets/saved_locations_widget.dart';

class SavedLocations extends StatefulWidget {
  const SavedLocations({super.key});

  @override
  State<SavedLocations> createState() => _SavedLocationsState();
}

class _SavedLocationsState extends State<SavedLocations> {
  final _weatherService = WeatherService("e03ae067c4af9060d65a71859a23ec44");

  List<String> savedLocations = ['Paris', 'New York', 'London'];
  List<Weather> weatherData = [];
  List<List<ForecastWeather>> dailyForecastData = [];

  Future<void> _initializeData() async {
    await _fetchForecastWeather();
    await _fetchWeather();
    await _addCurrentLocation();
    //Navigator.pop(context);
  }

  _addCurrentLocation() async {
    Map<String, double> location = await _weatherService.getCurrentLocation();
    print(location);
    try {
      final weather = await _weatherService.getWeather(
        location['latitude'],
        location['longitude'],
      );
      String? cityName = getCityName(weather.cityName);
      if (cityName != null) {
        setState(() {
          savedLocations.add(cityName);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  _fetchWeather() async {
    // print(location);
    try {
      for (var savedLocation in savedLocations) {
        Map<String, double> location =
            await _weatherService.getCoordinates(savedLocation);
        final Weather result = await _weatherService.getWeather(
          location['latitude'],
          location['longitude'],
        );
        setState(() {
          weatherData.add(result);
        });
      }
      // print(weatherData);
    } catch (e) {
      print(e);
    }
  }

  _fetchForecastWeather() async {
    for (var savedLocation in savedLocations) {
      Map<String, double> location =
          await _weatherService.getCoordinates(savedLocation);

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

      List<ForecastWeather> locationForecastData = [];

      for (var date in dates) {
        //get timestamps
        final int timestamp = date.millisecondsSinceEpoch ~/ 1000;
        // print(timestamp);
        final ForecastWeather result = await _weatherService.getForecastWeather(
            location['latitude'], location['longitude'], timestamp);
        locationForecastData.add(result);
      }
      dailyForecastData.add(locationForecastData);
    }

    // print(dailyForecastData);
  }

  String? getCityName(String? timezone) {
    if (timezone == null) {
      return null;
    }
    List<String> parts = timezone.split('/');

    String result = parts.length > 1 ? parts[1] : parts[0];
    return result;
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
    //_initializeData();
    return Scaffold(
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.21, -0.98),
                end: Alignment(0.21, 0.98),
                colors: [
                  Color(0xFF391A49),
                  Color(0xFF2F1D5B),
                  Color(0xFF262171),
                  Color(0xFF301D5B),
                  Color(0xFF391A49)
                ],
              ),
            ),
            child: Column(children: [
              SizedBox(height: 86.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Saved Locations',
                    style: GoogleFonts.poppins(
                        fontSize: 18.sp, color: Colors.white),
                  ),
                  Icon(Icons.search, color: Colors.white, size: 32.w)
                ],
              ),
              SizedBox(height: 24.h),
              Expanded(
                child: weatherData.length != savedLocations.length
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Fetching weather data. This process may require a few seconds... ',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(fontSize: 12.sp),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          CircularProgressIndicator(
                            color: Colors.white.withOpacity(0.8),
                            strokeWidth: 3.h,
                          )
                        ],
                      )
                    : ListView.builder(
                        //scrollDirection: Axis.horizontal,
                        itemCount: savedLocations.length + 1,
                        itemBuilder: ((context, index) {
                          return index == savedLocations.length
                              ? Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(top: 12.h),
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  decoration: BoxDecoration(
                                      color: const Color(0xB2AAA5A5),
                                      borderRadius:
                                          BorderRadius.circular(24.w)),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_circle_outline,
                                            size: 24.w,
                                            color:
                                                Colors.white.withOpacity(0.8)),
                                        SizedBox(width: 8.w),
                                        Text('Add new',
                                            style: GoogleFonts.poppins(
                                                fontSize: 24.sp,
                                                color: Colors.white
                                                    .withOpacity(0.8)))
                                      ]))
                              : InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WeatherPage(
                                          weatherObject: weatherData[index],
                                          forecastWeatherObject:
                                              dailyForecastData[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: SavedLocationsWidget(
                                      cityName: getCityName(
                                              weatherData[index].cityName) ??
                                          'loading city...',
                                      mainCondition:
                                          weatherData[index].mainCondition,
                                      weatherIcon: getWeatherIcon(
                                          weatherData[index].mainCondition),
                                      humidity: weatherData[index].humidity,
                                      temperature:
                                          weatherData[index].temperature,
                                      windSpeed: weatherData[index].windSpeed),
                                );
                        }),
                      ),
              )
            ])));
  }
}
