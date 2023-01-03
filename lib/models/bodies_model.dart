// To parse this JSON data, do
//
//     final bodiesModel = bodiesModelFromJson(jsonString);

import 'dart:convert';

BodiesModel bodiesModelFromJson(String str) =>
    BodiesModel.fromJson(json.decode(str));

String bodiesModelToJson(BodiesModel data) => json.encode(data.toJson());

class BodiesModel {
  BodiesModel({
    required this.data,
  });

  Data data;

  factory BodiesModel.fromJson(Map<String, dynamic> json) => BodiesModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.dates,
    required this.observer,
    required this.table,
  });

  Dates dates;
  Observer observer;
  Table table;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        dates: Dates.fromJson(json["dates"]),
        observer: Observer.fromJson(json["observer"]),
        table: Table.fromJson(json["table"]),
      );

  Map<String, dynamic> toJson() => {
        "dates": dates.toJson(),
        "observer": observer.toJson(),
        "table": table.toJson(),
      };
}

class Dates {
  Dates({
    required this.from,
    required this.to,
  });

  DateTime from;
  DateTime to;

  factory Dates.fromJson(Map<String, dynamic> json) => Dates(
        from: DateTime.parse(json["from"]),
        to: DateTime.parse(json["to"]),
      );

  Map<String, dynamic> toJson() => {
        "from": from.toIso8601String(),
        "to": to.toIso8601String(),
      };
}

class Observer {
  Observer({
    required this.location,
  });

  Location location;

  factory Observer.fromJson(Map<String, dynamic> json) => Observer(
        location: Location.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
      };
}

class Location {
  Location({
    required this.longitude,
    required this.latitude,
    required this.elevation,
  });

  double longitude;
  double latitude;
  int elevation;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        longitude: json["longitude"].toDouble(),
        latitude: json["latitude"].toDouble(),
        elevation: json["elevation"],
      );

  Map<String, dynamic> toJson() => {
        "longitude": longitude,
        "latitude": latitude,
        "elevation": elevation,
      };
}

class Table {
  Table({
    required this.header,
    required this.rows,
  });

  List<DateTime> header;
  List<Row> rows;

