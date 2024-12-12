abstract class CheckLoginEvent {}

class CheckLoginInitEvent extends CheckLoginEvent{}

class CheckLoginButtonClick extends CheckLoginEvent{
  String mobileNumber;
  String nationalCode;
  CheckLoginButtonClick(this.mobileNumber,this.nationalCode);
}

class CheckLogoutButtonClick extends CheckLoginEvent{
  CheckLogoutButtonClick();
}