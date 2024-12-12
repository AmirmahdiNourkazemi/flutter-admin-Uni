import 'package:admin_smartfunding/bloc/usersBloc/pivot/pivot_bloc.dart';
import 'package:admin_smartfunding/bloc/usersBloc/pivot/pivot_event.dart';
import 'package:admin_smartfunding/bloc/usersBloc/pivot/pivot_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../data/model/profile/unit.dart';
import '../../responsive/responsive.dart';

import 'widget/my_assets.dart';

class MyAssets extends StatefulWidget {
  final List<Unit> _project;
  const MyAssets(this._project, {super.key});

  @override
  State<MyAssets> createState() => _MyAssetsState();
}

class _MyAssetsState extends State<MyAssets> {
  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'دارایی ها',
          style: TextStyle(
            fontSize: Responsive.isDesktop(context) ? 18 : 12,
            fontFamily: 'IR',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: PhosphorIcon(
              PhosphorIcons.arrowRight(),
            ),
          )
        ],
      ),
      body: SizedBox(
        //height: r.units!.length * 300,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: widget._project.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ShowAllAssetsWidget(widget._project[index]),
            );
          },
        ),
      ),
    );
  }
}
