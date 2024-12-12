import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/usersBloc/send_bulk_sms/send_bulk_sms_bloc.dart';
import '../../../bloc/usersBloc/send_bulk_sms/send_bulk_sms_event.dart';
import '../../../bloc/usersBloc/send_bulk_sms/send_bulk_sms_state.dart';

class SendBulkSms extends StatefulWidget {
  final String total;

  String? mobile;
  int? paid;
  int? completedProfile;
  int? notEmptyWallet;
  int? hasSellingTrade;
  String template;
  String projectUuid;

  SendBulkSms(
    this.mobile,
    this.paid,
    this.completedProfile,
    this.notEmptyWallet,
    this.hasSellingTrade,
    this.template,
    this.projectUuid, {
    Key? key,
    required this.total,
  }) : super(key: key);

  @override
  State<SendBulkSms> createState() => _SendBulkSmsState();
}

class _SendBulkSmsState extends State<SendBulkSms> {
  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<SendBulkSmsBloc>(context).add(SendBulkSmsStartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SendBulkSmsBloc, SendBulkSmsState>(
      listener: (context, state) {
        if (state is SendBulkRemindSmsState) {
          state.sendBulkRemind.fold(
            (l) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                showCloseIcon: true,
                closeIconColor: Colors.white,
                content: Text(
                  l,
                  style: const TextStyle(fontFamily: 'IR'),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
                backgroundColor: Colors.red,
              ),
            ),
            (r) async {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(r),
                  backgroundColor: Colors.red,
                ),
              );
              Navigator.of(context).pop();
            },
          );
        }
      },
      child: AlertDialog(
        title: Text(
          'از ارسال پیامک به ${widget.total} نفر موافق هستید ؟',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'اره',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              BlocProvider.of<SendBulkSmsBloc>(context).add(
                SendBulkSmsEventClick(
                  widget.mobile,
                  widget.paid,
                  widget.completedProfile,
                  widget.notEmptyWallet,
                  widget.hasSellingTrade,
                  widget.template,
                  widget.projectUuid,
                ),
              );
            },
          ),
          TextButton(
            child: const Text(
              'نه',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
