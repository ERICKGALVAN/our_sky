import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:our_sky/bloc/background_cubit/background_cubit.dart';
import 'package:our_sky/bloc/font_color_cubit/font_color_cubit.dart';
import 'package:our_sky/bloc/font_cubit/font_cubit.dart';
import 'package:our_sky/constants/constants.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

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
    final font = BlocProvider.of<FontCubit>(context).state as FontChange;
    _font = font.font;
    final fontColor =
        BlocProvider.of<FontColorCubit>(context).state as FontColorChange;
    _fontColor = fontColor.fontColor;

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
      monthTimes[dateTime.month]!,
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
                    color: _fontColor == null
                        ? fontColors['black']
                        : fontColors[_fontColor!],
                    fontFamily: _font == null
                        ? fonts['roboto']!.fontFamily
                        : fonts[_font!]!.fontFamily,
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
    _bodies.add(
      Hotspot(
        latitude: 0.0,
        longitude: 0.0,
        width: 180.0,
        height: 190.0,
        widget: Text(
          'North',
          style: TextStyle(
            color: _fontColor == null
                ? fontColors['black']
                : fontColors[_fontColor!],
            fontFamily: _font == null
                ? fonts['roboto']!.fontFamily
                : fonts[_font!]!.fontFamily,
            fontSize: 45,
          ),
        ),
      ),
    );
    _bodies.add(
      Hotspot(
        latitude: 0.0,
        longitude: 180.0,
        width: 180.0,
        height: 190.0,
        widget: Text(
          'South',
          style: TextStyle(
            color: _fontColor == null
                ? fontColors['black']
                : fontColors[_fontColor!],
            fontFamily: _font == null
                ? fonts['roboto']!.fontFamily
                : fonts[_font!]!.fontFamily,
            fontSize: 45,
          ),
        ),
      ),
    );
    _bodies.add(
      Hotspot(
        latitude: 0.0,
        longitude: 90.0,
        width: 180.0,
        height: 190.0,
        widget: Text(
          'East',
          style: TextStyle(
            color: _fontColor == null
                ? fontColors['black']
                : fontColors[_fontColor!],
            fontFamily: _font == null
                ? fonts['roboto']!.fontFamily
                : fonts[_font!]!.fontFamily,
            fontSize: 45,
          ),
        ),
      ),
    );
    _bodies.add(
      Hotspot(
        latitude: 0.0,
        longitude: -90.0,
        width: 180.0,
        height: 190.0,
        widget: Text(
          'West',
          style: TextStyle(
            color: _fontColor == null
                ? fontColors['black']
                : fontColors[_fontColor!],
            fontFamily: _font == null
                ? fonts['roboto']!.fontFamily
                : fonts[_font!]!.fontFamily,
            fontSize: 45,
          ),
        ),
      ),
    );

    setState(() {
      _isLoading = false;
    });
  }

  String _latitude = '';
  String _longitude = '';
  int _altitude = 0;
  bool _isLoading = false;
  double _compass = 0.0;
  String? _font;
  String? _fontColor;
  final List<Hotspot> _bodies = [];
  final List<Map<String, dynamic>> _visible = [];
  final List<Map<String, dynamic>> _notVisible = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : BlocBuilder<BackgroundCubit, BackgroundState>(
                builder: (context, state) {
                  if (state is BackgroundImage) {
                    return PanoramaViewer(
                      longitude: _compass,
                      latitude: 0,
                      animSpeed: 0.000000000000001,
                      interactive: false,
                      sensorControl: SensorControl.absoluteOrientation,
                      hotspots: _bodies,
                      child: Image.asset(
                        state.imagePath,
                      ),
                    );
                  }
                  return PanoramaViewer(
                    longitude: _compass,
                    latitude: 0,
                    animSpeed: 0.000000000000001,
                    interactive: false,
                    sensorControl: SensorControl.absoluteOrientation,
                    hotspots: _bodies,
                    child: Image.asset('assets/newyork.jpg'),
                  );
                },
              ),
      ),
    );
  }
}
