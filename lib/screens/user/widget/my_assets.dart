import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/model/profile/trade.dart';
import '../../../data/model/profile/transaction.dart';
import '../../../data/model/profile/unit.dart';
import '../../../responsive/responsive.dart';
import 'factor_dilaog.dart';
import 'dart:html' as html;

class ShowAllAssetsWidget extends StatefulWidget {
  Unit _unit;
  ShowAllAssetsWidget(this._unit, {super.key});

  @override
  State<ShowAllAssetsWidget> createState() => _ShowAllAssetsWidgetState();
}

class _ShowAllAssetsWidgetState extends State<ShowAllAssetsWidget> {
  bool isPressContainer = false;
  @override
  void initState() {

  }

  String? certificateUrl;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration:
          const Duration(milliseconds: 300), // Adjust the duration as needed
      curve: Curves.easeInCirc, // Adjust the curve as needed
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black12)),
      width: MediaQuery.of(context).size.width,
      height: 220,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: GestureDetector(
          onTap: () {
            setState(() {
              isPressContainer = !isPressContainer;
            });
          },
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (widget._unit.title != null) ...{
                    Text(
                      widget._unit.title!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  }
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 60,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueAccent),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'تراکنش',
                          style: TextStyle(
                              fontSize: 8,
                              color: Colors.white,
                              fontFamily: 'IR'),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          widget._unit.transactions.length
                              .toString()
                              .toPersianDigit(),
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontFamily: 'IR'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 7,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'تومان',
                                  style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.black38,
                                      fontFamily: 'IR'),
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  widget._unit.pivot.amount
                                      .toString()
                                      .toPersianDigit()
                                      .seRagham(),
                                  style: TextStyle(
                                    fontSize:
                                        Responsive.isDesktop(context) ? 14 : 11,
                                    fontFamily: 'IR',
                                    color: Colors.black38,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'مبلغ سرمایه گذاری',
                              style: TextStyle(
                                fontSize:
                                    Responsive.isDesktop(context) ? 14 : 11,
                                color: Colors.black38,
                                fontFamily: 'IR',
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                          child: Divider(
                            color: Colors.black12,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget._unit.pivot.createdAt.toPersianDate(),
                                  style: TextStyle(
                                    fontSize:
                                        Responsive.isDesktop(context) ? 14 : 11,
                                    color: Colors.black38,
                                    fontFamily: 'IR',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'تاریخ خرید اول',
                              style: TextStyle(
                                fontSize:
                                    Responsive.isDesktop(context) ? 14 : 11,
                                color: Colors.black38,
                                fontFamily: 'IR',
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                          child: Divider(
                            color: Colors.black12,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget._unit.pivot.updatedAt.toPersianDate(),
                              style: TextStyle(
                                fontSize:
                                    Responsive.isDesktop(context) ? 14 : 11,
                                color: Colors.black38,
                                fontFamily: 'IR',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'تاریخ بروزرسانی',
                              style: TextStyle(
                                  fontSize:
                                      Responsive.isDesktop(context) ? 14 : 11,
                                  color: Colors.black38,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'IR'),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {
                                  if (widget._unit.transactions.isNotEmpty) {
                                    _showCustomBottomSheet(
                                        widget._unit.transactions, context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "!!فاکتوری موجود نیست",
                                          style: TextStyle(
                                            fontFamily: 'IR',
                                            fontSize:
                                                Responsive.isDesktop(context)
                                                    ? 14
                                                    : 11,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                        showCloseIcon: true,
                                        closeIconColor: Colors.white,
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  'مشاهده فاکتور',
                                  style: TextStyle(
                                    fontFamily: 'IR',
                                    fontSize:
                                        Responsive.isDesktop(context) ? 14 : 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                            const SizedBox(
                              width: 5,
                            ),
                            // BlocListener<CertificateBloc, CertificateState>(
                            //   listener: (context, state) {
                            //     if (state is CertificateResponseState) {
                            //       state.getCertificate.fold(
                            //         (l) => ScaffoldMessenger.of(context)
                            //             .showSnackBar(
                            //           SnackBar(
                            //             showCloseIcon: true,
                            //             closeIconColor: Colors.white,
                            //             content: Text(
                            //               l,
                            //               style: TextStyle(
                            //                   fontSize:
                            //                       Responsive.isDesktop(context)
                            //                           ? 12.0
                            //                           : 10.0,
                            //                   fontFamily: 'IR',
                            //                   color: Colors.white,
                            //                   fontWeight: FontWeight.w700),
                            //               textAlign: TextAlign.right,
                            //               textDirection: TextDirection.rtl,
                            //             ),
                            //             backgroundColor: Colors.red,
                            //           ),
                            //         ),
                            //         (url) async {
                            //           // setState(() {
                            //           //   certificateUrl = url;
                            //           // });
                            //           html.window.open(
                            //             url,
                            //             "_blank",
                            //           );
                            //         },
                            //       );
                            //     }
                            //   },
                            //   child: BlocBuilder<CertificateBloc,
                            //       CertificateState>(
                            //     builder: (context, state) {
                            //       if (state is CertificateLoadingState) {
                            //         return TextButton(
                            //             onPressed: () {
                            //               BlocProvider.of<CertificateBloc>(
                            //                       context)
                            //                   .add(CertificateButtonClikedEvent(
                            //                       widget._unit.uuid!));
                            //             },
                            //             child: Row(
                            //               children: [
                            //                 const CircularProgressIndicator(),
                            //                 const SizedBox(
                            //                   width: 6,
                            //                 ),
                            //                 Text(
                            //                   'در حال آماده سازی',
                            //                   style: TextStyle(
                            //                     fontFamily: 'IR',
                            //                     fontSize: Responsive.isDesktop(
                            //                             context)
                            //                         ? 14
                            //                         : 11,
                            //                     fontWeight: FontWeight.bold,
                            //                   ),
                            //                 ),
                            //               ],
                            //             ));
                            //       } else {
                            //         return TextButton(
                            //           onPressed: () {
                            //             BlocProvider.of<CertificateBloc>(
                            //                     context)
                            //                 .add(CertificateButtonClikedEvent(
                            //               widget._unit.uuid!,
                            //             ));
                            //           },
                            //           child: Text(
                            //             'مشاهده گواهی',
                            //             style: TextStyle(
                            //               fontFamily: 'IR',
                            //               fontSize:
                            //                   Responsive.isDesktop(context)
                            //                       ? 14
                            //                       : 11,
                            //               fontWeight: FontWeight.bold,
                            //             ),
                            //           ),
                            //         );
                            //       }
                            //     },
                            //   ),
                            // )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// String profitForUnits(int area, int pricePerMeter, int amount) {
//   var res = amount - (area * pricePerMeter);
//   return res.toString().toPersianDigit();
// }
Future<void> _showCustomBottomSheet(
    List<Transaction> trade, BuildContext context) async {
  // Display the bottom sheet.
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    //isScrollControlled: true, // Use this to make the bottom sheet full-screen
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.75,
        child: Container(
          // height: 250,
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.only(top: 10, bottom: 0),
            child: FactorAlertDialoadContainer(trade),
          ),
        ),
      );
    },
  );
}

// Future<void> _showCustomDialog(List<Trade> _trade, BuildContext context) async {
//   //Transaction transaction;
//   return showDialog<void>(
//     context: context,
//     barrierDismissible: true, // User must tap button!
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text(
//           'لیست پرداخت ها',
//           style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//           textAlign: TextAlign.center,
//         ),
//         content: Container(
//             // height: transaction.length * 150,
//             child: FactorAlertDialoadContainer(_trade)),
//         actions: <Widget>[
//           TextButton(
//             child: const Text(
//               'فهمیدم',
//               style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
//             ),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
