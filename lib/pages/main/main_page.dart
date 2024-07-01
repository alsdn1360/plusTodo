import 'package:flutter/material.dart';
import 'package:plus_todo/themes/custom_font.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '+',
                style: CustomTextStyle.header1.copyWith(
                  fontFamily: 'Prentendard',
                  fontFeatures: [const FontFeature.superscripts()],
                ),
              ),
              TextSpan(
                text: 'Todo',
                style: CustomTextStyle.header1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
