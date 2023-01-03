import 'dart:convert';
import 'dart:math';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart' as location_manager;
import 'package:our_sky/models/star_model.dart';
import 'package:our_sky/painters/saturn_rings_painter.dart';
import 'package:our_sky/services/astronomy_service.dart';
import 'package:our_sky/ui/planet_viewer.dart';

import '../bloc/bodies_cubit/bodies_cubit.dart';
import '../painters/star_painter.dart';

class View extends StatefulWidget {
  const View({Key? key}) : super(key: key);

  @override
  State<View> createState() => _ViewState();
}

class _ViewState extends State<View> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _stars = List.generate(
      150000,
      (index) => StarModel(
        positionX: Random().nextDouble() * 900,
        positionY: Random().nextDouble() * 900,
        size: Random().nextDouble() * 0.1,
        speed: Random().nextDouble() * 2,
      ),
    );
    const zoomFactor = 2.0;
    const xTranslate = 300.0;
    const yTranslate = 300.0;
    viewTransformationController.value.setEntry(0, 0, zoomFactor);
    viewTransformationController.value.setEntry(1, 1, zoomFactor);
    viewTransformationController.value.setEntry(2, 2, zoomFactor);
    viewTransformationController.value.setEntry(0, 3, -xTranslate);
    viewTransformationController.value.setEntry(1, 3, -yTranslate);
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    setState(() {
      _isLoading = true;
    });
    await getCurrentLocation();
    await loadData();
    setState(() {
      _isLoading = false;
    });
    super.didChangeDependencies();
  }

  Future<void> getCurrentLocation() async {
    location_manager.Location location = location_manager.Location();
    location.hasPermission();
    await location.getLocation().then((value) {
      _latitude = value.latitude.toString();
      _longitude = value.longitude.toString();
      _altitude = int.parse(value.altitude.toString().split('.')[0]);
    });
  }

  Future<void> loadData() async {
    final bodiesCubit = BlocProvider.of<BodiesCubit>(context);
    final DateTime dateTime = DateTime.now();
    await AstronomyService()
        .getMoonPhase(double.parse(_latitude), double.parse(_longitude),
            dateTime.toString().split(' ')[0])
        .then((value) {
      final res = jsonDecode(value.body);
      _moonImage = res['data']['imageUrl'];
      developer.log(_moonImage);
    });
    String hour = dateTime.hour.toString();
    String minute = dateTime.minute.toString();
    String second = dateTime.second.toString();
    if (dateTime.hour.toString().length == 1) {
      hour = '0${dateTime.hour}';
    }
    if (dateTime.minute.toString().length == 1) {
      minute = '0${dateTime.minute}';
    }
    if (dateTime.second.toString().length == 1) {
      second = '0${dateTime.second}';
    }
    await bodiesCubit.getBodies(
      _latitude,
      _longitude,
      _altitude,
      dateTime.toString().split(' ')[0],
      dateTime.toString().split(' ')[0],
      '15:00:00',
    );

    for (var body in bodiesCubit.bodiesModel!.data.table.rows) {
      if (body.cells[0].name != 'Moon') {
        final distance = double.parse(body.cells[0].distance.fromEarth.au);
        final degrees =
            double.parse(body.cells[0].position.horizontal.azimuth.degrees);
        final x = distance * 6 * cos(degrees * pi / 180);
        final y = distance * 6 * sin(degrees * pi / 180);
        _bodies.add({
          'name': body.cells[0].name,
          'positionX': x,
          'positionY': y,
          'color': _bodiesProperties.firstWhere(
              (element) => element['name'] == body.cells[0].name)['color'],
        });
      }
    }
  }

  AnimationController? _animationController;
  List<StarModel> _stars = [];
  final List<Map<String, dynamic>> _bodiesProperties = [
    {
      'name': 'Sun',
      'color': Colors.yellow,
    },
    {
      'name': 'Mercury',
      'color': const Color.fromRGBO(178, 123, 58, 1),
    },
    {
      'name': 'Venus',
      'color': const Color.fromRGBO(221, 176, 116, 1),
    },
    {
      'name': 'Earth',
      'color': Colors.blue,
    },
    {
      'name': 'Mars',
      'color': Colors.red,
    },
    {
      'name': 'Jupiter',
      'color': const Color.fromRGBO(201, 176, 134, 1),
    },
    {
      'name': 'Saturn',
      'color': const Color.fromRGBO(205, 153, 77, 1),
    },
    {
      'name': 'Uranus',
      'color': const Color.fromRGBO(3, 139, 143, 1),
    },
    {
      'name': 'Neptune',
      'color': const Color.fromRGBO(66, 112, 243, 1),
    },
    {
      'name': 'Pluto',
      'color': const Color.fromRGBO(177, 165, 155, 1),
    },
  ];

  String _latitude = '';
  String _longitude = '';
  int _altitude = 0;
  bool _isLoading = false;
  final List<Map<String, dynamic>> _bodies = [];
  String _moonImage = '';
  bool _showBar = true;

  final viewTransformationController = TransformationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 1, 1, 53),
        title: const Text('Solar System'),
        leading: IconButton(
          onPressed: () {
            setState(() {
              _showBar = !_showBar;
            });
          },
          icon: Icon(
            _showBar ? Icons.chevron_left : Icons.chevron_right,
          ),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 1, 1, 53),
        child: Stack(
          children: [
            _isLoading || !_showBar
                ? const SizedBox()
                : Positioned(
                    top: 50,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          developer.log('pressed');
                        },
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PlanetViewer(
                                      planetName: 'moon',
                                    ),
                                  ),
                                );
                              },
                              child: Image.network(
                                _moonImage,
                                width: 100,
                                height: 200,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            InteractiveViewer(
              transformationController: viewTransformationController,
              minScale: 0.5,
              maxScale: 80,
              child: AnimatedBuilder(
                animation: _animationController!,
                builder: (context, child) {
                  return CustomPaint(
                    painter: StarPainter(
                      stars: _stars,
                      animationValue: _animationController!.value,
                    ),
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Stack(
                            children: [
                              for (var element in _bodies)
                                Positioned(
                                  left: MediaQuery.of(context).size.width / 2 +
                                      element['positionX'],
                                  top: MediaQuery.of(context).size.height / 2 +
                                      element['positionY'],
                                  child: GestureDetector(
                                    onTap: () {
                                      developer.log(element['name']);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlanetViewer(
                                            planetName: element['name'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          element['name'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 1,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                        CustomPaint(
                                          painter: SaturnRingsPainter(),
                                          child: Container(
                                            width: .8,
                                            height: .8,
                                            decoration: BoxDecoration(
                                              color: element['color'],
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      element['name'] == 'Sun'
                                                          ? Colors.yellow
                                                          : Colors.transparent,
                                                  blurRadius: 1,
                                                  spreadRadius: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
