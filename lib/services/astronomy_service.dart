import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:our_sky/constants/constants.dart';
import 'package:our_sky/models/bodies_model.dart';
import 'package:our_sky/models/planet_model.dart';

class AstronomyService {
  Future<BodiesModel> getBodies(String latitude, String longitude,
      int elevation, String fromDate, String toDate, String time) async {
    try {
      final url = Uri.parse(
        'https://api.astronomyapi.com/api/v2/bodies/positions?latitude=$latitude&longitude=$longitude&elevation=$elevation&from_date=$fromDate&to_date=$toDate&time=$time',
      );
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode(auth))}',
        },
      );
      return BodiesModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<http.Response> getMoonPhase(
      double latitude, double longitude, String date) async {
    try {
      final url =
          Uri.parse('https://api.astronomyapi.com/api/v2/studio/moon-phase');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode(auth))}',
        },
        body: jsonEncode(
          {
            "format": "png",
            "style": {
              "moonStyle": "default",
              "backgroundStyle": "solid",
              "backgroundColor": "transparent",
              "headingColor": "white",
              "textColor": "white"
            },
            "observer": {
              "latitude": latitude,
              "longitude": longitude,
              "date": date
            },
            "view": {"type": "portrait-simple", "orientation": "south-up"}
          },
        ),
      );
      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<PlanetModel> getPlanetInformation(String planet) async {
    try {
      final response = http.get(
        Uri.parse('https://api.le-systeme-solaire.net/rest/bodies/$planet'),
      );
      return PlanetModel.fromJson(jsonDecode((await response).body));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
