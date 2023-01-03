import 'dart:math';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:our_sky/bloc/planet_cubit/planet_cubit.dart';
import 'package:our_sky/painters/star_painter.dart';
import 'package:our_sky/services/astronomy_service.dart';

import '../models/star_model.dart';

class PlanetViewer extends StatefulWidget {
  const PlanetViewer({Key? key, required this.planetName}) : super(key: key);
  final String planetName;

  @override
  State<PlanetViewer> createState() => _PlanetViewerState();
}

class _PlanetViewerState extends State<PlanetViewer>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _stars = List.generate(
      3000,
      (index) => StarModel(
        positionX: Random().nextDouble() * 900,
        positionY: Random().nextDouble() * 900,
        size: Random().nextDouble() * 1,
        speed: Random().nextDouble() * 200,
      ),
    );
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    setState(() {
      _isLoading = true;
    });
    final planetCubit = BlocProvider.of<PlanetCubit>(context);
    await planetCubit.getPlanetInformation(widget.planetName);
    developer.log(planetCubit.planetInformation!.bodyType);

    setState(() {
      _isLoading = false;
    });

    super.didChangeDependencies();
  }

  List<StarModel> _stars = [];
  AnimationController? _animationController;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final planetCubit = BlocProvider.of<PlanetCubit>(context);
    final String name = widget.planetName.toLowerCase();
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return CustomPaint(
          painter: StarPainter(
            stars: _stars,
            animationValue: _animationController!.value,
          ),
          child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 1, 1, 53),
            appBar: AppBar(
              centerTitle: true,
              title: Text(widget.planetName),
              backgroundColor: const Color.fromARGB(255, 1, 1, 53),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: AnimatedBuilder(
              animation: _animationController!,
              builder: (context, child) {
                return CustomPaint(
                  painter: StarPainter(
                    stars: _stars,
                    animationValue: _animationController!.value,
                  ),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Stack(
                          children: [
                            Positioned(
                              top: 50,
                              left: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Body Type: ${planetCubit.planetInformation!.bodyType}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    'Mass: ${planetCubit.planetInformation!.mass.massValue} * 10^${planetCubit.planetInformation!.mass.massExponent}kg',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    'Volume: ${planetCubit.planetInformation!.vol.volValue} * 10^${planetCubit.planetInformation!.vol.volExponent}km³',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    'Mean Radius: ${planetCubit.planetInformation!.meanRadius} km',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    'Inclination: ${planetCubit.planetInformation!.inclination}°',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    'Gravity: ${planetCubit.planetInformation!.gravity} m/s²',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    'Mean temperature: ${planetCubit.planetInformation!.avgTemp - 273}°C',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    planetCubit.planetInformation!.moons == null
                                        ? 'No Moons'
                                        : 'Moons: ${planetCubit.planetInformation!.moons!.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: ModelViewer(
                                src: 'assets/$name.glb',
                                autoRotate: true,
                                ar: true,
                                autoPlay: true,
                              ),
                            ),
                          ],
                        ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
