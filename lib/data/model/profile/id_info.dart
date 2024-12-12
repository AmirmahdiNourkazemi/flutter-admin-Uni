class IdInfo {
    int? id;
    int? userId;
    String? idCode;
    String? idSeriCh;
    String? idSeriNum;
    String? idSerial;
    String? createdAt;
    String? updatedAt;

  IdInfo({
       this.id,
       this.userId,
       this.idCode,
       this.idSeriCh,
       this.idSeriNum,
       this.idSerial,
       this.createdAt,
       this.updatedAt,
  });

  factory IdInfo.fromJson(Map<String, dynamic> json) {
    return IdInfo(
      id: json['id'],
      userId: json['user_id'],
      idCode: json['id_code'],
      idSeriCh: json['id_seri_ch'],
      idSeriNum: json['id_seri_num'],
      idSerial: json['id_serial'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}