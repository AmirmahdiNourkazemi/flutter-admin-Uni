import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

  Widget menueButton({
    required BuildContext context,
    VoidCallback? onPressed,
    IconData? icon,
    String? text,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 0.2, color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: onPressed,
              icon: PhosphorIcon(
                                      icon!,
                                      size: 28,
                                    ),
            ),
            Text(
              text ?? '',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
