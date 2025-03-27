import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SplashScreen({
    super.key,
    required this.onComplete,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _fadeInController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeInAnimation;
  bool _startAnimation = false;
  bool _transitionTriggered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeInController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 75.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOutExpo),
      ),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeInController,
        curve: Curves.easeOut,
      ),
    );

    // Start the fade-in animation immediately
    _fadeInController.forward();

    // Add a delay before starting the zoom animation
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _startAnimation = true;
        });
        _controller.forward();
      }
    });

    // Listen to the animation to trigger transition at the right moment
    _controller.addListener(() {
      if (!_transitionTriggered && _controller.value > 0.5) {
        _transitionTriggered = true;
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeInController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_controller, _fadeInController]),
          builder: (context, child) {
            return Transform.scale(
              scale: _startAnimation ? _scaleAnimation.value : 1.0,
              child: Opacity(
                opacity: _fadeInAnimation.value,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'R',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 300,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'Q',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 300,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}