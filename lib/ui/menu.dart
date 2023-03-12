import 'dart:math';

import 'package:flutter/material.dart';
import 'package:our_sky/painters/star_painter.dart';
import 'package:our_sky/ui/sky_panoram.dart';
import 'package:our_sky/ui/view.dart';

import '../models/star_model.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _stars = List.generate(
      500,
      (index) => StarModel(
        positionX: Random().nextDouble() * 900,
        positionY: Random().nextDouble() * 900,
        size: Random().nextDouble() * 2,
        speed: Random().nextDouble() * 5,
      ),
    );
    super.initState();
  }

  AnimationController? _animationController;
  List<StarModel> _stars = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Menu',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromRGBO(2, 13, 166, 1),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(2, 13, 166, 1),
        child: CustomPaint(
          painter: StarPainter(
            stars: _stars,
            animationValue: _animationController!.value,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icon.png',
                  width: 200,
                  height: 200,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 33, 58, 243),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const View(),
                        ),
                      );
                    },
                    child: const Text('Solar system'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 243, 152, 33),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SkyPanoram(),
                        ),
                      );
                    },
                    child: const Text('Panoramic view'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
