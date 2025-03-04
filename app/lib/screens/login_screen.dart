import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and App Name
                Icon(Icons.surround_sound, size: 80, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 16),
                Text(
                  'AcoustoFlow',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  '음향실 관리 플랫폼',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark 
                        ? Colors.white70 
                        : Colors.black54,
                  ),
                ),
                const SizedBox(height: 60),
                
                // Social Login Buttons
                _buildSocialLoginButton(
                  context,
                  'Google 계정으로 로그인',
                  Colors.white,
                  Colors.black87,
                  'assets/icons/google_logo.png',
                  () => _handleGoogleSignIn(),
                ),
                const SizedBox(height: 16),
                _buildSocialLoginButton(
                  context,
                  '네이버 계정으로 로그인',
                  const Color(0xFF03C75A),
                  Colors.white,
                  'assets/icons/naver_logo.png',
                  () => _handleNaverSignIn(),
                ),
                const SizedBox(height: 16),
                _buildSocialLoginButton(
                  context,
                  '카카오 계정으로 로그인',
                  const Color(0xFFFEE500),
                  Colors.black87,
                  'assets/icons/kakao_logo.png',
                  () => _handleKakaoSignIn(),
                ),
                
                const SizedBox(height: 40),
                // For development - temporary direct access
                TextButton(
                  onPressed: () => Get.offNamed('/home'),
                  child: Text('임시: 바로 접속하기 (개발 모드)'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButton(
    BuildContext context,
    String text,
    Color backgroundColor,
    Color textColor,
    String iconAsset,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace Image.asset with Icon when actual assets are added
            Icon(Icons.login, size: 20),
            // Image.asset(
            //   iconAsset,
            //   height: 20,
            //   width: 20,
            // ),
            const SizedBox(width: 12),
            Text(text, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  void _handleGoogleSignIn() {
    // Implement Google Sign In
    // For now, navigate to home
    Get.offNamed('/home');
  }

  void _handleNaverSignIn() {
    // Implement Naver Sign In
    // For now, navigate to home
    Get.offNamed('/home');
  }

  void _handleKakaoSignIn() {
    // Implement Kakao Sign In
    // For now, navigate to home
    Get.offNamed('/home');
  }
} 