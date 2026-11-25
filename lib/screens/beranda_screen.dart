import 'package:flutter/material.dart';
import '../models/beach.dart';
import '../theme/app_theme.dart';
import '../widgets/beach_image.dart';
import '../widgets/lunara_app_bar.dart';

class BerandaScreen extends StatefulWidget {
  final List<Beach> beaches;
  final ValueChanged<Beach> onBeachTap;
  final ValueChanged<String> onToggleBookmark;
  final VoidCallback onSeeAllTap;

  const BerandaScreen({
    super.key,
    required this.beaches,
    required this.onBeachTap,
    required this.onToggleBookmark,
    required this.onSeeAllTap,
  });

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  String _selectedFilter = 'Semua';

  static const List<(String, IconData)> _filters = [
    ('Semua', Icons.beach_access_rounded),
    ('Pasir Putih', Icons.grain_rounded),
    ('Sunset Spot', Icons.wb_twilight_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final featured = widget.beaches.first;
    final nearbyBeaches = widget.beaches.where((b) {
      if (b.id == featured.id) return false;
      if (_selectedFilter == 'Semua') return true;
      return b.tags.contains(_selectedFilter);
    }).toList();

    return Column(
      children: [
        const LunaraAppBar(subtitle: 'JELAJAH WISATA & PANTAI'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            children: [
              // Location Pill
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryFixed.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.wb_sunny_outlined,
                        size: 14,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'PESISIR SELATAN • YOGYAKARTA',
                        style: AppTextStyles.labelSm(
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Greeting
              Text(
                'Halo, Petualang! 🌊',
                style: AppTextStyles.headlineLg(color: AppColors.primary),
              ),
              const SizedBox(height: 6),
              Text(
                'Jelajahi surga pesisir nusantara hari ini dengan angin sejuk dan deburan ombak.',
                style: AppTextStyles.bodyMd(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 20),

              // 3 Stat Cards
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.waves_rounded,
                      iconBg: AppColors.primaryFixed.withValues(alpha: 0.6),
                      iconColor: AppColors.primary,
                      value: '12',
                      valueColor: AppColors.primary,
                      label: 'TOTAL PANTAI',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.check_circle_outline_rounded,
                      iconBg: AppColors.secondaryFixed.withValues(alpha: 0.7),
                      iconColor: AppColors.secondary,
                      value: '7',
                      valueColor: AppColors.secondary,
                      label: 'DIKUNJUNGI',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.star_rounded,
                      iconBg: AppColors.warmSand.withValues(alpha: 0.8),
                      iconColor: AppColors.tertiary,
                      value: '4.8★',
                      valueColor: AppColors.primary,
                      label: 'RATA RATING',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((filter) {
                    final isSelected = _selectedFilter == filter.$1;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () {
                          setState(() => _selectedFilter = filter.$1);
                        },
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(999),
                            border: isSelected
                                ? null
                                : Border.all(
                                    color: AppColors.surfaceContainerHigh,
                                  ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                filter.$2,
                                size: 15,
                                color: isSelected
                                    ? AppColors.onPrimary
                                    : AppColors.onSurfaceVariant,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                filter.$1,
                                style: AppTextStyles.labelLg(
                                  color: isSelected
                                      ? AppColors.onPrimary
                                      : AppColors.onSurfaceVariant,
                                ).copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 18),

              // Featured Card
              _FeaturedBeachCard(
                beach: featured,
                onTap: () => widget.onBeachTap(featured),
              ),
              const SizedBox(height: 24),

              // Nearby Section Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pantai Terdekat dari Saya',
                          style:
                              AppTextStyles.headlineSm(color: AppColors.primary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Berdasarkan lokasi GPS saat ini',
                          style: AppTextStyles.bodySm(color: AppColors.outline),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: widget.onSeeAllTap,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Lihat Semua',
                            style: AppTextStyles.labelLg(
                              color: AppColors.secondary,
                            ).copyWith(fontSize: 12),
                          ),
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 16,
                            color: AppColors.secondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Nearby List
              ...nearbyBeaches.map(
                (beach) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _NearbyBeachCard(
                    beach: beach,
                    onTap: () => widget.onBeachTap(beach),
                    onBookmarkTap: () => widget.onToggleBookmark(beach.id),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String value;
  final Color valueColor;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.value,
    required this.valueColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 17, color: iconColor),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppTextStyles.headlineMd(color: valueColor).copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.labelSm(color: AppColors.outline),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FeaturedBeachCard extends StatelessWidget {
  final Beach beach;
  final VoidCallback onTap;

  const _FeaturedBeachCard({
    required this.beach,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 215,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.12),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            BeachImage(
              imageUrl: beach.imageUrl,
              borderRadius: BorderRadius.circular(18),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.12),
                    AppColors.primary.withValues(alpha: 0.86),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.flag_rounded,
                              size: 12,
                              color: AppColors.onPrimary,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              beach.categoryTag,
                              style: AppTextStyles.labelSm(
                                color: AppColors.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest
                              .withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.near_me_outlined,
                              size: 12,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${beach.distanceKm} km',
                              style: AppTextStyles.labelMd(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'REKOMENDASI HARI INI',
                              style: AppTextStyles.labelSm(
                                color: AppColors.primaryFixed,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              beach.name,
                              style: AppTextStyles.headlineMd(
                                color: AppColors.onPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 14,
                                  color: AppColors.primaryFixed,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    '${beach.location}  •  ★ ${beach.rating}',
                                    style: AppTextStyles.bodySm(
                                      color: AppColors.surfaceContainerLow,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: AppColors.coralSunset,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.onPrimary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NearbyBeachCard extends StatelessWidget {
  final Beach beach;
  final VoidCallback onTap;
  final VoidCallback onBookmarkTap;

  const _NearbyBeachCard({
    required this.beach,
    required this.onTap,
    required this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    final isVisited = beach.status == BeachVisitStatus.visited;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceContainerHigh),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                BeachImage(
                  imageUrl: beach.imageUrl,
                  width: 96,
                  height: 104,
                  borderRadius: BorderRadius.circular(12),
                ),
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${beach.distanceKm} km',
                      style: AppTextStyles.labelSm(
                        color: AppColors.onPrimary,
                      ).copyWith(fontSize: 9),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          beach.name,
                          style: AppTextStyles.titleMd(
                            color: AppColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isVisited
                              ? AppColors.surfaceContainer
                              : AppColors.secondaryFixed.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          isVisited ? 'Sudah Dikunjungi' : 'Ingin Dikunjungi',
                          style: AppTextStyles.labelSm(
                            color: isVisited
                                ? AppColors.primary
                                : AppColors.secondary,
                          ).copyWith(fontSize: 9.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: AppColors.outline,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          beach.location,
                          style: AppTextStyles.bodySm(
                            color: AppColors.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: AppColors.coralSunset,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${beach.rating}',
                        style: AppTextStyles.labelLg(
                          color: AppColors.primary,
                        ).copyWith(fontSize: 12),
                      ),
                      Text(
                        ' (${beach.reviewCount})  •  ${beach.ticketPrice}',
                        style: AppTextStyles.bodySm(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          beach.highlightNote,
                          style: AppTextStyles.bodySm(
                            color: AppColors.outline,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        onTap: onBookmarkTap,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Icon(
                            beach.isBookmarked
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,
                            size: 18,
                            color: beach.isBookmarked
                                ? AppColors.secondary
                                : AppColors.outline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
