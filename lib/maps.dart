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
  static const LatLng _center = const LatLng(53.434213, -103.574917);
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
                SizedBox(height: 15),
                FloatingActionButton(
                  onPressed: _placeMarker,
                  child: Icon(Icons.flag),
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
            padding: EdgeInsets.only(left: 15.0)),
        FutureBuilder(
            future: _printCurrentLocation(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.06),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: screenWidth * 0.07,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Container(
                              child: Text(snapshot.data,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.055,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: Icon(
                                Icons.menu,
                                color: Colors.white,
                                size: screenWidth * 0.00,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return Text("");
              }
            }),
      ]),
    );
  }
}
