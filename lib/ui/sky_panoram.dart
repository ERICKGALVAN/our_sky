import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:panorama/panorama.dart';

import '../bloc/bodies_cubit/bodies_cubit.dart';

class SkyPanoram extends StatefulWidget {
  const SkyPanoram({Key? key}) : super(key: key);

  @override
  State<SkyPanoram> createState() => _SkyPanoramState();
}

class _SkyPanoramState extends State<SkyPanoram> {
  @override
  void didChangeDependencies() async {
    setState(() {
      _isLoading = true;
    });
    await loadData();
    await FlutterCompass.events!.first.then((CompassEvent event) {
      setState(() {
        _compass = event.heading!;
      });
    });

    setState(() {
      _isLoading = false;
    });

    super.didChangeDependencies();
  }

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });
    final bodiesCubit = BlocProvider.of<BodiesCubit>(context);
    final DateTime dateTime = DateTime.now();

    Location location = Location();
    location.hasPermission();
    await location.getLocation().then((value) {
      _latitude = value.latitude.toString();
      _longitude = value.longitude.toString();
      _altitude = int.parse(value.altitude.toString().split('.')[0]);
    });
    String hour = dateTime.hour.toString();
    String minute = dateTime.minute.toString();
    String second = dateTime.second.toString();

    if (hour.toString().length == 1) {
      hour = '0$hour';
    }
    if (minute.toString().length == 1) {
      minute = '0$minute';
    }
    if (second.toString().length == 1) {
      second = '0$second';
    }
    await bodiesCubit.getBodies(
      _latitude,
      _longitude,
      _altitude,
      dateTime.toString().split(' ')[0],
      dateTime.toString().split(' ')[0],
      '$hour:$minute:$second',
    );

    for (var body in bodiesCubit.bodiesModel!.data.table.rows) {
      if (body.cells[0].name != 'Earth' &&
          double.parse(body.cells[0].position.horizontal.altitude.degrees
                  .toString()) >
              0) {
        String name = body.cells[0].name;
        double longitude = double.parse(
            body.cells[0].position.horizontal.azimuth.degrees.toString());
        if (longitude > 180) {
          longitude = longitude - 360;
        }
        double latitude = double.parse(
            body.cells[0].position.horizontal.altitude.degrees.toString());
        //* 1.6 - 55;

        _visible.add({
          'name': name,
          'longitude': double.parse(
              body.cells[0].position.horizontal.azimuth.degrees.toString()),
          'latitude': double.parse(
              body.cells[0].position.horizontal.altitude.degrees.toString()),
        });

        _bodies.add(
          Hotspot(
            latitude: latitude,
            longitude: longitude,
            width: 180.0,
            height: 190.0,
            widget: Column(
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.rajdhani().fontFamily,
                  ),
                ),
                Image.asset(
                  'assets/${name.toLowerCase()}.png',
                  width: 50,
                  height: 50,
                ),
              ],
            ),
          ),
        );
      } else if (body.cells[0].name != 'Earth' &&
          double.parse(body.cells[0].position.horizontal.altitude.degrees
                  .toString()) <=
              0) {
        _notVisible.add({
          'name': body.cells[0].name,
          'longitude': double.parse(
              body.cells[0].position.horizontal.azimuth.degrees.toString()),
          'latitude': double.parse(
              body.cells[0].position.horizontal.altitude.degrees.toString()),
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  String _latitude = '';
  String _longitude = '';
  int _altitude = 0;
  bool _isLoading = false;
  double _compass = 0.0;
  final List<Hotspot> _bodies = [
    Hotspot(
      latitude: 0.0,
      longitude: 0.0,
      width: 180.0,
      height: 190.0,
      widget: Text(
        'North',
        style: TextStyle(
          color: const Color.fromARGB(255, 219, 103, 21),
          fontFamily: GoogleFonts.abrilFatface().fontFamily,
          fontSize: 45,
        ),
      ),
    ),
    Hotspot(
      latitude: 0.0,
      longitude: 180.0,
      width: 180.0,
      height: 190.0,
      widget: Text(
        'South',
        style: TextStyle(
          color: const Color.fromARGB(255, 219, 103, 21),
          fontFamily: GoogleFonts.abrilFatface().fontFamily,
          fontSize: 45,
        ),
      ),
    ),
    Hotspot(
      latitude: 0.0,
      longitude: 90.0,
      width: 180.0,
      height: 190.0,
      widget: Text(
        'East',
        style: TextStyle(
          color: const Color.fromARGB(255, 219, 103, 21),
          fontFamily: GoogleFonts.abrilFatface().fontFamily,
          fontSize: 45,
        ),
      ),
    ),
    Hotspot(
      latitude: 0.0,
      longitude: -90.0,
      width: 180.0,
      height: 190.0,
      widget: Text(
        'West',
        style: TextStyle(
          color: const Color.fromARGB(255, 219, 103, 21),
          fontFamily: GoogleFonts.abrilFatface().fontFamily,
          fontSize: 45,
        ),
      ),
    ),
  ];
  final List<Map<String, dynamic>> _visible = [];
  final List<Map<String, dynamic>> _notVisible = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Panorama(
                longitude: _compass,
                latitude: 0,
                animSpeed: 0.000000000000001,
                interactive: false,
                sensorControl: SensorControl.AbsoluteOrientation,
                hotspots: _bodies,
                child: Image.asset('assets/three.jpg'),
              ),
      ),
    );
  }
}
