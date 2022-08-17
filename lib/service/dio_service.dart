import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/direction_model.dart';
import '.env.dart';

class DirectionsRepository{
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';
  late final Dio? _dio;
  //DirectionsRepository( {required Dio dio}):_dio = dio;
  Future<Directions> getDirections({
    required LatLng origin,
    required LatLng destinination,
}) async{
 final response = await _dio!.get(
   _baseUrl,
 queryParameters: {
     'origin':'${origin.latitude},${origin.longitude}',
   'destination':'${destinination.latitude},${destinination.longitude}',
   'key':googleApiKey,
 }
 );
 ///Check if response is successfull
  if(response.statusCode==200){
    return Directions.fromMap(response.data);
  }
  return null!;
}
}