  factory Table.fromJson(Map<String, dynamic> json) => Table(
        header:
            List<DateTime>.from(json["header"].map((x) => DateTime.parse(x))),
        rows: List<Row>.from(json["rows"].map((x) => Row.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "header": List<dynamic>.from(header.map((x) => x.toIso8601String())),
        "rows": List<dynamic>.from(rows.map((x) => x.toJson())),
      };
}

class Row {
  Row({
    required this.cells,
    required this.entry,
  });

  List<Cell> cells;
  Entry entry;

  factory Row.fromJson(Map<String, dynamic> json) => Row(
        cells: List<Cell>.from(json["cells"].map((x) => Cell.fromJson(x))),
        entry: Entry.fromJson(json["entry"]),
      );

  Map<String, dynamic> toJson() => {
        "cells": List<dynamic>.from(cells.map((x) => x.toJson())),
        "entry": entry.toJson(),
      };
}

class Cell {
  Cell({
    required this.date,
    required this.id,
    required this.name,
    required this.distance,
    required this.position,
    required this.extraInfo,
  });

  DateTime date;
  String id;
  String name;
  Distance distance;
  Position position;
  ExtraInfo extraInfo;

  factory Cell.fromJson(Map<String, dynamic> json) => Cell(
        date: DateTime.parse(json["date"]),
        id: json["id"],
        name: json["name"],
        distance: Distance.fromJson(json["distance"]),
        position: Position.fromJson(json["position"]),
        extraInfo: ExtraInfo.fromJson(json["extraInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "id": id,
        "name": name,
        "distance": distance.toJson(),
        "position": position.toJson(),
        "extraInfo": extraInfo.toJson(),
      };
}

class Distance {
  Distance({
    required this.fromEarth,
  });

  FromEarth fromEarth;

  factory Distance.fromJson(Map<String, dynamic> json) => Distance(
        fromEarth: FromEarth.fromJson(json["fromEarth"]),
      );

  Map<String, dynamic> toJson() => {
        "fromEarth": fromEarth.toJson(),
      };
}

class FromEarth {
  FromEarth({
    required this.au,
    required this.km,
  });

  String au;
  String km;

  factory FromEarth.fromJson(Map<String, dynamic> json) => FromEarth(
        au: json["au"],
        km: json["km"],
      );

  Map<String, dynamic> toJson() => {
        "au": au,
        "km": km,
      };
}

class ExtraInfo {
  ExtraInfo({
    required this.elongation,
    required this.magnitude,
    required this.phase,
  });

  double? elongation;
  double? magnitude;
  Phase? phase;

  factory ExtraInfo.fromJson(Map<String, dynamic> json) => ExtraInfo(
        elongation:
            json["elongation"] == null ? null : json["elongation"].toDouble(),
        magnitude:
            json["magnitude"] == null ? null : json["magnitude"].toDouble(),
        phase: json["phase"] == null ? null : Phase.fromJson(json["phase"]),
      );

  Map<String, dynamic> toJson() => {
        "elongation": elongation == null ? null : elongation,
        "magnitude": magnitude == null ? null : magnitude,
        "phase": phase == null ? null : phase?.toJson(),
      };
}

class Phase {
  Phase({
    required this.angel,
    required this.fraction,
    required this.string,
  });

  String angel;
  String fraction;
  String string;

  factory Phase.fromJson(Map<String, dynamic> json) => Phase(
        angel: json["angel"],
        fraction: json["fraction"],
        string: json["string"],
      );

  Map<String, dynamic> toJson() => {
        "angel": angel,
        "fraction": fraction,
        "string": string,
      };
}

class Position {
  Position({
    required this.horizontal,
    required this.horizonal,
    required this.equatorial,
    required this.constellation,
  });

  Horizon horizontal;
  Horizon horizonal;
  Equatorial equatorial;
  Constellation constellation;

  factory Position.fromJson(Map<String, dynamic> json) => Position(
        horizontal: Horizon.fromJson(json["horizontal"]),
        horizonal: Horizon.fromJson(json["horizonal"]),
        equatorial: Equatorial.fromJson(json["equatorial"]),
        constellation: Constellation.fromJson(json["constellation"]),
      );

  Map<String, dynamic> toJson() => {
        "horizontal": horizontal.toJson(),
        "horizonal": horizonal.toJson(),
        "equatorial": equatorial.toJson(),
        "constellation": constellation.toJson(),
      };
}

class Constellation {
  Constellation({
    required this.id,
    required this.short,
    required this.name,
  });

  String id;
  String short;
  String name;

  factory Constellation.fromJson(Map<String, dynamic> json) => Constellation(
        id: json["id"],
        short: json["short"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "short": short,
        "name": name,
      };
}

class Equatorial {
  Equatorial({
    required this.rightAscension,
    required this.declination,
  });

  RightAscension rightAscension;
  Declination declination;

  factory Equatorial.fromJson(Map<String, dynamic> json) => Equatorial(
        rightAscension: RightAscension.fromJson(json["rightAscension"]),
        declination: Declination.fromJson(json["declination"]),
      );

  Map<String, dynamic> toJson() => {
        "rightAscension": rightAscension.toJson(),
        "declination": declination.toJson(),
      };
}

class Declination {
  Declination({
    required this.degrees,
    required this.string,
  });

  String degrees;
  String string;

  factory Declination.fromJson(Map<String, dynamic> json) => Declination(
        degrees: json["degrees"],
        string: json["string"],
      );

  Map<String, dynamic> toJson() => {
        "degrees": degrees,
        "string": string,
      };
}

class RightAscension {
  RightAscension({
    required this.hours,
    required this.string,
  });

  String hours;
  String string;

  factory RightAscension.fromJson(Map<String, dynamic> json) => RightAscension(
        hours: json["hours"],
        string: json["string"],
      );

  Map<String, dynamic> toJson() => {
        "hours": hours,
        "string": string,
      };
}

class Horizon {
  Horizon({
    required this.altitude,
    required this.azimuth,
  });

  Declination altitude;
  Declination azimuth;

  factory Horizon.fromJson(Map<String, dynamic> json) => Horizon(
        altitude: Declination.fromJson(json["altitude"]),
        azimuth: Declination.fromJson(json["azimuth"]),
      );

  Map<String, dynamic> toJson() => {
        "altitude": altitude.toJson(),
        "azimuth": azimuth.toJson(),
      };
}

class Entry {
  Entry({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
