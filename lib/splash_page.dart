import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image covers whole screen
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Image.asset('assets/images/splash_back.png'),
          ),
          // Foreground contents
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                // Title + Tagline centered in the middle
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'RentLens',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 56,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Buka dunia fotografi tanpa batas. Sewa, \npakai, ulangi',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Bottom buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _GateButton(
                      label: 'Login',
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                    ),
                    const SizedBox(width: 16),
                    _GateButton(
                      label: 'Daftar',
                      onPressed: () =>
                          Navigator.pushNamed(context, '/register'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GateButton extends StatelessWidget {
  const _GateButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6A5AE0),
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
        elevation: 6,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
