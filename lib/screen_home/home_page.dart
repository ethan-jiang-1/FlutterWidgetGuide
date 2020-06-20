//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_guide/bloc/list_bloc.dart';
import 'package:flutter_widget_guide/model/list_Item.dart';
import 'package:flutter_widget_guide/utils.dart';
import 'package:flutter_widget_guide/widgets/home_list_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Ads.dart';
import '../profile_screen.dart';

import 'package:flutter_widget_guide/screens/WebViewWidget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

/// WidgetsBindingObserver helps to keep track of the app lifecycle state
class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  BuildContext _buildContext;
  var versionNumber;
  bool isFabVisible = true;
  bool hasJoinedSlack = false;
  ScrollController _hideButtonController;
  bool isCheckBoxChecked = false;
  String appLink =
      "https://play.google.com/store/apps/details?id=com.annsh.flutterwidgetguide";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //FirebaseMessaging _fcm;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //print("The state is $state");
    /// do something here to release FCM instance so that it doesn't configure
    /// again when user comes back to the app from Recent Apps
    /// Nothing can be done as of now.
    /// Link to the issue:
    /// https://github.com/FirebaseExtended/flutterfire/issues/1060
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    //Dispose the Ad if it isn't already
    Ads.hideBannerAd();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //Initialize Firebase Admob
    Ads.initialize();
    //_fcm = FirebaseMessaging();
    Utils.getVersion().then((value) {
      versionNumber = value;
    });
    setupRemoteConfig();
    _getValueFromSP();
    isFabVisible = true;
    _hideButtonController = new ScrollController();
    _hideButtonController.addListener(
      () {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (isFabVisible == true) {
            setState(() => isFabVisible = false);
          }
        } else {
          if (_hideButtonController.position.userScrollDirection ==
              ScrollDirection.forward) {
            if (isFabVisible == false) {
              setState(() => isFabVisible = true);
            }
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    return homePageScaffold(context);
  }

  Widget extraUiButton(context, text, route) {
    return OutlineButton(
        child: Text(text),
        onPressed: () => {
          //Utils.launchURL("${Utils.slack_invite}")
          Navigator.pushNamed(context, route)

          }, 
        borderSide: BorderSide(color: Colors.blue),
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(30.0))
    );
  }                

  void _bringExtraUiEffect(context) {
    showDialog(
      context: context,

      /// StatefulBuilder is used here to make setState work on AlertDialog
      /// For checkbox state functionality
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Center(
              child: Text(
                "Extra UI effects",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: Utils.ubuntuRegularFont),
              ),
            ),
            content: 
              SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  extraUiButton(context, "draw_challenge_demo1",  Utils.extra_dc_main),
                  //extraUiButton(context, "draw_challenge_demo1",  Utils.extra_dc_demo1),
                  extraUiButton(context, "draw_challenge_demo2",  Utils.extra_dc_demo2),
                  extraUiButton(context, "buy_ticket_design_demo",  Utils.extra_btd_main),
                  extraUiButton(context, "go_to_egypt_demo",  Utils.extra_gte_main),
                  extraUiButton(context, "flight_survey_demo",  Utils.extra_fs_main),
                  extraUiButton(context, "flare_flutter_teddy_demo",  Utils.extra_fft_main),
                  extraUiButton(context, "radial_menu_demo",  Utils.extra_rm_main),
                  extraUiButton(context, "liquid_swipe_demo",  Utils.extra_ls_main),
                  extraUiButton(context, "covid_19_demo",  Utils.extra_c19_main),
                  extraUiButton(context, "adidas_shoes_demo",  Utils.extra_ads_main),
                ],
              ),
            )
          );
        },
      ),
    );
  }

  Widget homePageScaffold(BuildContext context) => Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.transparent,
        ),
        child: WillPopScope(
          child: Scaffold(
            key: _scaffoldKey,
            body: sliverWidgetList(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Visibility(
              visible: isFabVisible && !hasJoinedSlack,
              child: FloatingActionButton.extended(
                backgroundColor: Color(0xFFffffff),
                icon: Container(
                  height: 24,
                  width: 24,
                  child: SvgPicture.asset(
                    Utils.slack_img,
                    semanticsLabel: "Join Slack",
                  ),
                ),
                label: Text(
                  "Extra UI effects",
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: Utils.ubuntuRegularFont),
                ),
                onPressed: () => {
                  _bringExtraUiEffect(context),
                },
              ),
            ),
          ),
          onWillPop: _willPopCallback,
        ),
      );

  Widget sliverWidgetList() {
    ListBloc listBloc = ListBloc();
    return StreamBuilder<List<ListItem>>(
        stream: listBloc.listItems,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? CustomScrollView(
                  controller: _hideButtonController,
                  //This is to contain Sliver Elements
                  slivers: <Widget>[
                    appBar(context),
                    SliverPadding(
                      padding: EdgeInsets.all(4.0),
                    ),
                    SliverPadding(
                      sliver: bodyList(snapshot.data),
                      padding: EdgeInsets.only(bottom: 12.0),
                    ),
                  ],
                )
              : Center(child: CircularProgressIndicator());
        });
  }

  Widget appBar(BuildContext context) => SliverAppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        pinned: true,
        elevation: 3.0,
        forceElevated: false,
        expandedHeight: 80.0,
        flexibleSpace: FlexibleSpaceBar(
          titlePadding:
              EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: 14.0),
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 12.0, left: 8.0),
                child: GestureDetector(
                  child: FlutterLogo(
                    colors: Colors.cyan,
                    textColor: Colors.white,
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WebViewWidget(url: "https://flutter.dev"),
                    ),
                  ),
                ),
              ),
              //To give a margin
              SizedBox(
                width: 0.0,
              ),
              Text(
                Utils.appName,
                style: TextStyle(
                    fontFamily: Utils.ubuntuRegularFont, fontSize: 14),
              ),
              SizedBox(
                width: 0.0,
              ),
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 8.0),
                  child: CircleAvatar(
                    radius: 14.0,
                    backgroundImage: AssetImage('assets/images/dp.png'),
                  ),
                ),
                onTap: () => showModalBottomSheet(
                    context: context, builder: (context) => ProfileScreen()),
              ),
            ],
          ),
        ),
