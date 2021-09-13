import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:r_launcher/main.dart';
import 'package:r_launcher/models/settings.model.dart';
import 'package:r_launcher/providers/providers.dart';
import 'package:r_launcher/services/shared.service.dart';
import 'package:r_launcher/utils/defaullt.utils.dart';

class BaseView extends StatefulWidget {
  const BaseView({Key key}) : super(key: key);

  @override
  _BaseViewState createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView>
    with AutomaticKeepAliveClientMixin {
  PageController _pageController;

  @override
  void initState() {
    _getPageToShow();
    _init();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _init() async {
    Settings settings = await SharedService.getSettings();
    navigatorKey.currentContext
        .read(Providers.settingsProvider)
        .setInit(settings);
    navigatorKey.currentContext
        .read(Providers.appProvider)
        .handleAppInstallOrUninstall();
  }

  void _getPageToShow() async {
    List<Widget> tabs =
        navigatorKey.currentContext.read(Providers.baseProvider).defaultTabs;
    int noOfTabsToCreate = await SharedService.getNoOfTabs();

    if (noOfTabsToCreate == 2) {
      // int initTabIndex = await SharedService.getIndexCurrentTab();
      Constants.initialTabs.forEach((element) {
        tabs.add(element);
      });
      navigatorKey.currentContext.read(Providers.baseProvider).setTabIndex(0);
      _pageController = PageController(initialPage: 0);

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: Container(
          child: Consumer(builder: (context, watch, child) {
            final baseProvider = watch(Providers.baseProvider);
            final settingsProvider = watch(Providers.settingsProvider);
            return PageView.builder(
              physics: ClampingScrollPhysics(),
              scrollDirection: settingsProvider.swipeHome == "false"
                  ? Axis.horizontal
                  : Axis.vertical,
              controller: _pageController,
              onPageChanged: (index) {
                baseProvider.setTabIndex(index);
              },
              itemCount: baseProvider.defaultTabs.length,
              itemBuilder: (context, index) {
                return baseProvider.defaultTabs[index];
              },
            );
          }),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
