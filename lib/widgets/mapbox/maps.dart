import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:elsab/res/custom_colors.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:map_launcher/map_launcher.dart';

class Maps extends StatefulWidget {
  final double lat;
  final double long;
  final String ort;
  static const String token =
      "pk.eyJ1IjoiYW5keWJhYmljIiwiYSI6ImNra21neW83OTM4aDgybm9jdWZrZWdodWwifQ.Km4UO1KksYF-tSRoy5pV5g";

  const Maps(
      {Key? key,
      this.lat = 48.207693975000964,
      this.long = 16.370696584519546,
      this.ort = ""})
      : super(key: key);

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {

  setMarker(MapboxMapController controller) async{
    await controller.addSymbol(
      SymbolOptions(
        iconImage: 'embassy-15',
        iconColor: '#006992',
        geometry: LatLng(widget.lat,widget.long),
      ),
    );
  }

  sendLocationToMaps(var map){
    return map.showMarker(
        coords: Coords(widget.lat, widget.long),
        title: "Test",
        extraParams: {
          'q' : widget.ort,
        }
    );
  }

  openMapsSheet(context) async {
    try {
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => sendLocationToMaps(map),
                        title: Text(map.mapName),
                        leading: Icon(Icons.map),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [
            Container(
              height: 200,
              child: MapboxMap(
                accessToken: Maps.token.toString(),
                onMapCreated: (MapboxMapController controller) => setMarker,
                styleString: "mapbox://styles/mapbox/streets-v11",
                initialCameraPosition:
                    CameraPosition(zoom: 15.0, target: LatLng(widget.lat, widget.long)),
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                  Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
                  ),
                ].toSet(),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () => openMapsSheet(context),
                child: Text("Maps öffnen"),
                style: ElevatedButton.styleFrom(
                  primary: Palette.firebaseOrange,
                  minimumSize: Size(double.infinity, double.infinity),
                ),
              ),
            ),
          ],
      ),
    );
  }
}
