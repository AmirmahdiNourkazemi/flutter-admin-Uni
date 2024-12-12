import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../data/model/profile/trade.dart';
import '../../../data/model/profile/transaction.dart';

Widget FactorAlertDialoadContainer(List<Transaction> trade) {
  return SizedBox(
    height: trade.length * 150, // Change as per your requirement
    width: 300.0, // Change as per your requirement
    child: ListView.builder(
      itemCount: trade.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return SizedBox(
          height: 150,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (trade[index].type == 1) ...{
                    const Text(
                      'خرید',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'IR',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  },
                  if (trade[index].type == 2) ...{
                    const Text(
                      'فروش',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'IR',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  }
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'تومان',
                        style: TextStyle(fontSize: 9, fontFamily: 'IR'),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        trade[index]
                            .amount
                            .toString()
                            .toPersianDigit()
                            .seRagham(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'IR',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trade[index].type == 2
                      ? const Text(
                          'مبلغ بازگشتی',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'IR'),
                        )
                      : const Text(
                          'مبلغ پرداختی',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'IR'),
                        ),
                ],
              ),
              const SizedBox(
                height: 15,
                child: Divider(
                  color: Colors.black12,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    trade[index].createdAt!.toPersianDate(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'IR',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trade[index].type == 1
                      ? const Text(
                          'تاریخ خرید',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const Text(
                          'تاریخ فروش',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                ],
              ),
              const SizedBox(
                height: 15,
                child: Divider(
                  color: Colors.black12,
                ),
              ),
              if (trade[index].traceCode != null)
                InkWell(
                  onTap: () {

                    Clipboard.setData(

                      ClipboardData(
                        text: trade[index].traceCode.toString(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100,
                        height: 25,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(3),
                          ),
                        ),
                        child: Text(trade[index].traceCode.toString()),
                      ),
                      const Text(
                        'کد رهگیری',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              const SizedBox(
                height: 15,
                child: Divider(
                  color: Colors.black12,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 100,
                    height: 25,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(3),
                        ),
                        color: trade[index].type == 2
                            ? Colors.red
                            : Colors.green[500]),
                    child: Center(
                      child: Text(
                        trade[index].type == 1
                            ? 'خرید'
                            : trade[index].type == 2
                                ? 'فروش'
                                : 'تحویل داده شد',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const Text(
                    'وضعیت',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}
