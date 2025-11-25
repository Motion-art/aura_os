import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../core/app_export.dart';

class SplashScreenThree extends StatelessWidget {
  final VoidCallback onNext;

  const SplashScreenThree({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // App logo illustration
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? 'assets/aura_os_dark.png'
                      : 'assets/aura_os_light.png',
                  width: 32.w,
                  height: 32.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Get Started',
              style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text(
                'Achieve more with focused work sessions and smart task management',
                textAlign: TextAlign.center,
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onBackground
                      .withOpacity(0.7),
                ),
              ),
            ),
            SizedBox(height: 6.h),
            ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Start Your Journey',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
