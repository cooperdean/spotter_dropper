import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsView extends StatefulWidget {
  @override
  _MapsViewState createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  GoogleMapController _mapController;
  static const LatLng _center = const LatLng(53.434213, -103.575217);
  final Map<String, Marker> _markers = {};

  _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  _onCameraMove(CameraPosition position) {
    LatLng _lastMapPosition = position.target;
  }

  void _placeMarker() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    setState(() {
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: 'Current Location'),
      );
      _markers["Current Location"] = marker;
      _mapController.moveCamera(CameraUpdate.newLatLng(
          LatLng(currentLocation.latitude, currentLocation.longitude)));
    });
  }

  Future<String> _printCurrentLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    final coordinates =
        Coordinates(currentLocation.latitude, currentLocation.longitude);
    var address =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    return address.first.featureName;
  }

  void _getCurrentLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    setState(() {
      _mapController.moveCamera(CameraUpdate.newLatLng(
          LatLng(currentLocation.latitude, currentLocation.longitude)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(23.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: _getCurrentLocation,
                  child: Icon(Icons.center_focus_weak),
                  heroTag: null,
                ),
                SizedBox(height: 5),
                FloatingActionButton(
                  onPressed: _placeMarker,
                  child: Icon(Icons.flag),
                  heroTag: null,
                ),
                SizedBox(height: 5),
                FloatingActionButton(
                  onPressed: _placeMarker,
                  child: Icon(Icons.add),
                  heroTag: null,
                ),
              ],
            )
          ],
        ),
      ),
      body: Stack(children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(target: _center, zoom: 17.0),
          myLocationButtonEnabled: false,
          mapType: MapType.hybrid,
          markers: _markers.values.toSet(),
          onCameraMove: _onCameraMove,
        ),
        FutureBuilder(
            future: _printCurrentLocation(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return Padding(
                    padding: const EdgeInsets.fromLTRB(23.0, 64.0, 0.0, 0.0),
                    child: Container(
                        width: MediaQuery.of(context).size.width * .75,
                        child: Text(snapshot.data,
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))));
              } else {
                return Text("...");
              }
            })
      ]),
    );
  }
}
