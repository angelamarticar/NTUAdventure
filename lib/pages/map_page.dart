import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/bottomNavigationBarCustom.dart';
import 'dart:io';
import 'package:logging/logging.dart';
import 'package:flutter/services.dart' show rootBundle;

final Logger logger = Logger('MapMarkersLogger');

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {


  static const LatLng _ntuaLocation= LatLng(37.977695472904564, 23.783499245883448);
  int _selectedIndex= 0;
  late GoogleMapController _mapController;

  
  BitmapDescriptor schoolIcon= BitmapDescriptor.defaultMarker;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _setupLogging(); // Configura el logging
    _loadMarkers();
  }


  Future<void> _loadMarkers() async {
    await BitmapDescriptor.asset(ImageConfiguration(size: Size(50.0, 50.0)), 'assets/images/school.png')
    .then((value){
      schoolIcon= value;
    });
    final newMarkers = await loadMarkersFromFile('assets/files/schoolLocations.txt', schoolIcon);
    setState(() {
      _markers.addAll(newMarkers);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: BottomNavigationBarCustom(
        _selectedIndex, context),
      body: SafeArea(
        child: GoogleMap(
          onMapCreated: (GoogleMapController controller){
            _mapController=controller;
          },
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          initialCameraPosition: CameraPosition(
                            target: _ntuaLocation,
                            zoom: 16.0),
          markers: _markers,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _moveCameraToNewLocation(_mapController, _ntuaLocation);
        },
        tooltip: "Move to NTUA",
        child: Icon(Icons.school),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }



}


void _setupLogging() {
    Logger.root.level = Level.ALL; // Define el nivel de logging
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}


void _moveCameraToNewLocation(GoogleMapController mapController, LatLng newLoc){
  mapController.animateCamera(
    CameraUpdate.newLatLng(newLoc),
  );
}

Future<Set<Marker>> loadMarkersFromFile(String filePath, BitmapDescriptor category) async {
  try {
    logger.info('********************************************************Intentando leer el archivo desde $filePath');


    // Usa rootBundle para cargar el contenido del archivo
    final String fileContent = await rootBundle.loadString(filePath);

    logger.info('********************************************Archivo leído con éxito. Procesando líneas...');
    List<String> lines = fileContent.split('\n'); // Divide por líneas

    return lines.asMap().entries.map((entry) {
      int index = entry.key;
      String line = entry.value.trim();

      // Valida el formato de la línea
      if (line.isEmpty || !line.contains(';')) {
        logger.warning('Línea inválida: $line');
        return null;
      }

      try {
        List<String> coords = line.split(';');
        double latitude = double.parse(coords[0].trim());
        double longitude = double.parse(coords[1].trim());
        String placeName = coords[2];
        String info= coords[3].trim();

        return Marker(
          markerId: MarkerId('marker_$index'),
          position: LatLng(latitude, longitude),
          icon: category,
          infoWindow: InfoWindow(
            title: placeName,
            snippet: info,
            ),
        );
      } catch (e) {
        logger.warning('Error procesando línea: $line - $e');
        return null;
      }
    }).whereType<Marker>().toSet();
  } catch (e, stackTrace) {
    logger.severe('****************************Error leyendo el archivo $filePath', e, stackTrace);
    return {};
  }
}
