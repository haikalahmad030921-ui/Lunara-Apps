import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/beach.dart';
import '../theme/app_theme.dart';
import '../widgets/beach_image.dart';
import '../widgets/lunara_app_bar.dart';

class PetaPantaiScreen extends StatefulWidget {
  final List<Beach> beaches;
  final ValueChanged<Beach> onBeachTap;
  final void Function(
    String id,
    double mapX,
    double mapY,
    double distanceKm,
    String travelTime,
  ) onUpdateBeachLocation;

  const PetaPantaiScreen({
    super.key,
    required this.beaches,
    required this.onBeachTap,
    required this.onUpdateBeachLocation,
  });

  @override
  State<PetaPantaiScreen> createState() => _PetaPantaiScreenState();
}

class _PetaPantaiScreenState extends State<PetaPantaiScreen> {
  static const double _mapWidth = 1000;
  static const double _mapHeight = 1000;
  static const double _userX = 0.42;
  static const double _userY = 0.50;

  final TransformationController _mapController = TransformationController();
  int _filterIndex = 0;
  late String _selectedBeachId;
  bool _showBottomSheet = true;

  @override
  void initState() {
    super.initState();
    final initial = widget.beaches.firstWhere(
      (b) => b.id == 'drini',
      orElse: () => widget.beaches.first,
    );
    _selectedBeachId = initial.id;
    WidgetsBinding.instance.addPostFrameCallback((_) => _centerOnUser());
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _centerOnUser() {
    if (!mounted) return;
    final size = MediaQuery.of(context).size;
    final tx = (size.width / 2) - (_mapWidth * _userX);
    final ty = (size.height * 0.35) - (_mapHeight * _userY);
    _mapController.value = Matrix4.identity()..translateByDouble(tx, ty, 0, 1);
  }

  void _zoomBy(double factor) {
    final current = _mapController.value.clone();
    final currentScale = current.getMaxScaleOnAxis();
    final nextScale = (currentScale * factor).clamp(0.6, 2.5);
    final ratio = nextScale / currentScale;
    final size = MediaQuery.of(context).size;
    final focalX = size.width / 2;
    final focalY = size.height * 0.35;

    final updated = Matrix4.identity()
      ..translateByDouble(focalX, focalY, 0, 1)
      ..scaleByDouble(ratio, ratio, 1, 1)
      ..translateByDouble(-focalX, -focalY, 0, 1)
      ..multiply(current);

    _mapController.value = updated;
  }

  (double, String) _calculateDistanceAndTime(double mapX, double mapY) {
    final dx = (mapX - _userX) * 110.0;
    final dy = (mapY - _userY) * 110.0;
    final km = math.max(1.2, math.sqrt(dx * dx + dy * dy));
    final roundedKm = double.parse(km.toStringAsFixed(1));
    final minutes = (roundedKm * 1.8).round();
    final timeStr = minutes >= 60
        ? '± ${minutes ~/ 60} jam ${minutes % 60} mnt'
        : '± $minutes mnt';
    return (roundedKm, timeStr);
  }

  @override
  Widget build(BuildContext context) {
    final selectedBeach = widget.beaches.firstWhere(
      (b) => b.id == _selectedBeachId,
      orElse: () => widget.beaches.first,
    );

    final filteredBeaches = widget.beaches.where((b) {
      if (_filterIndex == 1) return b.status == BeachVisitStatus.visited;
      if (_filterIndex == 2) return b.status == BeachVisitStatus.wishlist;
      return true;
    }).toList();

    return Column(
      children: [
        const LunaraAppBar(subtitle: 'PETA PANTAI'),
        Expanded(
          child: Stack(
            children: [
              // Interactive Google-Maps-like Pan & Zoom Canvas
              Positioned.fill(
                child: InteractiveViewer(
                  transformationController: _mapController,
                  constrained: false,
                  minScale: 0.6,
                  maxScale: 2.5,
                  boundaryMargin: const EdgeInsets.all(200),
                  child: SizedBox(
                    width: _mapWidth,
                    height: _mapHeight,
                    child: Stack(
                      children: [
                        Container(
                          width: _mapWidth,
                          height: _mapHeight,
                          color: const Color(0xFFE7EFEA),
                          child: CustomPaint(
                            painter: _CoastalMapPainter(),
                          ),
                        ),

                        // User Position Marker
                        Positioned(
                          left: _mapWidth * _userX - 42,
                          top: _mapHeight * _userY - 22,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary
                                      .withValues(alpha: 0.18),
                                  shape: BoxShape.circle,
                                ),
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.5,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  'Posisi Anda',
                                  style: AppTextStyles.labelSm(
                                    color: AppColors.onPrimary,
                                  ).copyWith(fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Draggable Beach Pins
                        ...filteredBeaches.map((beach) {
                          final isSelected = selectedBeach.id == beach.id;
                          final isVisited =
                              beach.status == BeachVisitStatus.visited;
                          final pinColor = isSelected || !isVisited
                              ? AppColors.secondary
                              : AppColors.primary;

                          return Positioned(
                            left: _mapWidth * beach.mapX - 50,
                            top: _mapHeight * beach.mapY - 30,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedBeachId = beach.id;
                                  _showBottomSheet = true;
                                });
                              },
                              onPanUpdate: (details) {
                                final scale =
                                    _mapController.value.getMaxScaleOnAxis();
                                final newX = (beach.mapX +
                                        (details.delta.dx / scale) / _mapWidth)
                                    .clamp(0.05, 0.95);
                                final newY = (beach.mapY +
                                        (details.delta.dy / scale) /
                                            _mapHeight)
                                    .clamp(0.05, 0.95);
                                final (dist, time) =
                                    _calculateDistanceAndTime(newX, newY);
                                widget.onUpdateBeachLocation(
                                  beach.id,
                                  newX,
                                  newY,
                                  dist,
                                  time,
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: pinColor,
                                      borderRadius: BorderRadius.circular(999),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.18),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isVisited
                                              ? Icons.verified_rounded
                                              : Icons.bookmark_rounded,
                                          size: 11,
                                          color: AppColors.onPrimary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          beach.name
                                              .replaceFirst('Pantai ', ''),
                                          style: AppTextStyles.labelSm(
                                            color: AppColors.onPrimary,
                                          ).copyWith(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Container(
                                    width: isSelected ? 30 : 24,
                                    height: isSelected ? 30 : 24,
                                    decoration: BoxDecoration(
                                      color: pinColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.beach_access_rounded,
                                      size: 13,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),

              // Top Floating Region Bar & Filters
              Positioned(
                top: 12,
                left: 16,
                right: 16,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest
                            .withValues(alpha: 0.96),
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.explore_outlined,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pesisir Selatan Jawa',
                                  style: AppTextStyles.titleSm(
                                    color: AppColors.primary,
                                  ),
                                ),
                                Text(
                                  'Geser peta atau tarik pin untuk sinkronisasi lokasi',
                                  style: AppTextStyles.bodySm(
                                    color: AppColors.outline,
                                  ).copyWith(fontSize: 11),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.tune_rounded,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Filter',
                                  style: AppTextStyles.labelMd(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _MapFilterChip(
                            label: 'Semua (${widget.beaches.length})',
                            isSelected: _filterIndex == 0,
                            onTap: () => setState(() => _filterIndex = 0),
                          ),
                          const SizedBox(width: 8),
                          _MapFilterChip(
                            label:
                                'Sudah Dikunjungi (${widget.beaches.where((b) => b.status == BeachVisitStatus.visited).length})',
                            dotColor: AppColors.primary,
                            isSelected: _filterIndex == 1,
                            onTap: () => setState(() => _filterIndex = 1),
                          ),
                          const SizedBox(width: 8),
                          _MapFilterChip(
                            label: 'Ingin Dikunjungi',
                            dotColor: AppColors.secondary,
                            isSelected: _filterIndex == 2,
                            onTap: () => setState(() => _filterIndex = 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Right-side Map Controls
              Positioned(
                right: 16,
                top: 136,
                child: Column(
                  children: [
                    _MapControlButton(
                      icon: Icons.near_me_outlined,
                      onTap: _centerOnUser,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () => _zoomBy(1.25),
                            icon: const Icon(Icons.add_rounded, size: 20),
                            color: AppColors.primary,
                            constraints: const BoxConstraints(
                              minWidth: 40,
                              minHeight: 40,
                            ),
                          ),
                          const Divider(height: 1, indent: 8, endIndent: 8),
                          IconButton(
                            onPressed: () => _zoomBy(0.8),
                            icon: const Icon(Icons.remove_rounded, size: 20),
                            color: AppColors.primary,
                            constraints: const BoxConstraints(
                              minWidth: 40,
                              minHeight: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _MapControlButton(
                      icon: Icons.waves_rounded,
                      onTap: _centerOnUser,
                    ),
                  ],
                ),
              ),

              // Bottom Sheet Card
              if (_showBottomSheet)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.14),
                          blurRadius: 24,
                          offset: const Offset(0, -6),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 38,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.outlineVariant,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                BeachImage(
                                  imageUrl: selectedBeach.imageUrl,
                                  width: 88,
                                  height: 88,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                Positioned(
                                  top: 6,
                                  left: 6,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: selectedBeach.status ==
                                              BeachVisitStatus.visited
                                          ? AppColors.primary
                                          : AppColors.secondary,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      selectedBeach.status ==
                                              BeachVisitStatus.visited
                                          ? 'DIKUNJUNGI'
                                          : 'INGIN\nDIKUNJUNGI',
                                      style: AppTextStyles.labelSm(
                                        color: AppColors.onPrimary,
                                      ).copyWith(fontSize: 8.5, height: 1.15),
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
                                          selectedBeach.name,
                                          style: AppTextStyles.headlineSm(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => setState(
                                          () => _showBottomSheet = false,
                                        ),
                                        child: const Icon(
                                          Icons.close_rounded,
                                          size: 20,
                                          color: AppColors.outline,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    selectedBeach.fullAddress,
                                    style: AppTextStyles.bodySm(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondaryFixed
                                          .withValues(alpha: 0.55),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          size: 13,
                                          color: AppColors.secondary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${selectedBeach.distanceKm} km (${selectedBeach.travelTime})',
                                          style: AppTextStyles.labelMd(
                                            color: AppColors.secondary,
                                          ).copyWith(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _SheetStat(
                                  label: 'RATING',
                                  value: '★ ${selectedBeach.rating}',
                                ),
                              ),
                              Expanded(
                                child: _SheetStat(
                                  label: 'TIKET MASUK',
                                  value: selectedBeach.ticketPrice,
                                ),
                              ),
                              Expanded(
                                child: _SheetStat(
                                  label: 'KARAKTERISTIK',
                                  value: selectedBeach.tags.isNotEmpty
                                      ? selectedBeach.tags.first
                                      : 'Pantai',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    widget.onBeachTap(selectedBeach),
                                icon: const Icon(
                                  Icons.info_outline_rounded,
                                  size: 18,
                                ),
                                label: const Text('Detail Lengkap'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: const BorderSide(
                                    color: AppColors.outlineVariant,
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 13),
                                  shape: const StadiumBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Membuka rute ke ${selectedBeach.name}...',
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.directions_outlined,
                                  size: 18,
                                ),
                                label: const Text('Rute Navigasi'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondary,
                                  foregroundColor: AppColors.onSecondary,
                                  elevation: 0,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 13),
                                  shape: const StadiumBorder(),
                                ),
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
      ],
    );
  }
}

class _MapFilterChip extends StatelessWidget {
  final String label;
  final Color? dotColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _MapFilterChip({
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
              : AppColors.surfaceContainerLowest.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 8,
            ),
          ],
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
                color: isSelected ? AppColors.onPrimary : AppColors.primary,
              ).copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MapControlButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainerLowest,
      shape: const CircleBorder(),
      elevation: 2,
      shadowColor: AppColors.primary.withValues(alpha: 0.15),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
      ),
    );
  }
}

class _SheetStat extends StatelessWidget {
  final String label;
  final String value;

  const _SheetStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.labelSm(color: AppColors.outline)
              .copyWith(fontSize: 9.5),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.titleSm(color: AppColors.primary),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _CoastalMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.75)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final minorRoadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path1 = Path()
      ..moveTo(0, size.height * 0.32)
      ..quadraticBezierTo(
        size.width * 0.45,
        size.height * 0.28,
        size.width,
        size.height * 0.42,
      );
    canvas.drawPath(path1, roadPaint);

    final path2 = Path()
      ..moveTo(size.width * 0.3, 0)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.4,
        size.width * 0.25,
        size.height,
      );
    canvas.drawPath(path2, roadPaint);

    final path3 = Path()
      ..moveTo(0, size.height * 0.55)
      ..quadraticBezierTo(
        size.width * 0.6,
        size.height * 0.6,
        size.width,
        size.height * 0.48,
      );
    canvas.drawPath(path3, minorRoadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
