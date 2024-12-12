class Address {
   int? id;
   int? userId;
   String? country;
   String? province;
   String? city;
   String? street;
   String? alley;
   String? plaque;
   String? postalCode;
   String? phone;
   String? createdAt;
   String? updatedAt;

  Address({
     this.id,
     this.userId,
     this.country,
     this.province,
     this.city,
     this.street,
     this.alley,
     this.plaque,
     this.postalCode,
     this.phone,
     this.createdAt,
     this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      userId: json['user_id'],
      country: json['country'],
      province: json['province'],
      city: json['city'],
      street: json['street'],
      alley: json['alley'],
      plaque: json['plaque'],
      postalCode: json['postal_code'],
      phone: json['phone'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}