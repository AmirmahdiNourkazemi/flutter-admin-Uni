import 'package:admin_smartfunding/data/model/company/company.dart';

class RootCompany { 
List<Company>? data;

RootCompany({
  this.data
});

 factory RootCompany.fromJson(List<dynamic> json) {
  List<Company> companies = json.map((companies) => Company.fromJson(companies)).toList();
    return RootCompany(
      data: companies,
    );
  }
}


