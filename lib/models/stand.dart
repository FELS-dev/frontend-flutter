class Stand {
  int id;
  String? name;
  String? description;
  double? locationX;
  double? locationY;
  String? qrCode;
  // List<TreasureHunt> ?treasureHunts;
  // Stand({required this.id, this.name, this.description, this.locationX, this.locationY, this.qrCode,this.treasureHunts = const []});
  Stand(
      {required this.id,
      this.name,
      this.description,
      this.locationX,
      this.locationY,
      this.qrCode});

  factory Stand.fromJson(Map<String, dynamic> json) {
    return Stand(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      locationX: json['location_x'],
      locationY: json['location_y'],
      qrCode: json['qr_code'],
      // treasureHunts: (json['treasure_hunts'] as List).map((i) => TreasureHunt.fromJson(i)).toList()
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location_x': locationX,
      'location_y': locationY,
      'qr_code': qrCode,
      // 'treasure_hunts': json.encode(treasureHunts?.map((i) => i.toJson()).toList())
    };
  }
}
