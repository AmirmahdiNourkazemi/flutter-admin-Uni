import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

abstract class IMetaBaseDatasource {
  Future<String> getMetabase();
}

class MetaBaseDatasource extends IMetaBaseDatasource {
  @override
  Future<String> getMetabase() async{
    var METABASE_SITE_URL = "https://bi.smartfunding.ir";
    var METABASE_SECRET_KEY =
        "eafa0ed83e355b219d32f43fdd499205e96d9448ce24f30a6644353838d12290";
    final jwt = JWT(
      // Payload
       {
    "resource": {"dashboard": 1},
    "params": {},
    "exp": DateTime.now().add(Duration(minutes: 10)).millisecondsSinceEpoch ~/ 1000 // 10 minute expiration
  },
    );

    final token = jwt.sign(SecretKey(METABASE_SECRET_KEY));
     print('Signed token: $token\n');
return METABASE_SITE_URL + "/embed/dashboard/" + token + "#bordered=true&titled=true";
   
  }
}
