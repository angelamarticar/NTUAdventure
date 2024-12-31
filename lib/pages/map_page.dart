import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/bottomNavigationBarCustom.dart';
import 'package:logging/logging.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:custom_info_window/custom_info_window.dart';
import '../theme/theme_helper.dart';


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
  final _customInfoWindowController = CustomInfoWindowController();
  
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
    final newMarkers = await loadMarkersFromFile(
      'assets/files/schoolLocations.txt', 
      schoolIcon, 
      _customInfoWindowController);
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
        child: Stack(
          children: [GoogleMap(
            onMapCreated: (GoogleMapController controller){
              _mapController=controller;
              _customInfoWindowController.googleMapController= controller;
            },
            onTap: (location){
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
                              target: _ntuaLocation,
                              zoom: 16.0),
            markers: _markers,
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 300,
            width: 350,
            offset: 0,
          ),
          ]
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

Future<Set<Marker>> loadMarkersFromFile(String filePath, BitmapDescriptor category, CustomInfoWindowController controller) async {
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
        LatLng position= LatLng(latitude, longitude);


        return Marker(
          markerId: MarkerId('marker_$index'),
          position: position,
          icon: category,
          onTap: (){
              controller.addInfoWindow!(
                CustomizedInfoWindow(placeName, info),
                LatLng(latitude, longitude)
              );
          },
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
/*
Widget CustomizedInfoWindowPhotos(String placeName, String info) {
  return Container(
    width: 150, // Ajusta el ancho del widget
    padding: const EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 6.0,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Dos imágenes en una fila
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                height: 150.0,
                width: 100.0,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(width: 8.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                height: 150.0,
                width: 100.0,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(width: 8.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                height: 150.0,
                width: 100.0,
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        // Título
        Text(
          placeName,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4.0),
        // Subtítulo o descripción
        Text(
          info,
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  );
}*/

Widget CustomizedInfoWindow(String placeName, String info) {
  return Container(
    width: 150, // Ajusta el ancho del widget
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black,
          blurRadius: 6.0,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 8.0),
        // Título
        Text(
          placeName,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4.0),
        // Subtítulo o descripción
        Text(
          info,
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8.0),
        Center(
          child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  'https://lh6.googleusercontent.com/proxy/6aMLu1r1U8kfFwZYFtHLzcXwZ3hEH3G-5jwOVHCMevM8DXWdn7iCtwxKBjaCjL35lGoS2Ir5nR1fNDZyeWBydq1EUJ85gA5V2muRbHJNeF5uZo8R4W7img',
                  height: 150.0,
                  width: 320.0,
                  fit: BoxFit.fill,
                ),
          ),
        ),
      ],
    ),
  );
}

