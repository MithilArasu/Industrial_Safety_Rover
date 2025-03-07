import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lottie/lottie.dart';

class RoverControlScreen extends StatefulWidget {
  final int ?flag;

  const RoverControlScreen({super.key, required this.flag});

  @override
  _RoverControlScreenState createState() => _RoverControlScreenState();
}

class _RoverControlScreenState extends State<RoverControlScreen> {
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController breadthController = TextEditingController();
  String statusMessage = "";
  bool isLoading = false;

  Future<void> runRover() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Connected To Server"),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue,
      ),
    );

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('http://192.168.171.168:5000/rover');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "length": lengthController.text,
        "breadth": breadthController.text,
      }),
    );

    setState(() {
      isLoading = false;
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Rover is Working",style: TextStyle(color: Colors.black),),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        statusMessage = "Error: ${response.body}";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(gradient:LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.pink.shade100, Colors.purple.shade100],
              ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(child: Lottie.asset("assets/rover.json"),),
                          const SizedBox(height: 20),
                          const Text(
                            'Rover Details!',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 40),
                          if (widget.flag == 1)
                            const Column(
                              children: [
                                Text(
                                  "Rover is running..."
                                  ,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            )
                          else
                            Column(
                              children: [
                                TextField(
                                  controller: lengthController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Enter Length',
                                    prefixIcon: Icon(Icons.arrow_forward,
                                        color: Colors.green[700]),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  controller: breadthController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Enter Breadth',
                                    prefixIcon: Icon(Icons.arrow_forward,
                                        color: Colors.green[700]),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 40),
                                ElevatedButton(
                                  onPressed: runRover,
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                      color: Colors.blue)
                                      : const Text("Run Rover"),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
