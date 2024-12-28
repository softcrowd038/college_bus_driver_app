import 'dart:convert';

BusDetails busDetailsFromJson(String str) =>
    BusDetails.fromJson(json.decode(str));

String busDetailsToJson(BusDetails data) => json.encode(data.toJson());

class BusDetails {
  final int busId;
  final String busName;
  final String qrCode;
  final int totalSeats;
  final String busDriver;
  final String driverContact;
  final String busRemark;
  final int routeId;
  final String routeName;
  final String startingPoint;
  final String endingPoint;
  final String distance;
  final String routeRemarks;
  final String stopNames;
  final String studentNames;
  final String studentClasses;

  BusDetails({
    required this.busId,
    required this.busName,
    required this.qrCode,
    required this.totalSeats,
    required this.busDriver,
    required this.driverContact,
    required this.busRemark,
    required this.routeId,
    required this.routeName,
    required this.startingPoint,
    required this.endingPoint,
    required this.distance,
    required this.routeRemarks,
    required this.stopNames,
    required this.studentNames,
    required this.studentClasses,
  });

  factory BusDetails.fromJson(Map<String, dynamic> json) => BusDetails(
        busId: json["bus_id"],
        busName: json["bus_name"],
        qrCode: json["qr_code"],
        totalSeats: json["total_seats"],
        busDriver: json["bus_driver"],
        driverContact: json["driver_contact"],
        busRemark: json["bus_remark"],
        routeId: json["route_id"],
        routeName: json["route_name"],
        startingPoint: json["starting_point"],
        endingPoint: json["ending_point"],
        distance: json["distance"],
        routeRemarks: json["route_remarks"],
        stopNames: json["stop_names"],
        studentNames: json["student_names"],
        studentClasses: json["student_classes"],
      );

  Map<String, dynamic> toJson() => {
        "bus_id": busId,
        "bus_name": busName,
        "qr_code": qrCode,
        "total_seats": totalSeats,
        "bus_driver": busDriver,
        "driver_contact": driverContact,
        "bus_remark": busRemark,
        "route_id": routeId,
        "route_name": routeName,
        "starting_point": startingPoint,
        "ending_point": endingPoint,
        "distance": distance,
        "route_remarks": routeRemarks,
        "stop_names": stopNames,
        "student_names": studentNames,
        "student_classes": studentClasses,
      };
}
