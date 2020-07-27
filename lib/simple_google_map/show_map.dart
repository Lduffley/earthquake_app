import 'package:flutter/material.dart'
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowSimpleMap extends StatefulWidget {
  @override
  _ShowSimpleMapState createState() => _ShowSimpleMapState();
}

class _ShowSimpleMapState extends State<ShowSimpleMap> {
  GoogleMapController mapController;
  static LatLng center = const LatLng(45.521563, -122.677433);

  static LatLng fargo = const LatLng(46.8772, -96.7898);

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps'),
      ),
      body: GoogleMap(
          markers: {portlandMarker, fargoMarker},
          mapType: MapType.hybrid,
          onMapCreated: onMapCreated,
          initialCameraPosition: CameraPosition(target: center, zoom: 11.0)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: goToIntel,
        label: Text('Intel Coorp'),
        icon: Icon(Icons.place),
      ),
    );
  }

  static final CameraPosition intelPosition =
      CameraPosition(target: LatLng(45.5418295, -122.9170456), zoom: 19);

  Future<void> goToIntel() async {
    final GoogleMapController controller = await mapController;
    controller.animateCamera(CameraUpdate.newCameraPosition(intelPosition));
  }

  Marker portlandMarker = Marker(
      markerId: MarkerId('Portland'),
      position: center,
      infoWindow:
          InfoWindow(title: 'Portland', snippet: 'This is a great town'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta));

  Marker fargoMarker = Marker(
      markerId: MarkerId('Fargo'),
      position: fargo,
      infoWindow: InfoWindow(title: 'Fargo'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue));
}
