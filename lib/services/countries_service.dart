import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class CountryService {

  static Future<WorldData> getWorldData() async {
    final res = await http.get('https://corona.lmao.ninja/v2/all');

    if (res.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return WorldData.fromJson(json.decode(res.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  static getAllCountriesData() async {
    final res = await http.get('https://enigmatic-savannah-36248.herokuapp.com/cov19-records');

    if (res.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print('res: ${json.decode(res.body)}');
      return json.decode(res.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  static List<String> getCountriesStrings(List<dynamic> countryList) {
    List<String> countryStrings = [];
    for (var item in countryList) {
      countryStrings.add(item["Country"]);
    }
    return countryStrings;
  }

  static List<Widget> getCounterCards(List<Map<String, String>> records) {
    records.map((items) {
      
    });
  }
}

class WorldData {
  final int updated;
  final int cases;
  final int todayCases;
  final int deaths;
  final int todayDeaths;
  final int recovered;
  final int active;
  final int critical;
  final int casesPerOneMillion;
  final int deathsPerOneMillion;
  final int tests;
  final double testsPerOneMillion;
  final int affectedCountries;

  WorldData({
    this.updated,
    this.cases,
    this.todayCases,
    this.deaths,
    this.todayDeaths,
    this.recovered,
    this.active,
    this.critical,
    this.casesPerOneMillion,
    this.deathsPerOneMillion,
    this.tests,
    this.testsPerOneMillion,
    this.affectedCountries
  });

  factory WorldData.fromJson(Map<String, dynamic> json) {
    return WorldData(
      updated: json['updated'] as int,
      cases: json['cases'] as int,
      todayCases: json['todayCases'] as int,
      deaths: json['deaths'] as int,
      todayDeaths: json['todayDeaths'] as int,
      recovered: json['recovered'] as int,
      active: json['active'] as int,
      critical: json['critical'] as int,
      casesPerOneMillion: json['casesPerOneMillion'] as int,
      deathsPerOneMillion: json['deathsPerOneMillion'] as int,
      tests: json['tests'] as int,
      testsPerOneMillion: json['testsPerOneMillion'],
      affectedCountries: json['affectedCountries'] as int,
    );
  }
}
