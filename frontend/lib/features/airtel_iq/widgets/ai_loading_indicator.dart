import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_constants.dart';

class AiLoadingIndicator extends StatelessWidget {
  final String message;

  const AiLoadingIndicator({super.key, this.message = 'AI is analyzing...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                color: AppConstants.primaryColor,
                strokeWidth: 3,
                backgroundColor: AppConstants.primaryColor.withValues(
                  alpha: 0.1,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
