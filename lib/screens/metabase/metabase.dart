import 'dart:html';
import 'dart:ui' as ui;
import 'package:admin_smartfunding/bloc/metabase/metabase_event.dart';
import 'package:admin_smartfunding/constant/scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../bloc/metabase/metabase_bloc.dart';
import '../../bloc/metabase/metabase_state.dart';
import '../../utils/phosphor_icon.dart';
import '../home/home_screen.dart';

class MetabaseScreen extends StatefulWidget {
  final String url;
  const MetabaseScreen(this.url, {super.key});

  @override
  State<MetabaseScreen> createState() => _MetabaseScreenState();
}

class _MetabaseScreenState extends State<MetabaseScreen> {
  @override
  final IFrameElement _iFrameElement = IFrameElement();
  void initState() {
    // _iFrameElement.style.height = MediaQuery.of(context).size.height.toString();
    // _iFrameElement.style.width = '80%';
    _iFrameElement.src = widget.url;
    _iFrameElement.style.border = 'none';

// ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iFrameElement,
    );

    super.initState();
  }

  final Widget _iframeWidget = HtmlElementView(
    viewType: 'iframeElement',
    key: UniqueKey(),
  );
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'گزارش ها',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return BlocProvider(
                        create: (context) => MetabaseBloc(),
                        child: HomeScreen(),
                      );
                    },
                  ),
                );
              },
              icon: buildPhosphorIcon(PhosphorIconsBold.arrowLeft),
            ),
          ),
          body: ListView(
            scrollDirection: Axis.vertical,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: _iframeWidget)
            ],
          )),
    );
  }
}
