import 'package:hive/hive.dart';

part 'coin_model.g.dart';

@HiveType(typeId: 0)
class CoinModel extends HiveObject {
  CoinModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.marketCapRank,
    this.fullyDilutedValuation,
    required this.totalVolume,
    required this.high24h,
    required this.low24h,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
    required this.marketCapChange24h,
    required this.marketCapChangePercentage24h,
    required this.circulatingSupply,
    required this.totalSupply,
    this.maxSupply,
    required this.ath,
    required this.athChangePercentage,
    required this.athDate,
    required this.atl,
    required this.atlChangePercentage,
    required this.atlDate,
    this.roi,
    required this.lastUpdated,
    this.sparklineIn7d,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String symbol;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String image;
  @HiveField(4)
  final double currentPrice;
  @HiveField(5)
  final double marketCap;
  @HiveField(6)
  final int marketCapRank;
  @HiveField(7)
  final double? fullyDilutedValuation;
  @HiveField(8)
  final double totalVolume;
  @HiveField(9)
  final double high24h;
  @HiveField(10)
  final double low24h;
  @HiveField(11)
  final double priceChange24h;
  @HiveField(12)
  final double priceChangePercentage24h;
  @HiveField(13)
  final double marketCapChange24h;
  @HiveField(14)
  final double marketCapChangePercentage24h;
  @HiveField(15)
  final double circulatingSupply;
  @HiveField(16)
  final double totalSupply;
  @HiveField(17)
  final double? maxSupply;
  @HiveField(18)
  final double ath;
  @HiveField(19)
  final double athChangePercentage;
  @HiveField(20)
  final String athDate;
  @HiveField(21)
  final double atl;
  @HiveField(22)
  final double atlChangePercentage;
  @HiveField(23)
  final String atlDate;
  @HiveField(24)
  final RoiModel? roi;
  @HiveField(25)
  final String lastUpdated;
  @HiveField(26)
  final SparklineModel? sparklineIn7d;

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      currentPrice: (json['current_price'] as num).toDouble(),
      marketCap: (json['market_cap'] as num).toDouble(),
      marketCapRank: json['market_cap_rank'] as int,
      fullyDilutedValuation: json['fully_diluted_valuation'] != null
          ? (json['fully_diluted_valuation'] as num).toDouble()
          : null,
      totalVolume: (json['total_volume'] as num).toDouble(),
      high24h: (json['high_24h'] as num).toDouble(),
      low24h: (json['low_24h'] as num).toDouble(),
      priceChange24h: (json['price_change_24h'] as num).toDouble(),
      priceChangePercentage24h:
          (json['price_change_percentage_24h'] as num).toDouble(),
      marketCapChange24h: (json['market_cap_change_24h'] as num).toDouble(),
      marketCapChangePercentage24h:
          (json['market_cap_change_percentage_24h'] as num).toDouble(),
      circulatingSupply: (json['circulating_supply'] as num).toDouble(),
      totalSupply: (json['total_supply'] as num).toDouble(),
      maxSupply: json['max_supply'] != null
          ? (json['max_supply'] as num).toDouble()
          : null,
      ath: (json['ath'] as num).toDouble(),
      athChangePercentage: (json['ath_change_percentage'] as num).toDouble(),
      athDate: json['ath_date'] as String,
      atl: (json['atl'] as num).toDouble(),
      atlChangePercentage: (json['atl_change_percentage'] as num).toDouble(),
      atlDate: json['atl_date'] as String,
      roi: json['roi'] != null
          ? RoiModel.fromJson(json['roi'] as Map<String, dynamic>)
          : null,
      lastUpdated: json['last_updated'] as String,
      sparklineIn7d: json['sparkline_in_7d'] != null
          ? SparklineModel.fromJson(
              json['sparkline_in_7d'] as Map<String, dynamic>)
          : null,
    );
  }

  // Convert CoinModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'image': image,
      'current_price': currentPrice,
      'market_cap': marketCap,
      'market_cap_rank': marketCapRank,
      'fully_diluted_valuation': fullyDilutedValuation,
      'total_volume': totalVolume,
      'high_24h': high24h,
      'low_24h': low24h,
      'price_change_24h': priceChange24h,
      'price_change_percentage_24h': priceChangePercentage24h,
      'market_cap_change_24h': marketCapChange24h,
      'market_cap_change_percentage_24h': marketCapChangePercentage24h,
      'circulating_supply': circulatingSupply,
      'total_supply': totalSupply,
      'max_supply': maxSupply,
      'ath': ath,
      'ath_change_percentage': athChangePercentage,
      'ath_date': athDate,
      'atl': atl,
      'atl_change_percentage': atlChangePercentage,
      'atl_date': atlDate,
      'roi': roi?.toJson(),
      'last_updated': lastUpdated,
      'sparkline_in_7d': sparklineIn7d?.toJson(),
    };
  }

  // CopyWith method for creating modified copies
  CoinModel copyWith({
    String? id,
    String? symbol,
    String? name,
    String? image,
    double? currentPrice,
    double? marketCap,
    int? marketCapRank,
    double? fullyDilutedValuation,
    double? totalVolume,
    double? high24h,
    double? low24h,
    double? priceChange24h,
    double? priceChangePercentage24h,
    double? marketCapChange24h,
    double? marketCapChangePercentage24h,
    double? circulatingSupply,
    double? totalSupply,
    double? maxSupply,
    double? ath,
    double? athChangePercentage,
    String? athDate,
    double? atl,
    double? atlChangePercentage,
    String? atlDate,
    RoiModel? roi,
    String? lastUpdated,
    SparklineModel? sparklineIn7d,
  }) {
    return CoinModel(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      image: image ?? this.image,
      currentPrice: currentPrice ?? this.currentPrice,
      marketCap: marketCap ?? this.marketCap,
      marketCapRank: marketCapRank ?? this.marketCapRank,
      fullyDilutedValuation:
          fullyDilutedValuation ?? this.fullyDilutedValuation,
      totalVolume: totalVolume ?? this.totalVolume,
      high24h: high24h ?? this.high24h,
      low24h: low24h ?? this.low24h,
      priceChange24h: priceChange24h ?? this.priceChange24h,
      priceChangePercentage24h:
          priceChangePercentage24h ?? this.priceChangePercentage24h,
      marketCapChange24h: marketCapChange24h ?? this.marketCapChange24h,
      marketCapChangePercentage24h:
          marketCapChangePercentage24h ?? this.marketCapChangePercentage24h,
      circulatingSupply: circulatingSupply ?? this.circulatingSupply,
      totalSupply: totalSupply ?? this.totalSupply,
      maxSupply: maxSupply ?? this.maxSupply,
      ath: ath ?? this.ath,
      athChangePercentage: athChangePercentage ?? this.athChangePercentage,
      athDate: athDate ?? this.athDate,
      atl: atl ?? this.atl,
      atlChangePercentage: atlChangePercentage ?? this.atlChangePercentage,
      atlDate: atlDate ?? this.atlDate,
      roi: roi ?? this.roi,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      sparklineIn7d: sparklineIn7d ?? this.sparklineIn7d,
    );
  }

  @override
  String toString() {
    return 'CoinModel(id: $id, symbol: $symbol, name: $name, currentPrice: $currentPrice, priceChangePercentage24h: $priceChangePercentage24h)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CoinModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// ROI Model
@HiveType(typeId: 1)
class RoiModel {
  const RoiModel({
    required this.times,
    required this.currency,
    required this.percentage,
  });

  @HiveField(0)
  final double times;
  @HiveField(1)
  final String currency;
  @HiveField(2)
  final double percentage;

  factory RoiModel.fromJson(Map<String, dynamic> json) {
    return RoiModel(
      times: (json['times'] as num).toDouble(),
      currency: json['currency'] as String,
      percentage: (json['percentage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'times': times,
      'currency': currency,
      'percentage': percentage,
    };
  }
}

// Sparkline Model
@HiveType(typeId: 2)
class SparklineModel {
  const SparklineModel({
    required this.price,
  });

  @HiveField(0)
  final List<double> price;

  factory SparklineModel.fromJson(Map<String, dynamic> json) {
    return SparklineModel(
      price: (json['price'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
    };
  }
}
