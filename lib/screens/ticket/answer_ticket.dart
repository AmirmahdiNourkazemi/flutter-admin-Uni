import 'package:admin_smartfunding/constant/scheme.dart';
import 'package:admin_smartfunding/screens/ticket/ticket_datalist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../../bloc/ticket/get_Ticket/ticket_bloc.dart';
import '../../../../bloc/ticket/get_Ticket/ticket_event.dart';
import '../../../../bloc/ticket/get_Ticket/ticket_state.dart';
import '../../../../data/model/ticket/ticket.dart';
import '../../../../data/model/ticket_uuid/get_ticket.dart';

class AnswerScreen extends StatefulWidget {
  final GetTicket _getTicket;
  AnswerScreen(this._getTicket, {super.key});

  @override
  State<AnswerScreen> createState() => _AnswerScreenState();
}

class _AnswerScreenState extends State<AnswerScreen> {
  TextEditingController _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int selectedChangeStatusValue = 1;
  bool isDroppDownPress = false;
  @override
  void initState() {
    // TODO: implement initState
    // BlocProvider.of<SendTicketBloc>(context).add(SendTicketStartEvent());
    BlocProvider.of<TicketBloc>(context)
        .add(GetTicketEvent(widget._getTicket.uuid));
  }

  List<DropdownMenuItem<int>> get dropdownChangeStatusItems {
    List<DropdownMenuItem<int>> menuItems = [
      DropdownMenuItem(
          child: Text(
            "جدید".toPersianDigit(),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          value: 1),
      DropdownMenuItem(
          child: Text("پاسخ داده شده".toPersianDigit(),
              style: Theme.of(context).textTheme.titleSmall),
          value: 2),
      DropdownMenuItem(
          child: Text("بسته".toPersianDigit(),
              style: Theme.of(context).textTheme.titleSmall),
          value: 3),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TicketBloc, TicketState>(
      listener: (context, state) {
        if (state is CreateMessageResponseState) {
          state.response.fold(
            (l) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                showCloseIcon: true,
                closeIconColor: Colors.white,
                content: Text(
                  l,
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
                backgroundColor: Colors.red,
              ),
            ),
            (r) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  showCloseIcon: true,
                  closeIconColor: Colors.white,
                  content: Text(
                    r,
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                  backgroundColor: Colors.green[700],
                ),
              );
              _textController.clear();
              //Navigator.pop(context);
            },
          );
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (didPop) return;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) {
                          final TicketBloc bloc = TicketBloc();
                          bloc.add(TicketStartEvent());
                          return bloc;
                        },
                      ),
                    ],
                    child: const TicketDatalist(),
                  );
                },
              ),
            );
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) {
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (context) {
                                  final TicketBloc bloc = TicketBloc();
                                  bloc.add(TicketStartEvent());
                                  return bloc;
                                },
                              ),
                              //  BlocProvider(
                              //     create: (context) {
                              //       final SendTicketBloc bloc = SendTicketBloc();
                              //       bloc.add(TicketStartEvent());
                              //       return bloc;
                              //     },
                              //   ),
                            ],
                            child: const TicketDatalist(),
                          );
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_back)),
              title: Text(
                'چت تیکت',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            body: Column(
              children: [
                BlocBuilder<TicketBloc, TicketState>(
                  builder: (context, state) {
                    return Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('تغییر وضعیت :',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              isDroppDownPress = true;
                                              setState(() {
                                                isDroppDownPress = true;
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: AppColorScheme
                                                        .primaryColor),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: DropdownButton(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 5,
                                                ),
                                                iconEnabledColor: Colors.white,
                                                items:
                                                    dropdownChangeStatusItems,
                                                hint: widget._getTicket
                                                            .status ==
                                                        1
                                                    ? Text('جدید',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall)
                                                    : widget._getTicket
                                                                .status ==
                                                            2
                                                        ? Text('پاسخ داده شده',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleSmall)
                                                        : Text('بسته شده',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleSmall),
                                                focusColor: Colors.blueAccent,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                                onChanged: (int? newValue) {
                                                  //  selectedValue = newValue!;
                                                  selectedChangeStatusValue =
                                                      newValue!;
                                                  setState(() {
                                                    isDroppDownPress = true;
                                                    selectedChangeStatusValue =
                                                        newValue;
                                                  });
                                                },
                                                value: isDroppDownPress
                                                    ? selectedChangeStatusValue
                                                    : widget._getTicket.status,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Row(
                                          children: [
                                            const Icon(Icons.person),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            Text(
                                              widget._getTicket.user.name!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
                                            )
                                          ],
                                        ),
                                        trailing: Text(
                                          widget._getTicket.createdAt
                                              .toPersianDate(),
                                          style: const TextStyle(fontSize: 8),
                                        ),
                                      ),
                                      Text(
                                        ' موضوع:${widget._getTicket.title}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        ' توضیحات:${widget._getTicket.description}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (state is GetTicketLoadingState) ...{
                            const SliverToBoxAdapter(
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColorScheme.primaryColor,
                                ),
                              ),
                            )
                          } else ...{
                            if (state is GetTicketResponseState) ...{
                              state.getTicket.fold(
                                (l) {
                                  return SliverToBoxAdapter(
                                    child: Text(l),
                                  );
                                },
                                (ticket) {
                                  return SliverPadding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 0),
                                    sliver: SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                          final message =
                                              ticket.messages![index];

                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            child: Container(
                                              width: 100,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 2,
                                                    blurRadius: 5,
                                                    offset: const Offset(0, 3),
                                                  ),
                                                ],
                                                borderRadius: BorderRadius.only(
                                                  topRight: message
                                                              .user.isAdmin ==
                                                          true
                                                      ? const Radius.circular(0)
                                                      : const Radius.circular(
                                                          10),
                                                  topLeft: message
                                                              .user.isAdmin ==
                                                          true
                                                      ? const Radius.circular(
                                                          10)
                                                      : const Radius.circular(
                                                          0),
                                                  bottomLeft:
                                                      const Radius.circular(10),
                                                  bottomRight:
                                                      const Radius.circular(10),
                                                ),
                                                color:
                                                    message.user.isAdmin == true
                                                        ? Colors.blue.shade100
                                                        : Colors.white,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ListTile(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      title: Row(
                                                        children: [
                                                          const Icon(
                                                              Icons.person),
                                                          const SizedBox(
                                                            width: 3,
                                                          ),
                                                          Text(
                                                            message.user.name!,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      trailing: Text(
                                                        message.createdAt
                                                            .toPersianDate(),
                                                        style: const TextStyle(
                                                            fontSize: 8),
                                                      ),
                                                    ),
                                                    Text(
                                                      ' پیام:${message.text}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall,
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        childCount: ticket.messages!.length,
                                      ),
                                    ),
                                  );
                                },
                              )
                            }
                          },
                          // SliverPadding(
                          //   padding:
                          //       EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                          //   sliver:,
                          // )
                        ],
                      ),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Form(
                    //autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: SizedBox(
                              //width: MediaQuery.of(context).size.width * 0.8,

                              child: TextFormField(
                                controller: _textController,
                                maxLines: null,
                                style: const TextStyle(height: 0.6),
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 1),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  labelText: 'پیام',
                                  labelStyle: const TextStyle(
                                    fontSize: 12,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.blue,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'لطفا متن پیام را پر کنید';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: BlocBuilder<TicketBloc, TicketState>(
                              builder: (context, state) {
                                if (state is GetTicketLoadingState) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColorScheme.primaryColor,
                                    ),
                                  );
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 3),
                                    child: Container(
                                      //height: 100,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey.shade100,
                                        // border: Border.all(
                                        //     color: Colors.blue, width: 0.5),
                                      ),
                                      child: Center(
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          tooltip: 'ارسال',
                                          onPressed: () {
                                            final status = isDroppDownPress
                                                ? selectedChangeStatusValue
                                                : 2;
                                            if (_formKey.currentState!
                                                .validate()) {
                                              BlocProvider.of<TicketBloc>(
                                                      context)
                                                  .add(
                                                CreateMessageClickedEvent(
                                                    widget._getTicket.uuid,
                                                    _textController.text,
                                                    status),
                                              );
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.send_rounded,
                                            size: 34,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
