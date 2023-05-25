class DigitalPass {
  final int id;
  final int? visitorId;
  final String? qrCode;

  DigitalPass({required this.id, this.visitorId, this.qrCode});

  factory DigitalPass.fromJson(Map<String, dynamic> json) {
    return DigitalPass(
      id: json['id'],
      visitorId: json['visitor_id'],
      qrCode: json['qr_code'],
    );
  }
}