import 'dart:convert';
import 'dart:math';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart' as location_manager;
import 'package:our_sky/constants/constants.dart';
import 'package:our_sky/models/star_model.dart';
import 'package:our_sky/services/astronomy_service.dart';
import 'package:our_sky/ui/menu.dart';
import 'package:our_sky/ui/planet_viewer.dart';

import '../bloc/bodies_cubit/bodies_cubit.dart';
import '../painters/star_painter.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({Key? key}) : super(key: key);

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _stars = List.generate(
      100000,
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

  Future _openCalendar() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _dateTime) {
      setState(() {
        _dateTime = picked;
      });
      await loadData();
    }
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
    setState(() {
      _isLoading = true;
    });
    _bodies.clear();
    final bodiesCubit = BlocProvider.of<BodiesCubit>(context);
    await AstronomyService()
        .getMoonPhase(double.parse(_latitude), double.parse(_longitude),
            _dateTime.toString().split(' ')[0])
        .then((value) {
      final res = jsonDecode(value.body);
      _moonImage = res['data']['imageUrl'];
      developer.log(_moonImage);
    });

    await bodiesCubit.getBodies(
      _latitude,
      _longitude,
      _altitude,
      _dateTime.toString().split(' ')[0],
      _dateTime.toString().split(' ')[0],
      monthTimes[_dateTime.month]!,
    );

    for (var body in bodiesCubit.bodiesModel!.data.table.rows) {
      final distance = double.parse(body.cells[0].distance.fromEarth.au);
      final degrees =
          double.parse(body.cells[0].position.horizontal.azimuth.degrees);
      final x = distance * 6 * cos(degrees * pi / 180);
      final y = distance * 6 * sin(degrees * pi / 180);
      _bodies.add({
        'name': body.cells[0].name,
        'positionX': x,
        'positionY': y,
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  AnimationController? _animationController;
  List<StarModel> _stars = [];

  String _latitude = '';
  String _longitude = '';
  int _altitude = 0;
  bool _isLoading = false;
  final List<Map<String, dynamic>> _bodies = [];
  String _moonImage = '';
  bool _showBar = true;
  DateTime _dateTime = DateTime.now();

  final viewTransformationController = TransformationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _openCalendar();
            },
            icon: const Icon(
              Icons.calendar_month,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 1, 1, 53),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  // _isLoading || !_showBar
                  //     ? const SizedBox()
                  //     : Positioned(
                  //         top: 5,
                  //         child: Material(
                  //           color: Colors.transparent,
                  //           child: Column(
                  //             children: [
                  //               // Text(
                  //               //   _dateTime.toString().split(' ')[0],
                  //               //   style: const TextStyle(
                  //               //     color: Colors.white,
                  //               //   ),
                  //               // ),
                  //               // Image.network(
                  //               //   _moonImage,
                  //               //   width: 100,
                  //               //   height: 200,
                  //               // ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  InteractiveViewer(
                    transformationController: viewTransformationController,
                    minScale: 0.5,
                    maxScale: 80,
                    child: AnimatedBuilder(
                      animation: _animationController!,
                      builder: (context, child) {
                        return CustomPaint(
                          size: MediaQuery.of(context).size,
                          painter: StarPainter(
                            stars: _stars,
                            animationValue: _animationController!.value,
                          ),
                          child: Stack(
                            children: [
                              for (var element in _bodies)
                                Positioned(
                                  left: MediaQuery.of(context).size.width / 2 +
                                      element['positionX'],
                                  top: MediaQuery.of(context).size.height / 2 +
                                      element['positionY'],
                                  child: GestureDetector(
                                    onTap: () {
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
                                          element['name'] == 'Moon'
                                              ? ''
                                              : element['name'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: element['name'] == 'Moon'
                                                ? 0.5
                                                : 1,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: element['name'] == 'Sun'
                                                    ? Colors.yellow
                                                    : Colors.transparent,
                                                blurRadius: 1,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                          child: Image.asset(
                                              'assets/${element['name'].toString().toLowerCase()}.png',
                                              width: element['name'] == 'Moon'
                                                  ? 0.5
                                                  : 1,
                                              height: element['name'] == 'Moon'
                                                  ? 0.5
                                                  : .8),
                                        ),

                                        // Container(
                                        //   width: element['name'] == 'Moon'
                                        //       ? 0.5
                                        //       : .8,
                                        //   height: element['name'] == 'Moon'
                                        //       ? 0.5
                                        //       : .8,
                                        //   decoration: BoxDecoration(
                                        //     color: element['color'],
                                        //     shape: BoxShape.circle,
                                        //     boxShadow: [
                                        //       BoxShadow(
                                        //         color: element['name'] == 'Sun'
                                        //             ? Colors.yellow
                                        //             : Colors.transparent,
                                        //         blurRadius: 1,
                                        //         spreadRadius: 1,
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
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
