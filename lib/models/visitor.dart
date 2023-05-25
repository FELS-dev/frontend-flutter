class Visitor {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? createdAt;
  final String? updatedAt;

  Visitor({ this.id, this.firstName, this.lastName, this.email, this.createdAt, this.updatedAt});

  factory Visitor.fromJson(Map<String, dynamic> json) {
    return Visitor(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Converts Visitor to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Converts Map to Visitor
  factory Visitor.fromMap(Map<String, dynamic> map) {
    return Visitor(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }
}

