import 'package:covid_19_app/utils/helpers.dart';
import 'package:http/http.dart' as http;

import 'package:covid_19_app/constant.dart';
import 'package:covid_19_app/map_screen.dart';
import 'package:covid_19_app/services/countries_service.dart';
import 'package:covid_19_app/widgets/counter.dart';
import 'package:covid_19_app/widgets/my_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.white,
    statusBarBrightness: Brightness.dark,
  ));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Covid 19',
      theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          fontFamily: "Poppins",
          textTheme: TextTheme(
            body1: TextStyle(color: kBodyTextColor),
          )),
      home: MapScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = ScrollController();
  double offset = 0;
  Future<WorldData> allRecord;

  @override
  void initState() {
    super.initState();
    controller.addListener(onScroll);
    allRecord = CountryService.getWorldData();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          children: <Widget>[
            MyHeader(
              image: "assets/icons/Drcorona.svg",
              textTop: "All you need",
              textBottom: "is stay at home.",
              offset: offset,
              isInfoScreen: false,
            ),
            FutureBuilder<WorldData>(
              future: allRecord,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // return Text(snapshot.data.cases.toString());
                  return Column(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Case Update\n",
                                      style: kTitleTextstyle,
                                    ),
                                    TextSpan(
                                      text: "Newest update March 28",
                                      style: TextStyle(
                                        color: kTextLightColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Text(
                                "See details",
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                            height: 160.0,
                            width: double.infinity,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                Counter(
                                  color: kInfectedColor,
                                  number: Helpers.addCommas(
                                      snapshot.data.cases.toString()),
                                  title: "Cases",
                                ),
                                Counter(
                                  color: kDeathColor,
                                  number: Helpers.addCommas(
                                      snapshot.data.deaths.toString()),
                                  title: "Deaths",
                                ),
                                Counter(
                                  color: kRecovercolor,
                                  number: Helpers.addCommas(
                                      snapshot.data.recovered.toString()),
                                  title: "Recovered",
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "View on Map",
                                style: kTitleTextstyle,
                              ),
                              Text(
                                "See details",
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen()));
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              padding: EdgeInsets.all(20),
                              height: 178,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 10),
                                    blurRadius: 30,
                                    color: kShadowColor,
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                "assets/images/map.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]);
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error in Connection"));
                }
                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
