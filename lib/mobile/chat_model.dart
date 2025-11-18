import 'package:hive/hive.dart';

part 'chat_model.g.dart';

@HiveType(typeId: 3)
class ChartModel {
  @HiveField(0)
  final int? time;
  @HiveField(1)
  final double? open;
  @HiveField(2)
  final double? high;
  @HiveField(3)
  final double? low;
  @HiveField(4)
  final double? close;

  ChartModel({
    this.time,
    this.open,
    this.high,
    this.low,
    this.close,
  });

  factory ChartModel.fromJson(List<dynamic> json) {
    return ChartModel(
      time: json[0] as int?,
      open: (json[1] as num?)?.toDouble(),
      high: (json[2] as num?)?.toDouble(),
      low: (json[3] as num?)?.toDouble(),
      close: (json[4] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'open': open,
      'high': high,
      'low': low,
      'close': close,
    };
  }
}
