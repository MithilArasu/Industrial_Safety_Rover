import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '2ndpage.dart';
import 'finalpage.dart';

class AB1Screen extends StatelessWidget {
  int nf = 2;
  int nl = 3;
  final List<String> floors = [
    '1st',
    '2nd',
    '3rd',
    '4th',
    '5th',
    '6th',
    '7th',
    '8th'
  ];
  final List<List<List<int>>> fanMatrix;
  AB1Screen({required this.fanMatrix});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AB1',
          style: GoogleFonts.bebasNeue(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFFA7C7E7), // Matching the gradient's top color
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              // Sky color
              Color(0xFFA7C7E7), // Light blue
              Color(0xFFFAD6C4),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildInfoCard(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Select a Floor',
                  style: GoogleFonts.roboto(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two columns
                      crossAxisSpacing: 10, // Horizontal spacing
                      mainAxisSpacing: 10, // Vertical spacing
                      childAspectRatio: 2.5, // Adjust button aspect ratio
                    ),
                    itemCount: floors.length,
                    itemBuilder: (context, index) {
                      return GradientButton(
                          label: '${floors[index]} Floor',
                          onPressed: () => navigate(context, index));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigate(BuildContext context, int floorIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FloorDetailsScreen(
          floorName: floors[floorIndex],
          floorFanMatrix: fanMatrix[floorIndex],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white.withOpacity(0.9),
      shadowColor: Colors.black.withOpacity(0.2), // Subtle shadow for depth
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
                Icons.lightbulb_outline, 'Num of fans ', 'not Working: $nf '),
            SizedBox(height: 10),
            _buildInfoRow(
                Icons.lightbulb, 'Num of lights ', 'not Working: $nl'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Row(
          children: [
            Icon(icon, color: Color(0xfff2e017)),
            SizedBox(width: 10),
            Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff141414),
              ),
            ),
          ],
        ),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
          ),
        ),
      ],
    );
  }

  void _checkFanStatus(BuildContext context, int floorIndex) {
    List<String> nonWorkingFans = [];

    for (int classroom = 0; classroom < 12; classroom++) {
      for (int fan = 0; fan < 6; fan++) {
        if (fanMatrix[floorIndex][classroom][fan] == 0) {
          nonWorkingFans.add('Classroom ${classroom + 1}, Fan ${fan + 1}');
        }
      }
    }

    String message = nonWorkingFans.isEmpty
        ? 'All fans are working on this floor.'
        : 'Non-working fans:\n${nonWorkingFans.join('\n')}';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Fan Status - ${floors[floorIndex]} Floor'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const GradientButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffaabbdf),
              Color(0xffaabbbdf), // Sky color
              // Peach
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(2, 2),
              blurRadius: 8,
            )
          ],
        ),
        child: Center(
          child: Text(
            label.toUpperCase(),
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}