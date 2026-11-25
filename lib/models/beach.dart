import 'dart:convert';

enum BeachVisitStatus {
  visited,
  wishlist,
}

class BeachFacility {
  final String name;
  final String iconKey;

  const BeachFacility({
    required this.name,
    required this.iconKey,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'iconKey': iconKey,
      };

  factory BeachFacility.fromJson(Map<String, dynamic> json) {
    return BeachFacility(
      name: json['name'] as String,
      iconKey: json['iconKey'] as String,
    );
  }
}

class Beach {
  final String id;
  final String name;
  final String location;
  final String fullAddress;
  final String categoryTag;
  final String imageUrl;
  final double distanceKm;
  final String travelTime;
  final double rating;
  final int reviewCount;
  final String ticketPrice;
  final String bestTime;
  final BeachVisitStatus status;
  final String? visitedDate;
  final List<String> tags;
  final String highlightNote;
  final String? journalQuote;
  final String? extraTips;
  final String windAndWave;
  final String highTideTime;
  final String routeSummary;
  final List<BeachFacility> facilities;
  final List<String> galleryUrls;
  final bool isBookmarked;
  final double mapX;
  final double mapY;

  const Beach({
    required this.id,
    required this.name,
    required this.location,
    required this.fullAddress,
    required this.categoryTag,
    required this.imageUrl,
    required this.distanceKm,
    required this.travelTime,
    required this.rating,
    required this.reviewCount,
    required this.ticketPrice,
    required this.bestTime,
    required this.status,
    this.visitedDate,
    required this.tags,
    required this.highlightNote,
    this.journalQuote,
    this.extraTips,
    required this.windAndWave,
    required this.highTideTime,
    required this.routeSummary,
    required this.facilities,
    required this.galleryUrls,
    this.isBookmarked = false,
    required this.mapX,
    required this.mapY,
  });

  Beach copyWith({
    bool? isBookmarked,
    BeachVisitStatus? status,
    double? mapX,
    double? mapY,
    double? distanceKm,
    String? travelTime,
  }) {
    return Beach(
      id: id,
      name: name,
      location: location,
      fullAddress: fullAddress,
      categoryTag: categoryTag,
      imageUrl: imageUrl,
      distanceKm: distanceKm ?? this.distanceKm,
      travelTime: travelTime ?? this.travelTime,
      rating: rating,
      reviewCount: reviewCount,
      ticketPrice: ticketPrice,
      bestTime: bestTime,
      status: status ?? this.status,
      visitedDate: visitedDate,
      tags: tags,
      highlightNote: highlightNote,
      journalQuote: journalQuote,
      extraTips: extraTips,
      windAndWave: windAndWave,
      highTideTime: highTideTime,
      routeSummary: routeSummary,
      facilities: facilities,
      galleryUrls: galleryUrls,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      mapX: mapX ?? this.mapX,
      mapY: mapY ?? this.mapY,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'fullAddress': fullAddress,
      'categoryTag': categoryTag,
      'imageUrl': imageUrl,
      'distanceKm': distanceKm,
      'travelTime': travelTime,
      'rating': rating,
      'reviewCount': reviewCount,
      'ticketPrice': ticketPrice,
      'bestTime': bestTime,
      'status': status.name,
      'visitedDate': visitedDate,
      'tags': jsonEncode(tags),
      'highlightNote': highlightNote,
      'journalQuote': journalQuote,
      'extraTips': extraTips,
      'windAndWave': windAndWave,
      'highTideTime': highTideTime,
      'routeSummary': routeSummary,
      'facilities': jsonEncode(facilities.map((f) => f.toJson()).toList()),
      'galleryUrls': jsonEncode(galleryUrls),
      'isBookmarked': isBookmarked ? 1 : 0,
      'mapX': mapX,
      'mapY': mapY,
    };
  }

  factory Beach.fromMap(Map<String, dynamic> map) {
    final decodedTags = (jsonDecode(map['tags'] as String) as List<dynamic>)
        .map((e) => e as String)
        .toList();
    final decodedFacilities =
        (jsonDecode(map['facilities'] as String) as List<dynamic>)
            .map((e) => BeachFacility.fromJson(e as Map<String, dynamic>))
            .toList();
    final decodedGallery =
        (jsonDecode(map['galleryUrls'] as String) as List<dynamic>)
            .map((e) => e as String)
            .toList();

    return Beach(
      id: map['id'] as String,
      name: map['name'] as String,
      location: map['location'] as String,
      fullAddress: map['fullAddress'] as String,
      categoryTag: map['categoryTag'] as String,
      imageUrl: map['imageUrl'] as String,
      distanceKm: (map['distanceKm'] as num).toDouble(),
      travelTime: map['travelTime'] as String,
      rating: (map['rating'] as num).toDouble(),
      reviewCount: map['reviewCount'] as int,
      ticketPrice: map['ticketPrice'] as String,
      bestTime: map['bestTime'] as String,
      status: BeachVisitStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => BeachVisitStatus.wishlist,
      ),
      visitedDate: map['visitedDate'] as String?,
      tags: decodedTags,
      highlightNote: map['highlightNote'] as String,
      journalQuote: map['journalQuote'] as String?,
      extraTips: map['extraTips'] as String?,
      windAndWave: map['windAndWave'] as String,
      highTideTime: map['highTideTime'] as String,
      routeSummary: map['routeSummary'] as String,
      facilities: decodedFacilities,
      galleryUrls: decodedGallery,
      isBookmarked: (map['isBookmarked'] as int) == 1,
      mapX: (map['mapX'] as num).toDouble(),
      mapY: (map['mapY'] as num).toDouble(),
    );
  }
}
