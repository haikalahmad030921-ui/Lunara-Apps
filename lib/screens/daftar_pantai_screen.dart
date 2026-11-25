import 'package:flutter/material.dart';
import '../models/beach.dart';
import '../theme/app_theme.dart';
import '../widgets/beach_image.dart';
import '../widgets/lunara_app_bar.dart';

class DaftarPantaiScreen extends StatefulWidget {
  final List<Beach> beaches;
  final ValueChanged<Beach> onBeachTap;
  final ValueChanged<String> onToggleBookmark;

  const DaftarPantaiScreen({
    super.key,
    required this.beaches,
    required this.onBeachTap,
    required this.onToggleBookmark,
  });

  @override
  State<DaftarPantaiScreen> createState() => _DaftarPantaiScreenState();
}

class _DaftarPantaiScreenState extends State<DaftarPantaiScreen> {
  String _searchQuery = '';
  int _statusFilter = 0; // 0: Semua, 1: Ingin Dikunjungi, 2: Sudah Dikunjungi
  String _sortBy = 'Terdekat';

  @override
  Widget build(BuildContext context) {
    final wishlistCount = widget.beaches
        .where((b) => b.status == BeachVisitStatus.wishlist)
        .length;
    final visitedCount = widget.beaches
        .where((b) => b.status == BeachVisitStatus.visited)
        .length;

    final filtered = widget.beaches.where((b) {
      if (_statusFilter == 1 && b.status != BeachVisitStatus.wishlist) {
        return false;
      }
      if (_statusFilter == 2 && b.status != BeachVisitStatus.visited) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return b.name.toLowerCase().contains(q) ||
            b.location.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    if (_sortBy == 'Terdekat') {
      filtered.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    } else {
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return Column(
      children: [
        const LunaraAppBar(subtitle: 'KATALOG TOUR & DESTINASI'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'KATALOG & JURNAL PANTAI',
                    style: AppTextStyles.labelSm(color: AppColors.secondary),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${widget.beaches.length} Destinasi Terdata',
                      style: AppTextStyles.labelMd(
                        color: AppColors.onSurfaceVariant,
                      ).copyWith(fontSize: 10.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Eksplorasi Pesisir',
                style: AppTextStyles.headlineLg(color: AppColors.primary),
              ),
              const SizedBox(height: 6),
              Text(
                'Kompilasi jejak langkah pantai impian dan catatan kunjungan ombak nusantara.',
                style: AppTextStyles.bodyMd(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 16),

              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.warmSand),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      color: AppColors.outline,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        onChanged: (value) =>
                            setState(() => _searchQuery = value),
                        style: AppTextStyles.bodyMd(color: AppColors.primary),
                        decoration: InputDecoration(
                          hintText: 'Cari pantai atau kabupaten...',
                          hintStyle: AppTextStyles.bodyMd(
                            color: AppColors.outline,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.tune_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterPill(
                      label: 'Semua (${widget.beaches.length})',
                      isSelected: _statusFilter == 0,
                      onTap: () => setState(() => _statusFilter = 0),
                    ),
                    const SizedBox(width: 8),
                    _FilterPill(
                      label: 'Ingin Dikunjungi ($wishlistCount)',
                      dotColor: AppColors.coralSunset,
                      isSelected: _statusFilter == 1,
                      onTap: () => setState(() => _statusFilter = 1),
                    ),
                    const SizedBox(width: 8),
                    _FilterPill(
                      label: 'Sudah Dikunjungi ($visitedCount)',
                      dotColor: AppColors.primary,
                      isSelected: _statusFilter == 2,
                      onTap: () => setState(() => _statusFilter = 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Sort Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.swap_vert_rounded,
                        size: 16,
                        color: AppColors.outline,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'URUTKAN BERDASARKAN',
                        style: AppTextStyles.labelSm(color: AppColors.outline),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _sortBy,
                        isDense: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        style: AppTextStyles.labelLg(color: AppColors.primary)
                            .copyWith(fontSize: 12),
                        items: const [
                          DropdownMenuItem(
                            value: 'Terdekat',
                            child: Text('Terdekat'),
                          ),
                          DropdownMenuItem(
                            value: 'Rating Tertinggi',
                            child: Text('Rating Tertinggi'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _sortBy = value);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Hint Banner
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.swipe_left_outlined,
                      size: 15,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Geser kartu ke kiri untuk opsi hapus atau arsipkan',
                        style: AppTextStyles.bodySm(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Catalog Cards
              ...filtered.map(
                (beach) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _CatalogBeachCard(
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

class _FilterPill extends StatelessWidget {
  final String label;
  final Color? dotColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    this.dotColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(999),
          border: isSelected
              ? null
              : Border.all(color: AppColors.surfaceContainerHigh),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dotColor != null && !isSelected) ...[
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: AppTextStyles.labelLg(
                color: isSelected
                    ? AppColors.onPrimary
                    : AppColors.onSurfaceVariant,
              ).copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _CatalogBeachCard extends StatelessWidget {
  final Beach beach;
  final VoidCallback onTap;
  final VoidCallback onBookmarkTap;

  const _CatalogBeachCard({
    required this.beach,
    required this.onTap,
    required this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    final isVisited = beach.status == BeachVisitStatus.visited;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.surfaceContainerHigh),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Header
            SizedBox(
              height: 170,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  BeachImage(
                    imageUrl: beach.imageUrl,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.1),
                          AppColors.primary.withValues(alpha: 0.85),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
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
                                color: isVisited
                                    ? AppColors.primaryContainer
                                    : AppColors.coralSunset,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isVisited
                                        ? Icons.check_circle_rounded
                                        : Icons.favorite_border_rounded,
                                    size: 12,
                                    color: AppColors.onPrimary,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    isVisited
                                        ? 'SUDAH DIKUNJUNGI'
                                        : 'INGIN DIKUNJUNGI',
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
                                    .withValues(alpha: 0.94),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    size: 13,
                                    color: AppColors.coralSunset,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    '${beach.rating}',
                                    style: AppTextStyles.labelMd(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  Text(
                                    ' (${beach.reviewCount})',
                                    style: AppTextStyles.bodySm(
                                      color: AppColors.outline,
                                    ).copyWith(fontSize: 10.5),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          beach.categoryTag,
                          style: AppTextStyles.labelSm(
                            color: AppColors.primaryFixed,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          beach.name,
                          style: AppTextStyles.headlineMd(
                            color: AppColors.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 13,
                              color: AppColors.primaryFixed,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                beach.location,
                                style: AppTextStyles.bodySm(
                                  color: AppColors.surfaceContainerLow,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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

            // Metrics & Footer
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _MetricBox(
                          icon: Icons.near_me_outlined,
                          label: 'JARAK TEMPUH',
                          value: '${beach.distanceKm} km',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _MetricBox(
                          icon: Icons.confirmation_number_outlined,
                          label: 'TIKET MASUK',
                          value: beach.ticketPrice,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.auto_stories_outlined,
                        size: 15,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          beach.highlightNote,
                          style: AppTextStyles.bodySm(
                            color: AppColors.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        onTap: onBookmarkTap,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            beach.isBookmarked
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,
                            size: 18,
                            color: beach.isBookmarked
                                ? AppColors.secondary
                                : AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.directions_outlined,
                          size: 18,
                          color: AppColors.onPrimary,
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

class _MetricBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetricBox({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelSm(color: AppColors.outline)
                      .copyWith(fontSize: 9.5),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: AppTextStyles.titleSm(color: AppColors.primary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
