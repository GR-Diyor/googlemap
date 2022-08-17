import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/service/dio_service.dart';

import 'functions.dart';
import 'model/direction_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  late GoogleMapController _controller;
  Marker? _origin;
  Marker? _destination;
  Directions? _info;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(40.441078, 071.716952),
    zoom: 18.1519260406,
    bearing: 192.8334901395799,
    tilt: 59.440717697143555,
  );

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Google Maps"),
        actions: [
          if (_origin != null)
            TextButton(
              onPressed: () => _controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _origin!.position,
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.green,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text("ORIGIN"),
            ),
          if (_destination != null)
            TextButton(
              onPressed: () => _controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _origin!.position,
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.green,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text("DEST"),
            ),
          IconButton(
            onPressed: (){
              About(context);
            },
            icon: Icon(Icons.perm_device_info,color: Colors.white,),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (controller) => _controller = controller,
            markers: {
              if (_origin != null) _origin!,
              if (_destination != null) _destination!,
            },
            polylines: {
              if (_info != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: Colors.red,
                  width: 5,
                  points: _info!.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                ),
            },
            onLongPress: _addMarker,
          ),
          if (_info != null)
            Positioned(
              top: 20.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                    color: Colors.yellowAccent,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      ),
                    ]),
                child: Text(
                  '${_info!.totalDistance}, ${_info!.totalDuration}',
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.w400),
                ),
              ),
            )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () => _controller.animateCamera(_info != null
            ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0)
            : CameraUpdate.newCameraPosition(_kGooglePlex)),
        child: const Icon(
          Icons.center_focus_strong,
          color: Colors.white,
        ),
      ),
    );
  }

  _addMarker(LatLng pos) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      setState(() {
        _origin = Marker(
          markerId: const MarkerId("origin"),
          infoWindow: const InfoWindow(title: "Origin"),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
        //reset dest
        _destination = null;
        //reset info
        _info = null;
      });
    } else {
      setState(() {
        _destination = Marker(
          markerId: const MarkerId("destination"),
          infoWindow: const InfoWindow(title: "Destination"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });
      // get directions
      final directions = await DirectionsRepository().getDirections(
        origin: _origin!.position,
        destinination: pos,
      );
      setState(() => _info = directions);
    }
  }
}
