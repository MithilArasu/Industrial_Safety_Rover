import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'Live.dart';

class liveview1 extends StatefulWidget {
  final Map<String, dynamic>? value;

  const liveview1({super.key, this.value});

  @override
  _liveview1 createState() => _liveview1();
}

class _liveview1 extends State<liveview1> {
  bool _isLoading = true;
  Timer? _timer;
  int? flag;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    const String url = "http://192.168.171.168:5000/running_or_not";

    _timer = Timer(const Duration(seconds: 30), () {
      if (_isLoading) {
        _retryFetch("Request timed out. Retrying...");
      }
    });

    try {
      final response = await http.get(Uri.parse(url));

      if (!_timer!.isActive) return;
      _timer?.cancel();

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        print(response);
        if (responseData != null && responseData is Map<String, dynamic>) {
          setState(() {
            flag = responseData["running"];
            if(flag==0){
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Rover is not Running", style: TextStyle(fontSize: 20)),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            }
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Server Connected", style: TextStyle(fontSize: 20)),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          await Future.delayed(const Duration(seconds: 6));

          if (flag == 1 && !_isLoading) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DroidCamStream()),
            );
          }
        } else {
          _retryFetch("Invalid or empty data received from server.");
        }
      } else {
        _retryFetch("Failed to fetch data. Status Code: ${response.statusCode}");
      }
    } catch (error) {
      if (_timer!.isActive) {
        _retryFetch("An error occurred: $error");
      }
    } finally {
      _timer?.cancel();
    }
  }

  void _retryFetch(String errorMessage) {
    _timer?.cancel();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage, style: const TextStyle(fontSize: 20)),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(seconds: 2), _fetchData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Lottie.asset("assets/safe.json"),
        ),
      ),
    );
  }
}
