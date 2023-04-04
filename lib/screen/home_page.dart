import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  //api call with google geolocator
  determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    position= await Geolocator.getCurrentPosition();
    getWeatherData();
    print("my latitude is ${position!.latitude}  longitute is ${position!.longitude}");
  }


  Position ?position;

  Map<String,dynamic>? weatherMap;
  Map<String,dynamic>? forecastMap;




  getWeatherData()async{
    var weather=await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?lat=${position!.latitude}&lon=${position!.longitude}&appid=cc93193086a048993d938d8583ede38a&units=metric"));
    print("wweqwerqweqwewqeqwe ${weather.body}");
    var forecast=await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/forecast?lat=${position!.latitude}&lon=${position!.longitude}&appid=cc93193086a048993d938d8583ede38a&units=metric"));

    var weatherData=jsonDecode(weather.body);
    var forecastData=jsonDecode(forecast.body);

    setState(() {
      weatherMap=Map<String,dynamic>.from(weatherData);
      forecastMap=Map<String,dynamic>.from(forecastData);
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    determinePosition();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        Text(
                          "Location",
                          style: buildTextStyle(
                            20,
                            Colors.white,
                            FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text("Time")
                  ],
                ),
              ),
            ),
            ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
                return Container(
                  height: MediaQuery.of(context).size.height * .3,
                  color: Colors.deepOrangeAccent,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  TextStyle buildTextStyle(double fontSize, Color clr, FontWeight fw) =>
      TextStyle(
        fontSize: fontSize,
        color: clr,
        fontWeight: fw,
      );
}
