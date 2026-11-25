import 'package:flutter/material.dart';
import 'data/beach_data.dart';
import 'models/beach.dart';
import 'screens/beranda_screen.dart';
import 'screens/daftar_pantai_screen.dart';
import 'screens/detail_pantai_screen.dart';
import 'screens/peta_pantai_screen.dart';
import 'services/database_service.dart';
import 'theme/app_theme.dart';
import 'widgets/lunara_app_bar.dart';
import 'widgets/lunara_bottom_nav.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LunaraApp());
}

class LunaraApp extends StatelessWidget {
  const LunaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lunara Travel — Jejak Pantai',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LunaraHomeShell(),
    );
  }
}

class LunaraHomeShell extends StatefulWidget {
  const LunaraHomeShell({super.key});

  @override
  State<LunaraHomeShell> createState() => _LunaraHomeShellState();
}

class _LunaraHomeShellState extends State<LunaraHomeShell> {
  int _currentIndex = 0;
  List<Beach> _beaches = List.of(BeachData.initialBeaches);
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBeaches();
  }

  Future<void> _loadBeaches() async {
    try {
      final dbBeaches = await DatabaseService.instance.getBeaches();
      if (!mounted) return;
      setState(() {
        if (dbBeaches.isNotEmpty) {
          _beaches = dbBeaches;
        }
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleBookmark(String beachId) async {
    bool newValue = false;
    setState(() {
      _beaches = _beaches.map((b) {
        if (b.id == beachId) {
          newValue = !b.isBookmarked;
          return b.copyWith(isBookmarked: newValue);
        }
        return b;
      }).toList();
    });
    await DatabaseService.instance.toggleBookmark(beachId, newValue);
  }

  Future<void> _updateBeachLocation(
    String id,
    double mapX,
    double mapY,
    double distanceKm,
    String travelTime,
  ) async {
    setState(() {
      _beaches = _beaches.map((b) {
        if (b.id == id) {
          return b.copyWith(
            mapX: mapX,
            mapY: mapY,
            distanceKm: distanceKm,
            travelTime: travelTime,
          );
        }
        return b;
      }).toList();
    });
    await DatabaseService.instance.updateBeachLocation(
      id,
      mapX,
      mapY,
      distanceKm,
      travelTime,
    );
  }

  Future<void> _addNewBeach() async {
    final nameController = TextEditingController();
    final locationController = TextEditingController();
    final noteController = TextEditingController();

    final created = await showModalBottomSheet<Beach>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tambah Jejak Pantai',
                style: AppTextStyles.headlineSm(color: AppColors.primary),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Pantai',
                  hintText: 'Contoh: Pantai Indrayanti',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Lokasi / Kabupaten',
                  hintText: 'Contoh: Gunungkidul, DIY',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Catatan Singkat',
                  hintText: 'Pasir putih & sunset indah...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final location = locationController.text.trim();
                    if (name.isEmpty || location.isEmpty) return;

                    final newBeach = Beach(
                      id: 'beach_${DateTime.now().millisecondsSinceEpoch}',
                      name: name,
                      location: location,
                      fullAddress: location,
                      categoryTag: 'DESTINASI BARU',
                      imageUrl:
                          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=80',
                      distanceKm: 18.5,
                      travelTime: '± 35 mnt',
                      rating: 4.8,
                      reviewCount: 1,
                      ticketPrice: 'Rp 10.000',
                      bestTime: 'Sore / Sunset',
                      status: BeachVisitStatus.wishlist,
                      tags: const ['Pasir Putih'],
                      highlightNote: noteController.text.trim().isNotEmpty
                          ? noteController.text.trim()
                          : 'Catatan pantai baru',
                      journalQuote: noteController.text.trim().isNotEmpty
                          ? noteController.text.trim()
                          : null,
                      windAndWave: '10 knot • Ombak 1.2m (Aman)',
                      highTideTime: '17:30 WIB',
                      routeSummary: 'Via Jalur Pantai Selatan',
                      facilities: const [
                        BeachFacility(
                          name: 'Area Parkir Luas',
                          iconKey: 'parking',
                        ),
                        BeachFacility(
                          name: 'Toilet & Bilas',
                          iconKey: 'wc',
                        ),
                      ],
                      galleryUrls: const [],
                      isBookmarked: true,
                      mapX: 0.48,
                      mapY: 0.55,
                    );
                    Navigator.of(ctx).pop(newBeach);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Simpan ke SQLite'),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (created != null) {
      await DatabaseService.instance.insertBeach(created);
      if (!mounted) return;
      setState(() {
        _beaches = [created, ..._beaches];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${created.name} tersimpan ke SQLite')),
      );
    }
  }

  void _openDetail(Beach beach) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DetailPantaiScreen(
          beach: beach,
          onToggleBookmark: () => _toggleBookmark(beach.id),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      BerandaScreen(
        beaches: _beaches,
        onBeachTap: _openDetail,
        onToggleBookmark: _toggleBookmark,
        onSeeAllTap: () => setState(() => _currentIndex = 1),
      ),
      DaftarPantaiScreen(
        beaches: _beaches,
        onBeachTap: _openDetail,
        onToggleBookmark: _toggleBookmark,
      ),
      PetaPantaiScreen(
        beaches: _beaches,
        onBeachTap: _openDetail,
        onUpdateBeachLocation: _updateBeachLocation,
      ),
      _JurnalTab(
        beaches: _beaches.where((b) => b.journalQuote != null).toList(),
        onBeachTap: _openDetail,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : IndexedStack(
                index: _currentIndex,
                children: pages,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewBeach,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.add_rounded, size: 28),
      ),
      bottomNavigationBar: LunaraBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

class _JurnalTab extends StatelessWidget {
  final List<Beach> beaches;
  final ValueChanged<Beach> onBeachTap;

  const _JurnalTab({
    required this.beaches,
    required this.onBeachTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LunaraAppBar(subtitle: 'JURNAL PERJALANAN PESISIR'),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            itemCount: beaches.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final beach = beaches[index];
              return InkWell(
                onTap: () => onBeachTap(beach),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            beach.name,
                            style: AppTextStyles.headlineSm(
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            beach.visitedDate ?? 'BARU',
                            style: AppTextStyles.labelSm(
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '“${beach.journalQuote}”',
                        style: AppTextStyles.bodyMd(
                          color: AppColors.onSurfaceVariant,
                        ).copyWith(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
