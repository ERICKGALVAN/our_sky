import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_sky/bloc/background_cubit/background_cubit.dart';
import 'package:our_sky/bloc/selection_background/selection_background_cubit.dart';

class ChooseBackgroundScreen extends StatefulWidget {
  const ChooseBackgroundScreen({Key? key}) : super(key: key);

  @override
  State<ChooseBackgroundScreen> createState() => _ChooseBackgroundScreenState();
}

class _ChooseBackgroundScreenState extends State<ChooseBackgroundScreen> {
  @override
  void didChangeDependencies() {
    precacheImage(const AssetImage('assets/beach.jpg'), context);
    context.read<SelectionBackgroundCubit>().reset();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Choose Background',
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
      body: Column(
        children: [
          const Text(
            'Choose a background for the panoramic view',
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                itemCount: context.read<BackgroundCubit>().backgrounds.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => context
                        .read<SelectionBackgroundCubit>()
                        .changeBackground(
                            context.read<BackgroundCubit>().backgrounds[index]),
                    child: BlocBuilder<BackgroundCubit, BackgroundState>(
                      builder: (context, state) {
                        if (state is BackgroundImage) {
                          return _ImageWidget(
                            imagePath: context
                                .read<BackgroundCubit>()
                                .backgrounds[index],
                          );
                        }
                        return _ImageWidget(
                          imagePath: context
                              .read<BackgroundCubit>()
                              .backgrounds[index],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton:
          BlocBuilder<SelectionBackgroundCubit, SelectionBackgroundState>(
        builder: (context, state) {
          if (state is SelectionBackgroundChanged) {
            return FloatingActionButton(
              onPressed: () {
                context
                    .read<BackgroundCubit>()
                    .setBackgroundImage(state.selectedBackgroundPath);
                Navigator.pop(context);
              },
              child: const Icon(Icons.check),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _ImageWidget extends StatelessWidget {
  const _ImageWidget({
    Key? key,
    required this.imagePath,
  }) : super(key: key);
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BackgroundCubit, BackgroundState>(
      builder: (context, backgroundState) {
        return BlocBuilder<SelectionBackgroundCubit, SelectionBackgroundState>(
          builder: (context, selectionState) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: selectionState is SelectionBackgroundInitial &&
                        backgroundState is BackgroundImage &&
                        backgroundState.imagePath == imagePath
                    ? Border.all(
                        color: const Color.fromARGB(255, 33, 44, 243), width: 3)
                    : selectionState is SelectionBackgroundChanged &&
                            selectionState.selectedBackgroundPath == imagePath
                        ? Border.all(
                            color: const Color.fromARGB(255, 33, 44, 243),
                            width: 3)
                        : null,
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
