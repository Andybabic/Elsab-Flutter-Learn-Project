import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class FlutterMapWidget extends StatelessWidget {
  const FlutterMapWidget({
    Key? key,
    required this.context,
    required this.lat,
    required this.long,
    this.locationIsUnknown = false,
  }) : super(key: key);

  final BuildContext context;
  final double lat;
  final double long;
  final bool locationIsUnknown;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(lat, long),
        zoom: 15.0,
      ),
      layers: [
        TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']),
        MarkerLayerOptions(
          markers: [
            Marker(
              width:
                  locationIsUnknown ? MediaQuery.of(context).size.width : 50.0,
              height: 50.0,
              point: LatLng(lat, long),
              builder: (ctx) => locationIsUnknown
                  ? Container(
                      color: Colors.grey[200],
                      child: Center(
                          child: Text("No Data",
                              style: TextStyle(color: Colors.red))))
                  : Container(
                      child: Icon(Icons.location_pin),
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
