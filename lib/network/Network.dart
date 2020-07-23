import 'dart:convert';

import 'package:earthquake_app/model/Quake.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Network {
  Future<Quake> getAllQuakes() async {
    var apiURL =
        'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson';

    final response = await get(Uri.encodeFull(apiURL));

    if (response.statusCode == 200) {
      print('Quake data: ${response.body}');
      return Quake.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error getting quakes');
    }
  }
}
