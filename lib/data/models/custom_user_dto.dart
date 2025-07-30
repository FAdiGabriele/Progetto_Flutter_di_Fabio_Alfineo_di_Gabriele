class CustomUserDTO {
  final String? id;
  final String name;
  final String email;
  final int food_quantity;

  CustomUserDTO({
    this.id,
    required this.name,
    required this.email,
    required this.food_quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'food_quantity': food_quantity,
    };
  }

  factory CustomUserDTO.fromMap(Map<String, dynamic> map, String? id) {
    return CustomUserDTO(
      id: id,
      name: map['name'] is String ? map['name'] : '',
      email: map['email'] is String ? map['email'] : '',
      food_quantity: map['food_quantity'] is int ? map['food_quantity'] : 0,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomUserDTO &&
        runtimeType == other.runtimeType &&
        id == other.id &&
        name == other.name &&
        email == other.email &&
        food_quantity == other.food_quantity;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      name,
      email,
      food_quantity,
    );
  }
}
