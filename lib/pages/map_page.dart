import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ntuadventure/pages/calendar_page.dart';
import '../theme/app_decoration.dart';
import '../pages/home_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  Location _locationController = new Location();

  static const LatLng _pGoogleplex= LatLng(37.977695472904564, 23.783499245883448);
  LatLng? _currentP= null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
                          target: _pGoogleplex,
                          zoom: 16.0),
        markers: {
          Marker(
            markerId: MarkerId("_sourceLocation"), 
            icon: BitmapDescriptor.defaultMarker)
        },
        )
    );
  }

  Future<void> getLocationUpdates() async{
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled(); //Location active on the deviece?
    if(_serviceEnabled){
      _serviceEnabled = await _locationController.requestService(); //Request access to location
    }else{
      return;
    }

    _permissionGranted = await _locationController.hasPermission(); //permission to access the location?
    if(_permissionGranted== PermissionStatus.denied){ //If it doesnt have permission
      _permissionGranted= await _locationController.requestPermission();//Then request for permission
      if(_permissionGranted != PermissionStatus.granted){
        return;
      }
    }

    _locationController.onLocationChanged.listen((LocationData currentLocation){
        if(currentLocation.latitude!= null && currentLocation.longitude!=null){
          setState(() {
            _currentP= LatLng(currentLocation.latitude!, currentLocation.longitude!);
          });
        }
    });

  }
}