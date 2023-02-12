import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: FirstPage());
  }
}

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 180, 230, 255),
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text(
              "CommuterScience",
              style: GoogleFonts.lobsterTwo(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 48),
            ),
            SizedBox(width: 3),
            Image.asset("assets/bus.png", height: 65),
          ],
        ),
        toolbarHeight: 105,
      ),
      body: Center(child: _buildList(context)),
    );
  }

  Widget _buildList(context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(30),
          child: const Image(
            image: AssetImage("assets/GoogleMapTA.webp"),
          ),
        ),
        Container(
          height: 100,
          padding: const EdgeInsets.all(25),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
              );
            },
            child: Text("Map",
                style: GoogleFonts.abel(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                )),
          ),
        ),
        Container(
          height: 100,
          padding: const EdgeInsets.all(25),
          child: ElevatedButton(
            onPressed: () {},
            child: Text("Share Location",
                style: GoogleFonts.abel(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                )),
          ),
        ),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Completer<GoogleMapController> _controller = Completer();
  var _latitude = '';
  var _longitude = '';
  var _altitude = '';
  var _speed = '';
  var _address = '';

  static const LatLng sourceLocation = LatLng(35.913200, -79.055847);

  Future<void> _updatePosition() async {
    Position pos = await _determinePosition();
    List pm = await placemarkFromCoordinates(pos.latitude, pos.longitude);
    setState(() {
      _latitude = pos.latitude.toString();
      _longitude = pos.longitude.toString();
      _altitude = pos.altitude.toString();
      _speed = pos.speed.toString();
      _address = pm[0].toString();
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    addCustomIcon();
    super.initState();
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(), "assets/rsz_busmarker.png")
      .then(
        (icon) {
          setState(() {
            markerIcon = icon;
          });
        }
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Location")),
        body: GoogleMap(initialCameraPosition: CameraPosition(target: sourceLocation, zoom: 14.5
        ),
        markers: {
            Marker(
              markerId: const MarkerId("marker1"),
              position: const LatLng(35.913200, -79.055847),
              icon: markerIcon,
            ),
            Marker(
              markerId: const MarkerId("marker2"),
              position: const LatLng(35.923500, -79.055897),
              icon: markerIcon,
            ),
          },
        ),
      );
  }
}
  //       body: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             const Text('Your Current Location'),
  //             Text(_latitude),
  //             Text(_longitude),
  //           ],
  //         ),
  //       ),
  //       floatingActionButton: FloatingActionButton(
  //         onPressed: _updatePosition,
  //         tooltip: 'Get Current Location',
  //         child: const Icon(Icons.change_circle_outlined),
  //       ));
  // }

//  class OrderTrackingPage extends StatefulWidget {
//   const OrderTrackingPage({Key? key}) : super(key: key);

//   @override
//   State<OrderTrackingPage> createState() => OrderTrackingPageState();
// }

// class OrderTrackingPageState extends State<OrderTrackingPage> {
//   final Completer<GoogleMapController> _controller = Completer();

  // static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  // static const LatLng destination = LatLng(37.33429383, -122.06600055);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Track order",
//           style: TextStyle(color: Colors.black, fontSize: 16),
//         ),
//       ),
//       body: GoogleMap(initialCameraPosition: CameraPosition(target: sourceLocation, zoom: 14.5)),
//       );
//   }
// }