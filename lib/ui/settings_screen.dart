import 'package:flutter/material.dart';
import 'package:our_sky/ui/choose_background_screen.dart';
import 'package:our_sky/ui/choose_font_screen.dart';
import 'package:our_sky/ui/choose_fontcolor_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Settings',
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
          const _SettingContainer(
            icon: Icons.abc,
            text: 'Language',
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChooseBackgroundScreen(),
                ),
              );
            },
            child: const _SettingContainer(
              icon: Icons.abc,
              text: 'Background Image',
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChooseFontScreen(),
                ),
              );
            },
            child: const _SettingContainer(
              icon: Icons.abc,
              text: 'Font',
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChooseFontColorScreen(),
                ),
              );
            },
            child: const _SettingContainer(
              icon: Icons.abc,
              text: 'Font Color',
            ),
          )
        ],
      ),
    );
  }
}

class _SettingContainer extends StatelessWidget {
  const _SettingContainer({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 0.6,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }
}
