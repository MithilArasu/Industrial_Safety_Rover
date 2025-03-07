import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class FloorDetailsScreen extends StatelessWidget {
  final String floorName;
  final List<List<int>> floorFanMatrix;

  FloorDetailsScreen({required this.floorName, required this.floorFanMatrix});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$floorName Floor Details'),
        backgroundColor: Color(0xFFA7C7E7),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFA7C7E7), Color(0xFFFAD6C4)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Classroom Fan Status',
                style: GoogleFonts.roboto(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: floorFanMatrix.length,
                  itemBuilder: (context, classroomIndex) {
                    return ClassroomCard(
                      classroomNumber: classroomIndex + 1,
                      fans: floorFanMatrix[classroomIndex],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClassroomCard extends StatelessWidget {
  final int classroomNumber;
  final List<int> fans;

  ClassroomCard({required this.classroomNumber, required this.fans});

  @override
  Widget build(BuildContext context) {
    int workingFans = fans.where((fan) => fan == 1).length;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(
          'Classroom $classroomNumber',
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('$workingFans/${fans.length} fans working'),
        leading: Icon(
          Icons.meeting_room,
          color: workingFans == fans.length ? Colors.green : Colors.orange,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(fans.length, (index) {
                  return FanWidget(
                    isWorking: fans[index] == 1,
                    label: 'Fan ${index + 1}',
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FanWidget extends StatelessWidget {
  final bool isWorking;
  final String label;

  FanWidget({required this.isWorking, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isWorking
            ? SpinningFan(size: 60, color: Colors.blue)
            : StaticFan(size: 60, color: Colors.red),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}

class SpinningFan extends StatefulWidget {
  final double size;
  final Color color;

  const SpinningFan({Key? key, this.size = 80, this.color = Colors.blue})
      : super(key: key);

  @override
  _SpinningFanState createState() => _SpinningFanState();
}

class _SpinningFanState extends State<SpinningFan>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: FanPainter(color: widget.color),
          ),
        );
      },
    );
  }
}

class StaticFan extends StatelessWidget {
  final double size;
  final Color color;

  const StaticFan({Key? key, this.size = 80, this.color = Colors.red})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: FanPainter(color: color),
    );
  }
}

class FanPainter extends CustomPainter {
  final Color color;

  FanPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw the center circle
    canvas.drawCircle(center, radius * 0.15, paint);

    // Draw the blades
    for (int i = 0; i < 3; i++) {
      final angle = 2 * pi / 3 * i;
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(
          center.dx + radius * 0.9 * cos(angle - 0.3),
          center.dy + radius * 0.9 * sin(angle - 0.3),
        )
        ..arcToPoint(
          Offset(
            center.dx + radius * 0.9 * cos(angle + 0.3),
            center.dy + radius * 0.9 * sin(angle + 0.3),
          ),
          radius: Radius.circular(radius * 0.6),
          clockwise: false,
        )
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}