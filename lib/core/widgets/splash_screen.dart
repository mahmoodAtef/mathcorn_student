import 'dart:math' as math;

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:math_corn/core/services/app_initializer.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

import '../utils/assets_manager.dart';

// الطريقة الأولى: استخدام AnimatedSplashScreen مع Custom Widget
class SplashScreenV2 extends StatelessWidget {
  const SplashScreenV2({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenFunction(
      splash: const CustomSplashContent(),
      screenFunction: AppInitializer.init,
      splashIconSize: double.infinity,
      duration: 3500,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
      animationDuration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
      backgroundColor: Colors.transparent,
    );
  }
}

// Custom Widget للمحتوى المتحرك
class CustomSplashContent extends StatefulWidget {
  const CustomSplashContent({super.key});

  @override
  State<CustomSplashContent> createState() => _CustomSplashContentState();
}

class _CustomSplashContentState extends State<CustomSplashContent>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _floatingController;
  late AnimationController _particlesController;

  late Animation<double> _logoSlideAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _logoGlowAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _textBounceAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _particlesAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _particlesController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    // Logo animations
    _logoSlideAnimation = Tween<double>(begin: -200.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.7, curve: Curves.bounceOut),
      ),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _logoRotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi)
        .animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.0, 0.6, curve: Curves.easeInOutCubic),
          ),
        );

    _logoGlowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Text animations
    _textSlideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );

    _textBounceAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.7, 1.0, curve: Curves.elasticOut),
      ),
    );

    // Floating animation
    _floatingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    // Particles animation
    _particlesAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particlesController, curve: Curves.easeOut),
    );
  }

  void _startAnimations() {
    _mainController.forward();
    _floatingController.repeat(reverse: true);
    _particlesController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _floatingController.dispose();
    _particlesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.surface, colorScheme.surfaceVariant],
        ),
      ),
      child: Stack(
        children: [
          // Math Symbols Background
          AnimatedBuilder(
            animation: _particlesController,
            builder: (context, child) {
              return CustomPaint(
                painter: MathSymbolsPainter(
                  animation: _particlesAnimation,
                  color: colorScheme.primary,
                ),
                size: Size.infinite,
              );
            },
          ),

          // Main Content
          Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _mainController,
                _floatingController,
              ]),
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    0,
                    math.sin(_floatingAnimation.value * 2 * math.pi) * 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo with enhanced animations
                      Transform.translate(
                        offset: Offset(_logoSlideAnimation.value, 0),
                        child: Transform.rotate(
                          angle: _logoRotationAnimation.value,
                          child: Transform.scale(
                            scale: _logoScaleAnimation.value,
                            child: Hero(
                              tag: 'app_logo',
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorScheme.primary.withOpacity(
                                        0.4 * _logoGlowAnimation.value,
                                      ),
                                      blurRadius:
                                          25 + (15 * _logoGlowAnimation.value),
                                      spreadRadius:
                                          8 + (12 * _logoGlowAnimation.value),
                                    ),
                                    BoxShadow(
                                      color: colorScheme.primary.withOpacity(
                                        0.2 * _logoGlowAnimation.value,
                                      ),
                                      blurRadius:
                                          40 + (20 * _logoGlowAnimation.value),
                                      spreadRadius:
                                          15 + (10 * _logoGlowAnimation.value),
                                    ),
                                  ],
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: colorScheme.primary.withOpacity(
                                        0.3 * _logoGlowAnimation.value,
                                      ),
                                      width: 2,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 18.w,
                                    backgroundImage: AssetImage(
                                      AssetsManager.logo,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 5.h),

                      // Enhanced Text Animation
                      Transform.translate(
                        offset: Offset(0, _textSlideAnimation.value),
                        child: Transform.scale(
                          scale: _textBounceAnimation.value,
                          child: FadeTransition(
                            opacity: _textFadeAnimation,
                            child: Text(
                              "مش هتشيل هم الرياضة تاني",
                              style: theme.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: 1.2,
                                shadows: [
                                  Shadow(
                                    color: colorScheme.primary.withOpacity(0.5),
                                    blurRadius: 15,
                                    offset: const Offset(0, 3),
                                  ),
                                  Shadow(
                                    color: colorScheme.secondary.withOpacity(
                                      0.3,
                                    ),
                                    blurRadius: 25,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// الطريقة الثانية: splash أبسط مع AnimatedSplashScreen
class SimpleSplashV2 extends StatelessWidget {
  const SimpleSplashV2({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(AssetsManager.logo),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            "مش هتشيل هم الرياضة تاني",
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      nextScreen: FutureBuilder(
        future: AppInitializer.init(),
        builder: (context, snapshot) {
          return snapshot.data as Widget;
        },
      ),
      splashIconSize: 250,
      duration: 3000,
      splashTransition: SplashTransition.rotationTransition,
      pageTransitionType: PageTransitionType.leftToRightWithFade,
      animationDuration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOutQuart,
      backgroundColor: colorScheme.surface,
    );
  }
}

// نفس الـ CustomPainter للرموز الرياضية
class MathSymbolsPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  final List<String> mathSymbols = [
    '∑',
    '∫',
    'π',
    '∞',
    '√',
    '∆',
    'α',
    'β',
    'γ',
    'θ',
    '∂',
    '≠',
    '≤',
    '≥',
    '±',
    '∝',
    '≈',
    '∴',
    '∅',
    '∈',
    'φ',
    'λ',
    'μ',
    'ω',
    '÷',
    '×',
    '²',
    '³',
    'ℵ',
    '∇',
  ];

  MathSymbolsPainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < 30; i++) {
      final progress = (animation.value + i * 0.03) % 1.0;
      final x = (i * 137.5 % size.width);
      final y = size.height * progress;

      final symbolIndex = i % mathSymbols.length;
      final symbol = mathSymbols[symbolIndex];

      final opacity = math.sin(progress * math.pi) * 0.3;
      final fontSize = (math.sin(progress * math.pi) * 8) + 12;

      textPainter.text = TextSpan(
        text: symbol,
        style: TextStyle(
          color: color.withOpacity(opacity),
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      );

      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
