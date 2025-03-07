import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'Roverhome.dart';


class Mypage extends StatefulWidget {
  final Map<String, dynamic>? value;

  const Mypage({super.key, this.value});

  @override
  _Mypage createState() => _Mypage();
}

class _Mypage extends State<Mypage> {
  bool _isLoading = true;
  Timer? _timer;
  bool fetch = true;
  int? flag;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    const String url =
        "http://192.168.171.168:5000/running_or_not"; //http://10.0.2.2:3000/wether_rover_run_or_not

    // Start a timer for timeout handling
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
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Server Connected", style: TextStyle(fontSize: 20)),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Delay for a few seconds before transitioning
          await Future.delayed(const Duration(seconds: 6));
          setState(() {
            _isLoading = false;
          });
        } else {
          _retryFetch("Invalid or empty data received from server.");
        }
      } else {
        _retryFetch(
            "Failed to fetch data. Status Code: ${response.statusCode}");
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
      body: _isLoading
          ?  Center(
        child: Container(child: Lottie.asset("assets/cart.json"),),
      )
          : RoverControlScreen(flag: flag), // Pass `flag` dynamically
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
