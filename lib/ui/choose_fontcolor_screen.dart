import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_sky/bloc/font_color_cubit/font_color_cubit.dart';
import 'package:our_sky/constants/constants.dart';

class ChooseFontColorScreen extends StatefulWidget {
  const ChooseFontColorScreen({Key? key}) : super(key: key);

  @override
  State<ChooseFontColorScreen> createState() => _ChooseFontColorScreenState();
}

class _ChooseFontColorScreenState extends State<ChooseFontColorScreen> {
  String? _selectedFontColor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Choose Font Color'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  itemCount: fontColors.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return BlocBuilder<FontColorCubit, FontColorState>(
                      builder: (context, state) {
                        if (state is FontColorChange) {
                          return GestureDetector(
                            onTap: () {
                              print(fontColors.entries.elementAt(index).key);
                              setState(() {
                                _selectedFontColor =
                                    fontColors.entries.elementAt(index).key;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    fontColors.entries.elementAt(index).value,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: state.fontColor ==
                                              fontColors.entries
                                                  .elementAt(index)
                                                  .key &&
                                          _selectedFontColor == null
                                      ? const Color.fromARGB(255, 33, 44, 243)
                                      : _selectedFontColor ==
                                              fontColors.entries
                                                  .elementAt(index)
                                                  .key
                                          ? const Color.fromARGB(
                                              255, 33, 44, 243)
                                          : Colors.black,
                                  width: state.fontColor ==
                                              fontColors.entries
                                                  .elementAt(index)
                                                  .key &&
                                          _selectedFontColor == null
                                      ? 3
                                      : _selectedFontColor ==
                                              fontColors.entries
                                                  .elementAt(index)
                                                  .key
                                          ? 3
                                          : 0.2,
                                ),
                              ),
                            ),
                          );
                        }
                        return Container();
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: _selectedFontColor != null
            ? FloatingActionButton(
                onPressed: () {
                  context
                      .read<FontColorCubit>()
                      .setFontColor(_selectedFontColor!);
                  Navigator.pop(context);
                },
                child: const Icon(Icons.check),
              )
            : const SizedBox());
  }
}
