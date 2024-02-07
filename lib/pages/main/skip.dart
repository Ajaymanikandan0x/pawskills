import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pawskills/pages/login/functions/Functions.dart';

class Skip extends StatelessWidget {
  const Skip({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      carousel_item(
          "Consistency is key in pet training. Stick to a routine and use the same commands consistently."),
      carousel_item(
          "Keep training sessions short and enjoyable for your pet. End on a positive note to keep them eager for the next session."),
      carousel_item(
          "Stay patient and understanding. Every pet learns at their own pace, so celebrate progress and be gentle with setbacks."),
      carousel_item(
          "Use positive reinforcement, like treats or praise, to encourage good behavior. Your pet will be more motivated to learn and please you.")
    ];
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(children: <Widget>[
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 300,
              child: Image.asset(
                'assets/img/photos/skiplogo.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'My Pets',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CarouselSlider(
                  items: items,
                  options: CarouselOptions(
                    height: 250,
                    aspectRatio: 16 / 9,
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 4),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.3,
                    scrollDirection: Axis.horizontal,
                  )),
            ),
            //goto home page
            button(text: 'Skip', routeName: '', context: context, width: 350)
          ]),
        ),
      ),
    );
  }
}

Widget carousel_item(String text) => SizedBox(
      child: Center(
          child: Text(
        text,
        style: TextStyle(
            fontSize: 17, color: Colors.grey[800], fontWeight: FontWeight.w400),
      )),
    );
