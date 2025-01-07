import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/bottomNavigationBarCustom.dart';
import 'package:logging/logging.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:custom_info_window/custom_info_window.dart';
import '../pages/camera.dart';
import '../db_helper.dart';
import 'dart:io';
import 'dart:math';

final Logger logger = Logger('MarkersLogger');

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
  BitmapDescriptor eatingIcon= BitmapDescriptor.defaultMarker;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _setupLogging(); // Configura el logging
    _loadMarkers();
  }

    @override
  void dispose() {
    // Closes the map controller
    _mapController.dispose();
    // Closes the custom info window controller
    _customInfoWindowController.dispose();
    // Llama a la implementación base de dispose
    super.dispose();
  }


  Future<void> _loadMarkers() async {
    await BitmapDescriptor.asset(ImageConfiguration(size: Size(50.0, 50.0)), 'assets/images/school.png')
    .then((value){
      schoolIcon= value;
    });
    await BitmapDescriptor.asset(ImageConfiguration(size: Size(50.0, 50.0)), 'assets/images/eating.png')
    .then((value){
      eatingIcon= value;
    });
    final newMarkersSchool = await loadMarkersFromFile(
      'assets/files/schoolLocations.txt', 
      schoolIcon, 
      _customInfoWindowController,
      context);
    final newMarkersEating = await loadMarkersFromFile(
      'assets/files/eatingLocations.txt', 
      eatingIcon, 
      _customInfoWindowController,
      context);
    setState(() {
      _markers.addAll(newMarkersSchool);
      _markers.addAll(newMarkersEating);
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

Future<Set<Marker>> loadMarkersFromFile(String filePath, BitmapDescriptor category, CustomInfoWindowController controller, BuildContext context) async {
  try {
    logger.info('---------------------------------------trying to read file from: $filePath');


    // Usa rootBundle para cargar el contenido del archivo
    final String fileContent = await rootBundle.loadString(filePath);
    

    logger.info('---------------------------------------Archivo leído con éxito. Procesando líneas...');
    List<String> lines = fileContent.split('\n'); // Divide por líneas

    return lines.asMap().entries.map((entry) {
      int index = entry.key;
      String line = entry.value.trim();

      // Valida el formato de la línea
      if (line.isEmpty || !line.contains(';')) {
        logger.warning('***************************************Línea inválida: $index');
        return null;
      }

      try {
        List<String> coords = line.split(';');
        double latitude = double.parse(coords[0].trim());
        double longitude = double.parse(coords[1].trim());
        String placeName = coords[2].trim();
        String info= coords[3].trim();
        LatLng position= LatLng(latitude, longitude);
        

        if(context.mounted){
          if(filePath=='assets/files/schoolLocations.txt'){
            logger.info(placeName);
            String imageLink= coords[4].trim();
              return Marker(
                markerId: MarkerId('marker_$placeName'),
                position: position,
                icon: category,
                onTap: (){
                    controller.addInfoWindow!(
                      CustomizedInfoWindow(placeName, info, context, imageLink),
                      LatLng(latitude, longitude)
                    );
                },
            );
          } else if(filePath=='assets/files/eatingLocations.txt'){  
            return Marker(
                markerId: MarkerId('marker_$placeName'),
                position: position,
                icon: category,
                onTap: (){
                    controller.addInfoWindow!(
                      CustomizedInfoWindowPhotos(placeName, info, context),
                      LatLng(latitude, longitude)
                    );
                }
            );
          }
        } else{
          logger.warning('Error loading context');
        }
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

Widget CustomizedInfoWindowPhotos(String placeName, String info, BuildContext context) {

  return Container(
      width: 150,
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
          Text(
            placeName,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            info,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8.0),
          ElevatedButton.icon(
            label: const Text('Share a photo!'),
            style: ButtonStyle(
              padding: WidgetStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              foregroundColor: WidgetStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CameraScreen(placeName: placeName),
                ),
              );
            },
            icon: const Icon(Icons.photo_camera),
          ),
          const SizedBox(height: 8.0),
          // Usa el método buildPhotoList
          buildPhotoList(placeName),
        ],
      ),
    );
}


Widget buildPhotoList(String placeName) {
  return FutureBuilder<List<Map<String, dynamic>>>(
    future: DatabaseHelper().getAll('photos'),
    builder: (context, snapshot) {
      logger.info('------------------------------------Downloading photos from the database----------------------------------');
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (snapshot.hasData) {
        
        final photos = snapshot.data!.where((photo) => photo['placeName'] == placeName).toList();

        if (photos.isEmpty) {
          logger.info('There are no photos saved to the database----------------------------------');
          return const Text(
            'No photos available.',
            style: TextStyle(color: Colors.grey),
          );
        }

        final random = Random();
        photos.shuffle(random);
        final randomPhotos = photos.take(3).toList();

        return SizedBox(
          height: 100.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: randomPhotos.length,
            itemBuilder: (context, index) {
              final photoPath = randomPhotos[index]['path'];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Image.file(
                  File(photoPath),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        );
      }
      return const Text('No photos available.', style: TextStyle(color: Colors.grey));
    },
  );
}

/* 
Widget CustomizedInfoWindowPhotos(String placeName, String info, BuildContext context){
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
        
        ElevatedButton.icon(
          label: Text('Share a photo!', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onPrimaryContainer),),
          style: ButtonStyle(
            padding: WidgetStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            ),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.blue),
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.hovered))
                  return Colors.blue;
                if (states.contains(WidgetState.focused) ||
                    states.contains(WidgetState.pressed))
                  return Colors.blue;
                return null; // Defer to the widget's default.
              },
            ),
          ),
          onPressed:  (){ Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CameraScreen()));
              },
          icon: Icon(Icons.photo_camera, color: theme.colorScheme.onPrimaryContainer,),
        ),
      ],
    ),
  );
}
*/
Widget CustomizedInfoWindow(String placeName, String info, BuildContext context, String imageLink){
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
                  imageLink,
                  height: 130.0,
                  width: 320.0,
                  fit: BoxFit.fill,
                ),
          ),
        ),
      ],
    ),
  );
}

