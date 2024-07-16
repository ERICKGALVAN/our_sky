import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_sky/bloc/font_cubit/font_cubit.dart';
import 'package:our_sky/constants/constants.dart';

class ChooseFontScreen extends StatefulWidget {
  const ChooseFontScreen({Key? key}) : super(key: key);

  @override
  State<ChooseFontScreen> createState() => _ChooseFontScreenState();
}

class _ChooseFontScreenState extends State<ChooseFontScreen> {
  String? _selectedFont;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Choose Font'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  itemCount: fonts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return BlocBuilder<FontCubit, FontState>(
                      builder: (context, state) {
                        if (state is FontChange) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedFont =
                                    fonts.entries.elementAt(index).key;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 230, 230, 230),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: state.font ==
                                              fonts.entries
                                                  .elementAt(index)
                                                  .key &&
                                          _selectedFont == null
                                      ? const Color.fromARGB(255, 33, 44, 243)
                                      : _selectedFont ==
                                              fonts.entries.elementAt(index).key
                                          ? const Color.fromARGB(
                                              255, 33, 44, 243)
                                          : Colors.black,
                                  width: state.font ==
                                              fonts.entries
                                                  .elementAt(index)
                                                  .key &&
                                          _selectedFont == null
                                      ? 3
                                      : _selectedFont ==
                                              fonts.entries.elementAt(index).key
                                          ? 3
                                          : 0.2,
                                ),
                              ),
                              child: Text(
                                fonts.entries
                                    .elementAt(index)
                                    .key
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontFamily: fonts.entries
                                      .elementAt(index)
                                      .value
                                      .fontFamily,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ),
        floatingActionButton: _selectedFont == null
            ? const SizedBox()
            : FloatingActionButton(
                onPressed: () {
                  context.read<FontCubit>().setFont(_selectedFont!);
                  Navigator.pop(context);
                },
                child: const Icon(Icons.check),
              ));
  }
}
