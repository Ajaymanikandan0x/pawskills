import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pawskills/pages/user/functions/main_functios_user.dart';

// __________________________workout_sublist____________________________________

Widget userWorkoutSubCard({
  required String? workoutImageUrl,
  required String workoutName,
  required String workoutTime,
  required void Function()? ontap,
  required BuildContext context,
}) {
  return InkWell(
    onTap: ontap,
    child: Card(
      color: Colors.white,
      elevation: 10,
      shadowColor: Colors.grey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 70,
              width: 70,
              child: workoutImageUrl != null
                  ? Image.network(
                      workoutImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Placeholder(),
                    )
                  : const Placeholder(),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    workoutName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    workoutTime,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// ______________________________workout_card___________________________________
Widget userWorkoutCard({
  String? categoryImg,
  required String categoryName,
  required String workoutList,
  required String workoutTime,
  required void Function()? ontap,
  required BuildContext context,
  required void Function()? wishList,
  required bool isWished,
}) {
  return InkWell(
    onTap: ontap,
    child: Card(
      color: Colors.white,
      elevation: 10,
      shadowColor: Colors.grey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 70,
              width: 70,
              child: categoryImg != null
                  ? CachedNetworkImage(
                      imageUrl: categoryImg,
                      fit: BoxFit.cover,
                    )
                  : const Placeholder(),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    categoryName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        workoutList,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        workoutTime,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 10),
            child: wishButton(isWished: isWished, onTap: wishList),
          ),
        ],
      ),
    ),
  );
}
