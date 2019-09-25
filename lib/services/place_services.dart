import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:tcc_ubs/models/place_model.dart';
import 'package:http/http.dart' as http;

class PlaceService {
  static final _service = PlaceService();

  static PlaceService get() {
    return _service;
  }

  Geolocator geolocator = Geolocator();
  Position userLocation;

  Future<List<Place>> getNearbyPlaces() async {
    String keyUbmedy = "AIzaSyB9JXMYdBQ4CX7EWlabRVb_mfSb1k22cOw";
    String keyCanseiDisso = "AIzaSyDMPkGZLrR2pASxEdtSsuXoT2ZjXyPur1A";
    String keyMapsLennyk = "AIzaSyBE7cZBkvJxfRTCD7_FvRs1iX41NXHuuJc";
    String keyAAAA = "AIzaSyDKAdb-t1JslO08LZsNhTNd7nb6mG_Nuaw";

    var currentLocation = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    var lat = currentLocation.latitude.toString();
    var long = currentLocation.longitude.toString();

    final String searchURL =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$long&rankby=distance&name=ubs&key=$keyUbmedy";

    var response =
        await http.get(searchURL, headers: {"Accept": "application/json"});
    var places = <Place>[];

    List data = json.decode(response.body)["results"];

    data.forEach((f) => places.add((Place(
        f["name"], f["rating"].toString(), f["vicinity"], f["place_id"]))));

    return places;
  }
}
