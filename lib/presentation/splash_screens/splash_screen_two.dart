import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../core/app_export.dart';

class SplashScreenTwo extends StatelessWidget {
  final VoidCallback onNext;

  const SplashScreenTwo({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
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
                'Track Your Energy',
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  'Monitor your focus levels and energy patterns throughout the day',
                  textAlign: TextAlign.center,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onBackground
                        .withOpacity(0.7),
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 1.5.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Next',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
