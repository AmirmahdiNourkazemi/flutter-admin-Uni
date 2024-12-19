import 'package:admin_smartfunding/bloc/company/company_bloc.dart';
import 'package:admin_smartfunding/bloc/company/company_event.dart';
import 'package:admin_smartfunding/bloc/company/company_state.dart';
import 'package:admin_smartfunding/bloc/metabase/metabase_bloc.dart';
import 'package:admin_smartfunding/data/model/company/company.dart';
import 'package:admin_smartfunding/data/model/company/root_company.dart';
import 'package:admin_smartfunding/responsive/responsive.dart';
import 'package:admin_smartfunding/screens/home/home_screen.dart';
import 'package:admin_smartfunding/utils/phosphor_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  @override
  void initState() {
    // TODO: implement initState
    // BlocProvider.of<CompanyBloc>(context).add(CompanyStartEvent());
    super.initState();
  }

  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'متقاضی های سرمایه',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) {
                    return BlocProvider(
                      create: (context) => MetabaseBloc(),
                      child: const HomeScreen(),
                    );
                  },
                ),
              );
            },
            icon: buildPhosphorIcon(
                PhosphorIcons.arrowLeft(PhosphorIconsStyle.regular),
                size: 28),
          ),
        ),
        body: ListView(
          children: [
            BlocBuilder<CompanyBloc, CompanyState>(builder: (context, state) {
              if (state is CompanyLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (state is CompanyResponseState) {
                  return state.getCompany.fold((l) => Center(child: Text(l)),
                      (rootCompany) {
                    return SingleChildScrollView(
                      scrollDirection: Responsive.isDesktop(context)
                          ? Axis.vertical
                          : Axis.horizontal,
                      child: DataTable(
                        dataTextStyle: Theme.of(context).textTheme.titleSmall,
                        headingTextStyle:
                            Theme.of(context).textTheme.titleMedium,
                        columnSpacing: 20,
                        showBottomBorder: true,
                        columns: const [
                          DataColumn(label: Text('نام شرکت')),
                          DataColumn(label: Text('توضیحات')),
                          DataColumn(label: Text('تاریخ ارسال')),
                          DataColumn(label: Text('نام نماینده')),
                          DataColumn(label: Text('زمینه فعالیت')),
                          DataColumn(label: Text('شماره موبایل')),
                          DataColumn(label: Text('سرمایه مورد نیاز')),
                          DataColumn(label: Text('درآمد سالیانه')),
                          DataColumn(
                              label:
                                  Text('وضعیت سود و زیان شرکت در سال گذشته')),
                          DataColumn(
                              label: Text(
                                  'وضعیت چک برگشتی سرمایه‌پذیر و اعضای هیئت مدیره')),
                        ],
                        rows: rootCompany.map((company) {
                          return DataRow(cells: [
                            DataCell(Text(company.title)),
                            DataCell(
                                Text(company.description ?? 'بدون توضیحات')),
                            DataCell(Text(company.createdAt.toPersianDate())),
                            DataCell(Text(company.agentName)),
                            DataCell(Text(company.field)),
                            DataCell(
                                Text(company.phoneNumber.toPersianDigit())),
                            DataCell(Text(company.fundNeeded.description)),
                            DataCell(Text(company.annualIncome.description)),
                            DataCell(Text(company.profit.description)),
                            DataCell(Text(company.bouncedCheck.description)),
                          ]);
                        }).toList(),
                      ),
                    );
                  });
                }
                return Container();
              }
            })
          ],
        ),
      ),
    );
  }
}
