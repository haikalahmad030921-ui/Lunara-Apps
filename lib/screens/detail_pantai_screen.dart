import 'package:flutter/material.dart';
import '../models/beach.dart';
import '../theme/app_theme.dart';
import '../widgets/beach_image.dart';

class DetailPantaiScreen extends StatefulWidget {
  final Beach beach;
  final VoidCallback onToggleBookmark;

  const DetailPantaiScreen({
    super.key,
    required this.beach,
    required this.onToggleBookmark,
  });

  @override
  State<DetailPantaiScreen> createState() => _DetailPantaiScreenState();
}

class _DetailPantaiScreenState extends State<DetailPantaiScreen> {
  late bool _isBookmarked;

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.beach.isBookmarked;
  }

  @override
  Widget build(BuildContext context) {
    final beach = widget.beach;
    final isVisited = beach.status == BeachVisitStatus.visited;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 310,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  BeachImage(imageUrl: beach.imageUrl),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.25),
                          Colors.transparent,
                          AppColors.surface.withValues(alpha: 0.96),
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _CircleIconButton(
                                icon: Icons.arrow_back_rounded,
                                onTap: () => Navigator.of(context).pop(),
                              ),
                              Row(
                                children: [
                                  _CircleIconButton(
                                    icon: _isBookmarked
                                        ? Icons.bookmark_rounded
                                        : Icons.bookmark_border_rounded,
                                    iconColor: _isBookmarked
                                        ? AppColors.secondary
                                        : AppColors.primary,
                                    onTap: () {
                                      setState(
                                        () => _isBookmarked = !_isBookmarked,
                                      );
                                      widget.onToggleBookmark();
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  _CircleIconButton(
                                    icon: Icons.share_outlined,
                                    onTap: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Membagikan ${beach.name}...',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: isVisited
                                  ? AppColors.secondaryFixed
                                  : AppColors.primaryFixed,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isVisited
                                      ? Icons.verified_outlined
                                      : Icons.schedule_rounded,
                                  size: 13,
                                  color: isVisited
                                      ? AppColors.secondary
                                      : AppColors.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  isVisited
                                      ? 'SUDAH DIKUNJUNGI PADA ${beach.visitedDate ?? "14 OKT 2024"}'
                                      : 'INGIN DIKUNJUNGI',
                                  style: AppTextStyles.labelSm(
                                    color: isVisited
                                        ? AppColors.secondary
                                        : AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            beach.name,
                            style: AppTextStyles.headlineLg(
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 15,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  beach.fullAddress,
                                  style: AppTextStyles.bodySm(
                                    color: AppColors.onSurfaceVariant,
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
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // 2x2 Info Grid
                Row(
                  children: [
                    Expanded(
                      child: _DetailInfoTile(
                        icon: Icons.near_me_outlined,
                        label: 'JARAK',
                        value: '${beach.distanceKm} km',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _DetailInfoTile(
                        icon: Icons.star_rounded,
                        iconColor: AppColors.secondary,
                        label: 'RATING',
                        value: '${beach.rating} (${beach.reviewCount})',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _DetailInfoTile(
                        icon: Icons.confirmation_number_outlined,
                        label: 'TIKET',
                        value: beach.ticketPrice,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _DetailInfoTile(
                        icon: Icons.wb_twilight_rounded,
                        iconColor: AppColors.secondary,
                        label: 'WAKTU BAIK',
                        value: beach.bestTime,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Coordinates & Access
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.map_outlined,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Titik Koordinat & Akses',
                          style: AppTextStyles.titleMd(color: AppColors.primary),
                        ),
                      ],
                    ),
                    Text(
                      'GPS Aktif',
                      style: AppTextStyles.labelMd(color: AppColors.secondary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.surfaceContainerHigh),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 125,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD6E9EB),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(18),
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: const BoxDecoration(
                                  color: AppColors.secondary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.waves_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLowest,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  beach.name,
                                  style: AppTextStyles.titleSm(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Rute Jalur Selatan',
                                    style: AppTextStyles.bodySm(
                                      color: AppColors.outline,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    beach.routeSummary,
                                    style: AppTextStyles.titleSm(
                                      color: AppColors.primary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Buka Petunjuk Arah',
                                    style: AppTextStyles.labelMd(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.open_in_new_rounded,
                                    size: 14,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Facilities
                Row(
                  children: [
                    const Icon(
                      Icons.beach_access_rounded,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Fasilitas Penunjang',
                      style: AppTextStyles.titleMd(color: AppColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: beach.facilities.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 3.4,
                  ),
                  itemBuilder: (context, index) {
                    final facility = beach.facilities[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _facilityIcon(facility.iconKey),
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              facility.name,
                              style: AppTextStyles.bodySm(
                                color: AppColors.primary,
                              ).copyWith(fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Explorer Notes / Journal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.edit_note_rounded,
                          size: 20,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Catatan Penjelajah',
                          style: AppTextStyles.titleMd(color: AppColors.primary),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryFixed.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Jurnal Pribadi',
                        style: AppTextStyles.labelMd(
                          color: AppColors.secondary,
                        ).copyWith(fontSize: 10.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    borderRadius: BorderRadius.circular(16),
                    border: const Border(
                      left: BorderSide(
                        color: AppColors.secondary,
                        width: 4,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '“${beach.journalQuote ?? beach.highlightNote}”',
                        style: AppTextStyles.bodyMd(color: AppColors.primary)
                            .copyWith(fontStyle: FontStyle.italic),
                      ),
                      if (beach.extraTips != null) ...[
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tips Tambahan: ',
                              style: AppTextStyles.labelLg(
                                color: AppColors.primary,
                              ).copyWith(fontSize: 12),
                            ),
                            Expanded(
                              child: Text(
                                beach.extraTips!,
                                style: AppTextStyles.bodySm(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (beach.galleryUrls.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 76,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: beach.galleryUrls.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, index) => BeachImage(
                              imageUrl: beach.galleryUrls[index],
                              width: 104,
                              height: 76,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Wind & Wave Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.air_rounded,
                        color: AppColors.primaryFixed,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kondisi Angin & Ombak',
                              style: AppTextStyles.bodySm(
                                color: AppColors.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              beach.windAndWave,
                              style: AppTextStyles.titleSm(
                                color: AppColors.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'PASANG LAUT',
                            style: AppTextStyles.labelSm(
                              color: AppColors.onPrimaryContainer,
                            ).copyWith(fontSize: 9),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            beach.highTideTime,
                            style: AppTextStyles.titleSm(
                              color: AppColors.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.surfaceContainerHigh),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              _CircleIconButton(
                icon: Icons.edit_outlined,
                bgColor: AppColors.surfaceContainerLow,
                onTap: () {},
              ),
              const SizedBox(width: 10),
              _CircleIconButton(
                icon: Icons.delete_outline_rounded,
                bgColor: AppColors.surfaceContainerLow,
                onTap: () {},
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Memulai navigasi ke ${beach.name}...'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.directions_car_outlined, size: 18),
                  label: const Text('Navigasi Rute'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: const StadiumBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _facilityIcon(String key) {
    switch (key) {
      case 'mosque':
        return Icons.mosque_outlined;
      case 'parking':
        return Icons.local_parking_rounded;
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'camera':
        return Icons.photo_camera_outlined;
      case 'camp':
        return Icons.terrain_rounded;
      default:
        return Icons.wc_rounded;
    }
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    this.iconColor = AppColors.primary,
    this.bgColor = AppColors.surfaceContainerLowest,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor,
      shape: const CircleBorder(),
      elevation: 1,
      shadowColor: AppColors.primary.withValues(alpha: 0.1),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, size: 20, color: iconColor),
        ),
      ),
    );
  }
}

class _DetailInfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _DetailInfoTile({
    required this.icon,
    this.iconColor = AppColors.primary,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 17, color: iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelSm(color: AppColors.outline)
                      .copyWith(fontSize: 9.5),
                ),
                const SizedBox(height: 2),
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
