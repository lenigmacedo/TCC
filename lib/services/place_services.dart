import 'dart:convert';

import 'package:tcc_ubs/models/place_model.dart';
import 'package:http/http.dart' as http;

class PlaceService {
  static final _service = PlaceService();

  static PlaceService get() {
    return _service;
  }

  final String searchURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-23.5962565,-46.5258909&radius=8000&name=ubs&key=AIzaSyA2JjPnJ_QUV_3esxLCfbIpc9gyqPIm02Y";

  Future<List<Place>> getNearbyPlaces() async {
    var response =
        await http.get(searchURL, headers: {"Accept": "application/json"});
    var places = <Place>[];

    List data = json.decode(response.body)["results"];

    data.forEach((f) => places
        .add((Place(f["name"], f["name"], f["rating"].toString(), f["vicinity"], f["place_id"]))));

        return places;

  }
}
