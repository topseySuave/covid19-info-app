import 'package:covid_19_app/constant.dart';
import 'package:covid_19_app/services/countries_service.dart';
import 'package:covid_19_app/widgets/counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  var allCountriesRecord;
  Position _location = Position(latitude: 0.0, longitude: 0.0);

  Future<dynamic> _allRecords() async {
    allCountriesRecord = await CountryService.getAllCountriesData();
    return allCountriesRecord;
  }

  // _getCurrentLocation() async {
  //   Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;

  //   new Geolocator()
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
  //       .then((Position position) {
  //   print("here");
  //     setState(() {
  //       _location = position;
  //     });
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }
  void getCurrentLocation() async {
    try {
      GeolocationStatus geolocationStatus =
          await Geolocator().checkGeolocationPermissionStatus();
      //GeolocationStatus.granted
      
      Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;

      Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      setState(() {
        _location = position;
      });
    } catch (err) {
      print(err.message);
    }
  }

  @override
  void initState() {
    super.initState();
    allCountriesRecord = this._allRecords();
    getCurrentLocation();
  }

  @override
  void dispose() {
    print('disposing');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: new FlutterMap(
              options: new MapOptions(
                center: new LatLng(6.5244, 3.3792),
                zoom: 2.16,
                minZoom: 2.16,
                maxZoom: 5.0,
              ),
              layers: [
                new TileLayerOptions(
                  urlTemplate:
                      "https://api.mapbox.com/styles/v1/mapbox/{id}/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoidG9wc2V5c3VhdmUiLCJhIjoiY2s4bjl2cm14MGlpbjNlcnhhcGh3ZDRlMyJ9.iJnQe2rCz3WXYdV8rgNuRw",
                  additionalOptions: {
                    'id': 'dark-v10',
                  },
                ),
                new MarkerLayerOptions(
                  markers: [
                    new Marker(
                      width: 40.0,
                      height: 40.0,
                      point: new LatLng(6.5244, 3.3792),
                      builder: (ctx) => new Container(
                        child: new CoronaMarker(),
                      ),
                    ),
                    new Marker(
                      width: 40.0,
                      height: 40.0,
                      point: new LatLng(6.5244, 3.2792),
                      builder: (ctx) => new Container(
                        child: new CoronaMarker(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 64.0,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.only(top: 14.0, bottom: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    height: 45,
                    width: MediaQuery.of(context).size.width - 120.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colors.black26,
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset("assets/icons/maps-and-flags.svg"),
                        SizedBox(width: 20),
                        FutureBuilder(
                          future: allCountriesRecord,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              var countryStrings =
                                  CountryService.getCountriesStrings(
                                      snapshot.data);
                              return Expanded(
                                child: DropdownButton(
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  icon: SvgPicture.asset(
                                      "assets/icons/dropdown.svg"),
                                  value: countryStrings[0],
                                  items: countryStrings
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {},
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error loading countries');
                            }
                            return Text(
                              'loading...',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20.0,
            height: 160.0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder(
                future: allCountriesRecord,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (_location != null) {
                      print(
                          "my location: ${_location.latitude} - ${_location.longitude}");
                    } else {
                      print('no location');
                    }

                    return Container(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          // GestureDetector(
                          //   child: IconButton(
                          //     icon: Icon(Icons.thumb_up),
                          //     onPressed: () {
                          //       print('jellow');
                          //       getCurrentLocation();
                          //     },
                          //   ),
                          // ),
                          Container(
                            margin: EdgeInsets.only(left: 10.0),
                            child: Counter(
                              number: 234566.toString(),
                              color: kRecovercolor,
                              title: 'Locations',
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10.0),
                            child: Counter(
                              number: 234566.toString(),
                              color: kDeathColor,
                              title: 'Locations',
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10.0),
                            child: Counter(
                              number: 234566.toString(),
                              color: kInfectedColor,
                              title: 'Locations',
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10.0),
                            child: Counter(
                              number: 234566.toString(),
                              color: kPrimaryColor,
                              title: 'Locations',
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error in connection',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CoronaMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.red[300].withOpacity(0.5),
          borderRadius: BorderRadius.circular(50.0)),
      child: Text(" "),
    );
  }
}
