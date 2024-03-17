import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class UserWorkoutDetails extends StatefulWidget {
  final String workoutName;
  final String imgUrl;
  final String details;
  final String time;
  final String? workoutList;
  final String? category;

  const UserWorkoutDetails({
    required this.workoutName,
    required this.imgUrl,
    required this.details,
    required this.time,
    this.workoutList,
    this.category,
    Key? key,
  }) : super(key: key);

  @override
  State<UserWorkoutDetails> createState() => _UserWorkoutDetailsState();
}

class _UserWorkoutDetailsState extends State<UserWorkoutDetails> {
  late int initialSeconds;
  int secondsRemaining = 0;
  bool isPaused = false;

  final CountdownController _controller = CountdownController(autoStart: true);

  @override
  void initState() {
    super.initState();
    initialSeconds = int.parse(widget.time) * 60; // Convert minutes to seconds
    secondsRemaining = initialSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Exercise Details',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[200],
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: widget.imgUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Lottie.asset('assets/json/loading.json'),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              height: 200,
              width: double.infinity,
            ),
            const SizedBox(height: 20),
            Text(
              widget.workoutName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  widget.details,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 1,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: CircularProgressIndicator(
                    value: secondsRemaining / initialSeconds,
                    strokeWidth: 10,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.black),
                    backgroundColor: Colors.grey[300],
                  ),
                ),
                Countdown(
                  controller: _controller,
                  seconds: secondsRemaining,
                  build: (BuildContext context, double time) {
                    final remaining = time.toInt();
                    secondsRemaining = remaining;
                    return Text(
                      '${(remaining ~/ 60).toString().padLeft(2, '0')}:${(remaining % 60).toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    );
                  },
                  interval: const Duration(seconds: 1),
                  onFinished: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Timer finished!'),
                        ),
                      );
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (isPaused) {
                      _controller.resume();
                    } else {
                      _controller.pause();
                    }
                    setState(() {
                      isPaused = !isPaused;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blue[800]),
                  ),
                  child: Text(
                    isPaused ? 'Resume' : 'Pause',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    _controller.restart();
                    setState(() {
                      secondsRemaining = initialSeconds;
                      isPaused = false;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.cyan[600]),
                  ),
                  child: const Text(
                    'Restart',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
