import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LunaraAppBar extends StatelessWidget {
  final String subtitle;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const LunaraAppBar({
    super.key,
    required this.subtitle,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.surface,
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primaryFixed.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.waves_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'Lunara Travel',
                      style: AppTextStyles.headlineSm(color: AppColors.primary),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.coralSunset,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.labelSm(color: AppColors.outline),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onNotificationTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  Positioned(
                    top: 1,
                    right: 2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.coralSunset,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: onProfileTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                color: AppColors.onPrimary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
