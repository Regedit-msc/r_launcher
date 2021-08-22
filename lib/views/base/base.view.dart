import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:r_launcher/main.dart';
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
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _getPageToShow() async {
    List<Widget> tabs =
        navigatorKey.currentContext.read(Providers.baseProvider).defaultTabs;
    int noOfTabsToCreate = await SharedService.getNoOfTabs();
    if (noOfTabsToCreate == 2) {
      int initTabIndex = await SharedService.getIndexCurrentTab();
      Constants.initialTabs.forEach((element) {
        tabs.add(element);
      });
      navigatorKey.currentContext
          .read(Providers.baseProvider)
          .setTabIndex(initTabIndex);
      _pageController = PageController(initialPage: initTabIndex);

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: Container(
          child: Consumer(builder: (context, watch, child) {
            final baseProvider = watch(Providers.baseProvider);
            return PageView.builder(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
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
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
