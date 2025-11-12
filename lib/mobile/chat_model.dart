class ChartModel {
  final int? time;
  final double? open, high, low, close;

  ChartModel({this.time, this.open, this.high, this.low, this.close});

  factory ChartModel.fromJson(List<dynamic> json) {
    return ChartModel(
      time: json[0] as int?,
      open: (json[1] as num?)?.toDouble(),
      high: (json[2] as num?)?.toDouble(),
      low: (json[3] as num?)?.toDouble(),
      close: (json[4] as num?)?.toDouble(),
    );
  }
}
