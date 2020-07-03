import 'package:flutter/material.dart';
import 'package:app_api_rest/Modelo/Lugar.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class detalleLugarScreen extends StatelessWidget{

  final Lugar objLugar;

  detalleLugarScreen(this.objLugar);

  GoogleMapController mapController;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    var marker = Marker(
      markerId: MarkerId("1"),
      position: LatLng(objLugar.latitud, objLugar.longitud),
      infoWindow: InfoWindow(title: objLugar.nombre, snippet: objLugar.descripcion),
      onTap: () {
        //codigo
      },
    );

    markers[MarkerId("1")] = marker;

    return Scaffold(
      appBar: AppBar(
        title: Text(objLugar.nombre),
      ),
      body: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Image.network(objLugar.imagen_nombre),
                Padding(
                   padding: EdgeInsets.all(5.0),
                   child:  Text(objLugar.descripcion,   style: TextStyle( fontSize: 20.0),
                                                          textAlign: TextAlign.justify) ,
                ),

                   Padding(
                     padding: EdgeInsets.all(5.0),
                   child:  Row(
                        mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _BotonIcono(Colors.black, Icons.call, 'Llamar',1),
                          _BotonIcono(Colors.black, Icons.near_me, 'Mapa',2),
                          _BotonIcono(Colors.black, Icons.find_in_page, 'Web',3),
                        ],
                      ),
                   ),
                Column(
                  children: <Widget>[
                    Container(
                      height: 300.0,
                      width: MediaQuery.of(context).size.width,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(objLugar.latitud,objLugar.longitud),
                          zoom: 17.0
                        ),
                        onMapCreated: (GoogleMapController controller) {
                            mapController  = controller;

                        },
                        markers: Set<Marker>.of(markers.values),

                      ),

                    ),
                  ],
                )


              ],
            )
          ],
      ),
    );

  }





  Widget _BotonIcono(Color color, IconData icon, String label, int idEvento) {
    return InkWell(
      child:  Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      ),
      onTap: () {

         if(idEvento == 1){
             _marcar(objLugar.telefono);
         }else if(idEvento  == 3){

           _irPaginaWeb(objLugar.website);
         } else if (idEvento  == 2){
           _irMapaStatic("https://maps.googleapis.com/maps/api/staticmap?center=${objLugar.latitud},${objLugar.longitud}&zoom=15&size=400x400&key=AIzaSyARDffAihIXo7tYhNShT5G4NRJQV99wqnw");
         }

      },
    );

  }


  _marcar(String telefono) async {
    var url = 'tel:$telefono';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _irPaginaWeb(String url) async {;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  _irMapaStatic(String url) async {;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }

  }


}