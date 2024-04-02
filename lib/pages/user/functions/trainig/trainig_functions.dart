import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// __________________________workout_sublist____________________________________

Widget userWorkoutSubCard({
  required String? workoutImageUrl,
  required String workoutName,
  required String workoutTime,
  required void Function()? onTap,
  required BuildContext context,
}) {
  return InkWell(
    onTap: onTap,
    child: Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1.0,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: workoutImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: workoutImageUrl,
                        fit: BoxFit.cover,
                      )
                    : const Placeholder(
                        fallbackHeight: 80,
                        fallbackWidth: 80,
                      ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workoutName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 18,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Time: $workoutTime min',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
  required void Function()? onTap,
  required BuildContext context,
  required void Function()? wishList,
  required bool isWished,
}) {
  return InkWell(
    onTap: onTap,
    child: Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: SizedBox(
                height: 80,
                width: 80,
                child: categoryImg != null
                    ? CachedNetworkImage(
                        imageUrl: categoryImg,
                        fit: BoxFit.cover,
                      )
                    : const Placeholder(
                        fallbackHeight: 80,
                        fallbackWidth: 80,
                      ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoryName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Time: $workoutTime min',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'List: $workoutList',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isWished ? Icons.favorite : Icons.favorite_border,
                color: isWished ? Colors.red : Colors.grey,
              ),
              onPressed: wishList,
            ),
          ],
        ),
      ),
    ),
  );
}
