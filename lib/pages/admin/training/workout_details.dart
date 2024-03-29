import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pawskills/pages/admin/training/workout_subAdd.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class WorkoutDetails extends StatefulWidget {
  final String workoutName;
  final String imgUrl;
  final String details;
  final String time;
  final String? workoutList;
  final String? category;

  const WorkoutDetails({
    required this.workoutName,
    required this.imgUrl,
    required this.details,
    required this.time,
    this.workoutList,
    this.category,
    Key? key,
  }) : super(key: key);

  @override
  State<WorkoutDetails> createState() => _WorkoutDetailsState();
}

class _WorkoutDetailsState extends State<WorkoutDetails> {
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
        elevation: 0,
        // Remove elevation
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewWorkout(
                    workoutName: widget.workoutName,
                    workoutDetails: widget.details,
                    workoutImgUrl: widget.imgUrl,
                    workoutTime: widget.time,
                    category: widget.category,
                    workoutList: widget.workoutList,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit,
                color: Colors.black87), // Adjust icon color
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Adjust padding
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
                    color: Colors.black, // Change color
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
                      isPaused = !isPaused; // Toggle pause state
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Colors.blue[800]), // Change button color
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
                    backgroundColor: MaterialStateProperty.all(
                        Colors.cyan[600]), // Change button color
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
