import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(view());
}

class view extends StatefulWidget {
  List<int> value = [1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1];

  @override
  State<view> createState() => _viewState();
}

class _viewState extends State<view> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: GNav(
          gap: 8,
          backgroundColor: Colors.blue.shade100,
          color: Colors.black,
          activeColor: Colors.black,
          tabs: [
            GButton(
              icon: Icons.settings,
              text: "Settings",
              textStyle: GoogleFonts.radioCanada(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            GButton(
              icon: Icons.rotate_right,
              text: "Fan",
              textStyle: GoogleFonts.radioCanada(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            GButton(
              icon: Icons.light_mode,
              text: "Light",
              textStyle: GoogleFonts.radioCanada(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            )
          ],
        ),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color(0xFF3988A4),
                Color(0xFF67C2D4),
                Color(0xD0994D)
              ])),
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 60,
                    width: 270,
                    color: Colors.green,
                    child: Center(
                        child: Text(
                      "BOARD",
                      style: TextStyle(fontSize: 30),
                    )),
                  )),
              Align(
                alignment: Alignment.topLeft,
                child: Icon(
                  Icons.meeting_room_outlined,
                  size: 60,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.meeting_room_outlined,
                  size: 60,
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 700,
                    child: GridView.builder(
                      itemCount: widget.value.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (context, index) => fan(widget.value[index]),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class fan extends StatefulWidget {
  int x;

  @override
  State<fan> createState() => _fanState();

  fan(this.x);
}

class _fanState extends State<fan> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Color key = Colors.white;

  Future<void> exitDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          children: [
            Text("Fan details:"),
            Row(
              children: [
                Icon(Icons.electric_bolt_sharp),
                Text("Energy usage:"),
              ],
            ),
            Row(
              children: [
                Icon(Icons.access_time),
                Text("Runtime:"),
              ],
            )
          ],
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text("Close"))
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    setState(() {
      if (widget.x == 1) {
        _controller.repeat();
        key = Colors.green.withOpacity(0.5);
      } else {
        _controller.stop();
        key = Colors.yellow.withOpacity(0.5);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => exitDialog(context),
      child: Card(
        color: key,
        child: Lottie.asset(
          "assets/fan.json",
          controller: _controller,
        ),
      ),
    );
  }
}
