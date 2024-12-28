import 'dart:convert';

BusScanModel busScanModelFromJson(String str) =>
    BusScanModel.fromJson(json.decode(str));

String busScanModelToJson(BusScanModel data) => json.encode(data.toJson());

class BusScanModel {
  final bool success;
  final String busId;
  final String dailyColor;

  BusScanModel({
    required this.success,
    required this.busId,
    required this.dailyColor,
  });

  factory BusScanModel.fromJson(Map<String, dynamic> json) => BusScanModel(
        success: json["success"],
        busId: json["bus_id"],
        dailyColor: json["daily_color"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "bus_id": busId,
        "daily_color": dailyColor,
      };
}
