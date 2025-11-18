// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CoinModelAdapter extends TypeAdapter<CoinModel> {
  @override
  final int typeId = 0;

  @override
  CoinModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CoinModel(
      id: fields[0] as String,
      symbol: fields[1] as String,
      name: fields[2] as String,
      image: fields[3] as String,
      currentPrice: fields[4] as double,
      marketCap: fields[5] as double,
      marketCapRank: fields[6] as int,
      fullyDilutedValuation: fields[7] as double?,
      totalVolume: fields[8] as double,
      high24h: fields[9] as double,
      low24h: fields[10] as double,
      priceChange24h: fields[11] as double,
      priceChangePercentage24h: fields[12] as double,
      marketCapChange24h: fields[13] as double,
      marketCapChangePercentage24h: fields[14] as double,
      circulatingSupply: fields[15] as double,
      totalSupply: fields[16] as double,
      maxSupply: fields[17] as double?,
      ath: fields[18] as double,
      athChangePercentage: fields[19] as double,
      athDate: fields[20] as String,
      atl: fields[21] as double,
      atlChangePercentage: fields[22] as double,
      atlDate: fields[23] as String,
      roi: fields[24] as RoiModel?,
      lastUpdated: fields[25] as String,
      sparklineIn7d: fields[26] as SparklineModel?,
    );
  }

  @override
  void write(BinaryWriter writer, CoinModel obj) {
    writer
      ..writeByte(27)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.symbol)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.currentPrice)
      ..writeByte(5)
      ..write(obj.marketCap)
      ..writeByte(6)
      ..write(obj.marketCapRank)
      ..writeByte(7)
      ..write(obj.fullyDilutedValuation)
      ..writeByte(8)
      ..write(obj.totalVolume)
      ..writeByte(9)
      ..write(obj.high24h)
      ..writeByte(10)
      ..write(obj.low24h)
      ..writeByte(11)
      ..write(obj.priceChange24h)
      ..writeByte(12)
      ..write(obj.priceChangePercentage24h)
      ..writeByte(13)
      ..write(obj.marketCapChange24h)
      ..writeByte(14)
      ..write(obj.marketCapChangePercentage24h)
      ..writeByte(15)
      ..write(obj.circulatingSupply)
      ..writeByte(16)
      ..write(obj.totalSupply)
      ..writeByte(17)
      ..write(obj.maxSupply)
      ..writeByte(18)
      ..write(obj.ath)
      ..writeByte(19)
      ..write(obj.athChangePercentage)
      ..writeByte(20)
      ..write(obj.athDate)
      ..writeByte(21)
      ..write(obj.atl)
      ..writeByte(22)
      ..write(obj.atlChangePercentage)
      ..writeByte(23)
      ..write(obj.atlDate)
      ..writeByte(24)
      ..write(obj.roi)
      ..writeByte(25)
      ..write(obj.lastUpdated)
      ..writeByte(26)
      ..write(obj.sparklineIn7d);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoinModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RoiModelAdapter extends TypeAdapter<RoiModel> {
  @override
  final int typeId = 1;

  @override
  RoiModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoiModel(
      times: fields[0] as double,
      currency: fields[1] as String,
      percentage: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, RoiModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.times)
      ..writeByte(1)
      ..write(obj.currency)
      ..writeByte(2)
      ..write(obj.percentage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoiModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SparklineModelAdapter extends TypeAdapter<SparklineModel> {
  @override
  final int typeId = 2;

  @override
  SparklineModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SparklineModel(
      price: (fields[0] as List).cast<double>(),
    );
  }

  @override
  void write(BinaryWriter writer, SparklineModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SparklineModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
