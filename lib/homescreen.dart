import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Liveloading.dart';
import 'Roverloading.dart';
import 'safetyloading.dart';
import 'safety.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isPersonal = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.pink.shade100, Colors.purple.shade100],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            _buildToggleButton(),
            const Spacer(),
            _buildLargeText(),
            const SizedBox(height: 20),
            Text(
              "CHECK YOUR INDUSTRIAL  SITES",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            _buildButtons(),
            const SizedBox(height: 20),
            _buildFooter(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _toggleButton("VIT-C", isPersonal),
          _toggleButton("Others", !isPersonal),
        ],
      ),
    );
  }

  Widget _toggleButton(String text, bool isActive) {
    return GestureDetector(
      onTap: () => setState(() => isPersonal = text == "VIT-C"),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isActive ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildLargeText() {
    return Text(
      "A4P",
      style: GoogleFonts.poppins(
        fontSize: 120,
        fontWeight: FontWeight.bold,
        color: Colors.purple.shade300,
        shadows: [
          Shadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(5, 5),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        _buildButton("Rover Setting", Colors.purple, Colors.white, _Roversetting),
        const SizedBox(height: 10),
        _buildButton("LIVE MONITORING", Colors.white, Colors.black, _onSafetyMonitoringPressed),
        const SizedBox(height: 10),
        _buildButton("SAFETY MONITORING", Colors.purple, Colors.white, _onPredictiveMaintenancePressed),

      ],
    );
  }
  void _Roversetting(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Mypage()));
  }
  void _onSafetyMonitoringPressed() {
    Navigator.push(context, MaterialPageRoute(builder:(context)=> liveview()));
  }

  void _onPredictiveMaintenancePressed() {
    Navigator.push(context, MaterialPageRoute(builder:(context)=> DroidCamStream1()));
    // Add navigation or functionality here
  }



  Widget _buildButton(String text, Color bgColor, Color textColor, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 300,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _footerItem("DO SMART", Colors.purple.shade700),
        const SizedBox(width: 5),
        Text("|", style: TextStyle(color: Colors.white70, fontSize: 16)),
        const SizedBox(width: 5),
        _footerItem("created by", Colors.white70),
        const SizedBox(width: 5),
        _footerItem("A4P", Colors.white),
      ],
    );
  }

  Widget _footerItem(String text, Color color) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 14,
        color: color,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}