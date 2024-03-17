import 'package:flutter/material.dart';
import '../admin_function.dart';

Widget workoutSubCard({
  required String? workoutImageUrl,
  required String workoutName,
  required String workoutTime,
  required void Function()? ontap,
  required BuildContext context,
  void Function()? delete,
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
              padding: const EdgeInsets.symmetric(vertical: 8.0),
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
          Padding(
            padding:
                const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 10),
            child: deleteButton(
                width: 35, height: 35, ontap: delete, icon_size: 18),
          ),
        ],
      ),
    ),
  );
}
