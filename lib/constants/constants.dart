import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

String appId = '41d2801d-8465-4ac1-9b1c-0e5da4611461';
String appSecret =
    '6f304c57a66430f18791e0f5896cbe45af9ff31d07b96e2636087650de2854674fc45e890718226b6aabda2e0dc4fadb26c676506674ca9b9191349e2e35549e914a909e7e8e3ba24fcb500d143ef0c57051213bdb92700b688303fee0050662d4cd14762b67dac04b047fd1fdf99798';
String auth = '$appId:$appSecret';

Map<int, String> monthTimes = {
  1: '12:00:00',
  2: '05:00:00',
  3: '07:00:00',
  4: '09:00:00',
  5: '11:00:00',
  6: '01:00:00',
  7: '00:00:00',
  8: '00:00:00',
  9: '00:00:00',
  10: '00:00:00',
  11: '00:00:00',
  12: '14:00:00',
};

final fonts = {
  'roboto': GoogleFonts.roboto(),
  'robotoMono': GoogleFonts.robotoMono(),
  'robotoSlab': GoogleFonts.robotoSlab(),
  'openSans': GoogleFonts.openSans(),
  'lato': GoogleFonts.lato(),
  'poppins': GoogleFonts.poppins(),
  'raleway': GoogleFonts.raleway(),
  'nunito': GoogleFonts.nunito(),
};

final fontColors = {
  'white': Colors.white,
  'black': Colors.black,
  'red': Colors.red,
  'green': Colors.green,
  'blue': Colors.blue,
  'yellow': Colors.yellow,
};