//        actions: <Widget>[
//
//        ],
      );

  Widget bodyList(List<ListItem> listItems) => SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return listItemDesign(context, listItems[index], index);
        }, childCount: listItems.length),
      );

  /// Setup remote config and fetch value of key: current_version
  setupRemoteConfig() async {
    //final RemoteConfig remoteConfig = await RemoteConfig.instance;
    // Enable developer mode to relax fetch throttling
    // TODO: remove in prod / Enable in debug mode for faster testing
    //remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
    /// if network is weak and fetching fails, set default value
    /*
    remoteConfig.setDefaults(<String, dynamic>{
      'current_version': versionNumber,
    });
    await remoteConfig.fetch(expiration: const Duration(hours: 5));
    await remoteConfig.activateFetched();
    if (remoteConfig.getString("current_version") != versionNumber) {
      buildSnakbar();
    } else {
      //do nothing
    }
    */
  }

  /// Build a snackbar to notify user that a new update is available
  buildSnakbar() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Update Available"),
      duration: Duration(seconds: 10),
      backgroundColor: Colors.green,
      action: SnackBarAction(
        label: 'UPDATE',
        onPressed: () {
          Utils.launchURL(appLink);
        },
      ),
    ));
  }
  /// Method to get value from shared preferences
  _getValueFromSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getBool('hidefab') != null) {
        hasJoinedSlack = prefs.getBool('hidefab');
      } else {
        hasJoinedSlack = false;
      }
    });
  }
}


Future<bool> _willPopCallback() async {
  /// do something here to release FCM instance so that it doesn't configure
  /// again when user comes back to the app from Recent Apps
  /// Nothing can be done as of now.
  /// Link to the issue:
  /// https://github.com/FirebaseExtended/flutterfire/issues/1060
  return true; // return true if the route to be popped
}

//_setIsFcmConfigured(bool isConfigured) async {
//  SharedPreferences prefs = await SharedPreferences.getInstance();
//  prefs.setBool("isConfigured", isConfigured);
//}
//
//Future<bool> _getIsFcmConfigured() async {
//  SharedPreferences prefs = await SharedPreferences.getInstance();
//  if (prefs.getBool("isConfigured") == null ||
//      prefs.getBool("isConfigured") == false) {
//    return false;
//  } else {
//    return true;
//  }
//}
