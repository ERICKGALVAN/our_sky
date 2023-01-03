// To parse this JSON data, do
//
//     final planetModel = planetModelFromJson(jsonString);

import 'dart:convert';

PlanetModel planetModelFromJson(String str) =>
    PlanetModel.fromJson(json.decode(str));

String planetModelToJson(PlanetModel data) => json.encode(data.toJson());

class PlanetModel {
  PlanetModel({
    required this.id,
    required this.name,
    required this.englishName,
    required this.isPlanet,
    required this.moons,
    required this.semimajorAxis,
    required this.perihelion,
    required this.aphelion,
    required this.eccentricity,
    required this.inclination,
    required this.mass,
    required this.vol,
    required this.density,
    required this.gravity,
    required this.escape,
    required this.meanRadius,
    required this.equaRadius,
    required this.polarRadius,
    required this.flattening,
    required this.dimension,
    required this.sideralOrbit,
    required this.sideralRotation,
    this.aroundPlanet,
    required this.discoveredBy,
    required this.discoveryDate,
    required this.alternativeName,
    required this.axialTilt,
    required this.avgTemp,
    required this.mainAnomaly,
    required this.argPeriapsis,
    required this.longAscNode,
    required this.bodyType,
  });

  String id;
  String name;
  String englishName;
  bool isPlanet;
  List<Moon?>? moons;
  int semimajorAxis;
  int perihelion;
  int aphelion;
  double eccentricity;
  double inclination;
  Mass mass;
  Vol vol;
  double density;
  double gravity;
  double escape;
  double meanRadius;
  double equaRadius;
  double polarRadius;
  double flattening;
  String dimension;
  double sideralOrbit;
  double sideralRotation;
  dynamic aroundPlanet;
  String discoveredBy;
  String discoveryDate;
  String alternativeName;
  double axialTilt;
  int avgTemp;
  double mainAnomaly;
  double argPeriapsis;
  double longAscNode;
  String bodyType;

  factory PlanetModel.fromJson(Map<String, dynamic> json) => PlanetModel(
        id: json["id"],
        name: json["name"],
        englishName: json["englishName"],
        isPlanet: json["isPlanet"],
        moons: json["moons"] == null
            ? null
            : List<Moon?>.from(json["moons"]!.map((x) => Moon?.fromJson(x))),
        semimajorAxis: json["semimajorAxis"],
        perihelion: json["perihelion"],
        aphelion: json["aphelion"],
        eccentricity: json["eccentricity"].toDouble(),
        inclination: double.parse(json["inclination"].toString()),
        mass: Mass.fromJson(json["mass"]),
        vol: Vol.fromJson(json["vol"]),
        density: json["density"].toDouble(),
        gravity: json["gravity"].toDouble(),
        escape: double.parse(json["escape"].toString()),
        meanRadius: json["meanRadius"].toDouble(),
        equaRadius: json["equaRadius"].toDouble(),
        polarRadius: json["polarRadius"].toDouble(),
        flattening: json["flattening"].toDouble(),
        dimension: json["dimension"],
        sideralOrbit: json["sideralOrbit"].toDouble(),
        sideralRotation: json["sideralRotation"].toDouble(),
        aroundPlanet: json["aroundPlanet"],
        discoveredBy: json["discoveredBy"],
        discoveryDate: json["discoveryDate"],
        alternativeName: json["alternativeName"],
        axialTilt: json["axialTilt"].toDouble(),
        avgTemp: json["avgTemp"],
        mainAnomaly: json["mainAnomaly"].toDouble(),
        argPeriapsis: json["argPeriapsis"].toDouble(),
        longAscNode: json["longAscNode"].toDouble(),
        bodyType: json["bodyType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "englishName": englishName,
        "isPlanet": isPlanet,
        "moons": moons == null
            ? null
            : List<dynamic>.from(moons!.map((x) => x!.toJson())),
        "semimajorAxis": semimajorAxis,
        "perihelion": perihelion,
        "aphelion": aphelion,
        "eccentricity": eccentricity,
        "inclination": inclination,
        "mass": mass.toJson(),
        "vol": vol.toJson(),
        "density": density,
        "gravity": gravity,
        "escape": escape,
        "meanRadius": meanRadius,
        "equaRadius": equaRadius,
        "polarRadius": polarRadius,
        "flattening": flattening,
        "dimension": dimension,
        "sideralOrbit": sideralOrbit,
        "sideralRotation": sideralRotation,
        "aroundPlanet": aroundPlanet,
        "discoveredBy": discoveredBy,
        "discoveryDate": discoveryDate,
        "alternativeName": alternativeName,
        "axialTilt": axialTilt,
        "avgTemp": avgTemp,
        "mainAnomaly": mainAnomaly,
        "argPeriapsis": argPeriapsis,
        "longAscNode": longAscNode,
        "bodyType": bodyType,
      };
}

class Mass {
  Mass({
    required this.massValue,
    required this.massExponent,
  });

  double massValue;
  int massExponent;

  factory Mass.fromJson(Map<String, dynamic> json) => Mass(
        massValue: json["massValue"].toDouble(),
        massExponent: json["massExponent"],
      );

  Map<String, dynamic> toJson() => {
        "massValue": massValue,
        "massExponent": massExponent,
      };
}

class Moon {
  Moon({
    required this.moon,
    required this.rel,
  });

  String moon;
  String rel;

  factory Moon.fromJson(Map<String, dynamic> json) => Moon(
        moon: json["moon"],
        rel: json["rel"],
      );

  Map<String, dynamic> toJson() => {
        "moon": moon,
        "rel": rel,
      };
}

class Vol {
  Vol({
    required this.volValue,
    required this.volExponent,
  });

  double volValue;
  int volExponent;

  factory Vol.fromJson(Map<String, dynamic> json) => Vol(
        volValue: json["volValue"].toDouble(),
        volExponent: json["volExponent"],
      );

  Map<String, dynamic> toJson() => {
        "volValue": volValue,
        "volExponent": volExponent,
      };
}
