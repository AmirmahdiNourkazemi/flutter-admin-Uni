class ApiExeption {
  int? code;
  String? message;
  ApiExeption(this.message, this.code);
    String getFarsiMessage() {
    switch (code) {
      case 404:
        return '!!ثبت نام نکرده اید';
      case 422:
        return '!!فردی با این مشخصات قبلا ثبت نام کرده است';
      case 400:
      return "!!کد وارد شده اشتباه است";
      case 413:
      return 'حجم فایل بیشتر از حد مجاز است';
      default:
        return '$code:$message';
    }
  }
}
  
