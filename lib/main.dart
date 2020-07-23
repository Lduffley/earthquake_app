import 'dart:async';
import 'package:earthquake_app/model/Quake.dart';
import 'package:earthquake_app/network/Network.dart';
import 'package:earthquake_app/simple_google_map/show_map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Quake> quakeData;
  // Has to be private
  Completer<GoogleMapController> _controller = new Completer();
  List<Marker> _markerList = <Marker>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    quakeData = Network().getAllQuakes();
    quakeData
        .then((value) => print('Place: ${value.features[0].properties.place}'));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            buildGoogleMap(context),
          ],
        ),
        bottomNavigationBar: FloatingActionButton.extended(
          onPressed: () {
            findQuakes();
          },
          label: Text('Find Quakes'),
        ),
      ),
    );
  }

  Widget buildGoogleMap(BuildContext context) {
    return Container(
//      width: MediaQuery.of(context).size.width,
//      height: MediaQuery.of(context).size.height,
      child: GoogleMap(
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        initialCameraPosition:
            CameraPosition(target: LatLng(36.1083333, -117.8608333), zoom: 3),
        markers: Set<Marker>.of(_markerList),
      ),
    );
  }

  void findQuakes() {
    setState(() {
      _markerList.clear(); // clear the map in the beginning
      handleResponse();
    });
  }

  void handleResponse() {
    setState(() {
      quakeData.then((quakes) => {
            quakes.features.forEach(
              (quake) => {
                _markerList.add(
                  Marker(
                    markerId: MarkerId(quake.id),
                    infoWindow: InfoWindow(
                        title: quake.properties.mag.toString(),
                        snippet: quake.properties.title),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue),
                    position: LatLng(
                      quake.geometry.coordinates[1],
                      quake.geometry.coordinates[0],
                    ),
                  ),
                ),
              },
            )
          });
    });
  }
}
