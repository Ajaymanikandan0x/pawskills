import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class WorkoutDetails extends StatefulWidget {
  final String workoutName;
  final String imgUrl;
  final String details;
  final String time;

  const WorkoutDetails({
    required this.workoutName,
    required this.imgUrl,
    required this.details,
    required this.time,
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: CachedNetworkImage(
              imageUrl: widget.imgUrl,
              fit: BoxFit.cover,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Text(widget.workoutName),
                  const SizedBox(height: 15),
                  Text(widget.details),
                  const SizedBox(height: 15),
                  Countdown(
                    controller: _controller,
                    seconds: secondsRemaining,
                    build: (BuildContext context, double time) {
                      final remaining = time.toInt();
                      secondsRemaining = remaining;
                      return Text(
                        '${(remaining ~/ 60).toString().padLeft(2, '0')}:${(remaining % 60).toString().padLeft(2, '0')}',
                        style: const TextStyle(fontSize: 24),
                      );
                    },
                    interval: const Duration(seconds: 1),
                    onFinished: () {
                      // Defer the showSnackBar() call to the end of the frame
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
                        child: Text(isPaused ? 'Resume' : 'Pause'),
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
                        child: const Text('Restart'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
