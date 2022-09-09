import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:live_cricket_1/splash_screen.dart';
import 'dart:convert';
import 'screen2.dart';
import 'package:live_cricket_1/screen2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _homepageState();
}

// ignore: camel_case_types
class _homepageState extends State<HomePage> {
  TextEditingController city = TextEditingController();

  int humidity = 0;
  // ignore: non_constant_identifier_names
  double pressure_Pa = 0.0;
  // ignore: non_constant_identifier_names
  double temp_c = 0;
  // ignore: non_constant_identifier_names
  double temp_f = 0.0;
  // ignore: non_constant_identifier_names
  double windspeed_mph = 0.0;
  // ignore: non_constant_identifier_names
  String city_name = "";
  // ignore: non_constant_identifier_names
  String country_name = "";
  String state = "";
  String localtime = "";
  @override
  void initState() {
    super.initState();
  }

  fetchapi() async {
    String baseurl =
        "http://api.weatherapi.com/v1/current.json?key=15ad0b62807a4db49ec131051222701&q=${city.text}&aqi=yes";
    String apikey = "15ad0b62807a4db49ec131051222701 ";
    try {
      var res = await http
          .get(Uri.parse(baseurl), headers: {"Authentication": apikey});
      if (res.statusCode == 200) {
        var result = jsonDecode(res.body);
        city_name = result["location"]["name"];
        country_name = result["location"]["country"];
        localtime = result["location"]["localtime"];
        temp_c = result["current"]["temp_c"];
        temp_f = result["current"]["temp_f"];
        windspeed_mph = result["current"]["wind_mph"];
        pressure_Pa = result["current"]["pressure_in"];
        humidity = result["current"]["humidity"];
        state = result["location"]["region"];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => secondscreen(
                      city_name,
                      state,
                      country_name,
                      localtime,
                      temp_c.toString(),
                      temp_f.toString(),
                      windspeed_mph.toString(),
                      humidity.toString(),
                      pressure_Pa.toString(),
                    )));

        setState(() {});

        print(res.body);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text("The place you entered we have no details about it")));
      }
      print(res.statusCode);
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Something Went wrong")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assests/images/mainscreen.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 70),
              child: Text(
                "WEATHER APP",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: city,
                    decoration: InputDecoration(
                        hintText: 'ENTER YOUR CITY ',
                        hintStyle: const TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: MaterialButton(
                      onPressed: () async {
                        await fetchapi();
                      },
                      child: const Text(
                        "SUBMIT",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
