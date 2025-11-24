import 'package:flutter/material.dart';
import 'package:math_corn/generated/l10n.dart';
import 'package:sizer/sizer.dart';

class ProfileStatsWidget extends StatefulWidget {
  final List<String>? onGoing;
  final List<String>? cart;
  final int savedVideos;

  const ProfileStatsWidget({
    super.key,
    this.onGoing,
    this.cart,
    required this.savedVideos,
  });

  @override
  State<ProfileStatsWidget> createState() => _ProfileStatsWidgetState();
}

class _ProfileStatsWidgetState extends State<ProfileStatsWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<int>> _countAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _animationControllers = List.generate(
      3,
      (index) => AnimationController(
        duration: Duration(milliseconds: 1000 + (index * 200)),
        vsync: this,
      ),
    );

    _scaleAnimations = _animationControllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.elasticOut));
    }).toList();

    final counts = [
      widget.onGoing?.length ?? 0,
      widget.cart?.length ?? 0,
      widget.savedVideos ?? 0,
    ];

    _countAnimations = _animationControllers.asMap().entries.map((entry) {
      final index = entry.key;
      final controller = entry.value;
      return IntTween(begin: 0, end: counts[index]).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
      );
    }).toList();
  }

  void _startAnimations() {
    for (int i = 0; i < _animationControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) {
          _animationControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.surface, colorScheme.surface.withOpacity(0.9)],
        ),
      ),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildEnhancedStatItem(
                context,
                title: S.of(context).onGoing,
                count: widget.onGoing?.length ?? 0,
                icon: Icons.play_circle_filled,
                primaryColor: Colors.orange,
                secondaryColor: Colors.deepOrange,
                animationIndex: 0,
                colorScheme: colorScheme,
              ),
              _buildVerticalDivider(colorScheme),
              _buildEnhancedStatItem(
                context,
                title: S.of(context).inCart,
                count: widget.cart?.length ?? 0,
                icon: Icons.shopping_cart,
                primaryColor: Colors.blue,
                secondaryColor: Colors.indigo,
                animationIndex: 1,
                colorScheme: colorScheme,
              ),
              _buildVerticalDivider(colorScheme),
              _buildEnhancedStatItem(
                context,
                title: S.of(context).savedVideos,
                count: (widget.savedVideos ?? 0),
                icon: Icons.bookmark,
                primaryColor: Colors.green,
                secondaryColor: Colors.teal,
                animationIndex: 2,
                colorScheme: colorScheme,
              ),
              _buildVerticalDivider(colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedStatItem(
    BuildContext context, {
    required String title,
    required int count,
    required IconData icon,
    required Color primaryColor,
    required Color secondaryColor,
    required int animationIndex,
    required ColorScheme colorScheme,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: AnimatedBuilder(
        animation: _animationControllers[animationIndex],
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimations[animationIndex].value,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 1.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      primaryColor.withOpacity(0.1),
                      primaryColor.withOpacity(0.05),
                    ],
                  ),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Enhanced Icon with glow effect
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [primaryColor, secondaryColor],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(icon, color: Colors.white, size: 6.w),
                    ),
                    SizedBox(height: 1.h),

                    // Animated Counter
                    AnimatedBuilder(
                      animation: _countAnimations[animationIndex],
                      builder: (context, child) {
                        return Text(
                          _countAnimations[animationIndex].value.toString(),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            fontSize: 21.sp,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 0.8.h),

                    // Title with enhanced styling
                    Text(
                      title,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface.withOpacity(0.8),
                        fontSize: 13.sp,
                        letterSpacing: 0.2,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerticalDivider(ColorScheme colorScheme) {
    return Container(
      height: 8.h,
      width: 1.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.outline.withOpacity(0.1),
            colorScheme.outline.withOpacity(0.5),
            colorScheme.outline.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(1),
      ),
      margin: EdgeInsets.symmetric(horizontal: 1.w),
    );
  }
}
