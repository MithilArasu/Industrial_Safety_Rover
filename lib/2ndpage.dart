import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ab1page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FocusScreen(),
    );
  }
}

class FocusScreen extends StatelessWidget {
  final List<List<List<int>>> fanMatrix = List.generate(
    8,
        (_) => List.generate(
      12,
          (_) => List.generate(6, (_) => 1),
    ),
  );
  FocusScreen() {
    fanMatrix[0][2][1] = 0; // 1st floor, 3rd classroom, 2nd fan
    fanMatrix[0][5][3] = 0;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFA7C7E7), // Light blue
                Color(0xFFFAD6C4),
              ]),
        ),
        child: Stack(
          children: [
            // Centered Text
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'VIT-C',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2.0,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'SELECT YOUR BLOCK',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            // Buttons at the bottom
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButton(
                        label: 'ab1',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AB1Screen(fanMatrix: fanMatrix),
                              ));
                        }),
                    SizedBox(height: 10),
                    CustomButton(label: 'ab2', onPressed: () {}),
                    SizedBox(height: 10),
                    CustomButton(label: 'ab3', onPressed: () {}),
                    SizedBox(height: 10),
                    CustomButton(label: 'ab4', onPressed: () {}),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CustomButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 200,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffaabbdf), // Sky color
              Color(0xd2c7d5d1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(4, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label.toUpperCase(),
            style: GoogleFonts.robotoCondensed(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}