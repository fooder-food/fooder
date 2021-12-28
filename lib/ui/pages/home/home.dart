import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification/bloc/home/home_bloc.dart';
import 'package:flutter_notification/core/service/geo/geo_location.dart';
import 'package:flutter_notification/model/providers/user_model.dart';
import 'package:flutter_notification/ui/pages/home/widget/restaurant_card.dart';
import 'package:flutter_notification/ui/shared/widget/avatar.dart';
import 'package:flutter_notification/ui/shared/widget/custom_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'delegate/presistent_delegate.dart';

import 'dart:math' as math;

//import 'dart:core';

// extension IndexedIterable<E> on Iterable<E> {
//   Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
//     var i = 0;
//     return map((e) => f(e, i++));
//   }
// }

class FooderHomeScreen extends StatefulWidget {
  const FooderHomeScreen({Key? key}) : super(key: key);

  @override
  State<FooderHomeScreen> createState() => _FooderHomeScreenState();
}

class _FooderHomeScreenState extends State<FooderHomeScreen> {
  late final ScrollController _scrollController;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  late HomeBloc homeBloc;
  final GeoLocationService _geoLocationService = GeoLocationService();

  bool _toTopButtonIsShow = false;
  List<String> test = ["nearby", "nearby", "nearby", "nearby","nearby", "nearby", "nearby", "nearby"];

  @override
  void initState() {
    homeBloc = BlocProvider.of<HomeBloc>(context);
    getRestaurant();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollControllerListener);
    super.initState();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void getRestaurant() {
    homeBloc.add(FetchAllRestaurant());
  }

  void _onRefresh() async{
    getRestaurant();
  }

  void _scrollControllerListener() {
    if(_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      setState(() {
        _toTopButtonIsShow = false;
      });
      return;
    }
    if(_scrollController.offset >= 60) {
      setState(() {
        _toTopButtonIsShow = true;
      });
      return;
    }
    setState(() {
      _toTopButtonIsShow = false;
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.linear
    );
  }

  void _selectLocation() {

  }

  void _getLocation() async {
    Position positon = await _geoLocationService.determinePosition(context);
    print(positon.latitude);
    print(positon.longitude);
    if(positon != null) {
      Navigator.of(context).pop();
    }
  }

  void _getNearMeModalBottomSheet() async {

    if(_geoLocationService.serviceEnabled && _geoLocationService.getPermissionIsAlways) {
      final position = await _geoLocationService.determinePostionWithOutCheck();
      print(position);
      return;
    }
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: getNearMeContent(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  homeScreenNav(context),
                  homeSecondaryNav(context),
                  SliverToBoxAdapter(
                    child: homeFilterNav(context),
                  ),
                  restaurantList(),
                ],
              ),
              onRefresh: _onRefresh,
            ),
            if(_toTopButtonIsShow)
              Positioned(
                right: 10,
                bottom: 40,
                child: scrollToTopButton(),
              ),
          ],
        ),

        // RefreshIndicator(
        //   onRefresh: () async {},
        //   child:
        // )
      ),
    );
  }

  Widget homeScreenNav(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SliverPadding(
      padding: const EdgeInsets.only(
        top: 10,
        left: 5,
        right: 10,
      ),
      sliver: SliverAppBar(
        title: Text(
          'Fooder',
          style: textTheme.headline1,
        ),
        actions: [
          Row(
            children: [
              notificationsIcon(context),
              const SizedBox(
                width: 15,
              ),
              Consumer<AuthModel>(
                builder: (_, authModel, __) =>
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed('/profile'),
                      child: SizedBox(
                        width: 45,
                        height: 45,
                        child: fooderAvatar(
                          user: authModel.user?.user,
                        ),
                      ),
                    ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget notificationsIcon(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [
          const Icon(
            Icons.notifications,
            size: 38,
            color: Colors.black45,
          ),
          Positioned(
            right: 0,
            top: 1,
            child: ClipOval(
              child: Container(
                padding: const EdgeInsets.all(1),
                color: Colors.white,
                child: ClipOval(
                  child: Container(
                    width: 18,
                    height: 18,
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Center(
                        child: Text(
                          '1',
                          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget scrollToTopButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Colors.grey,
          padding: const EdgeInsets.all(10),
          shape: const CircleBorder(),
        ),
        onPressed: _scrollToTop,
        child: const Icon(
          Icons.vertical_align_top_rounded,
          color: Colors.black,
          size: 30,
        )
    );
  }

  Widget homeSecondaryNav(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: PersistentHeader(
        widget: Container(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              selectionLocation(context),
              secondaryNavActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectionLocation(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      child: InkWell(
        onTap: _selectLocation,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container(
          padding: const EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('You are now discovering',
                style: textTheme.subtitle2!.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Row(
                children: [
                  Text(
                      'Johor Bahru',
                      style: textTheme.subtitle2!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      )
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget secondaryNavActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        secondaryActionButton(
            icon:  Icons.search,
            voidCallback: () {}
        ),
        const SizedBox(
          width: 10,
        ),
        secondaryActionButton(
            icon:  Icons.map,
            voidCallback: () {
              Navigator.of(context).pushNamed('/map-screen');
            }
        ),
      ],
    );
  }

  Widget secondaryActionButton({
    required IconData icon,
    required VoidCallback voidCallback
  }) {
    return Material(
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: voidCallback,
        child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 5,
            ),
            child: Icon(
              icon,
              size: 30,
              color: Colors.black54,
            )
        ),
      ),
    );
  }

  Widget homeFilterNav(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          homeFilterSorting(context),
          Row(
            children: [
              filterButton(context,
                icon: Icons.refresh_rounded,
                buttonTitle: 'Near Me',
                voidCallback: _getNearMeModalBottomSheet,
              ),
              const SizedBox(
                width: 10,
              ),
              filterButton(context,
                icon: Icons.filter_list_rounded,
                buttonTitle: 'Filter',
                sideColor: Colors.grey,
                backgroundColor: Colors.white,
                textColor: Colors.grey,
                voidCallback: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget homeFilterSorting(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Rating',
              style: textTheme.subtitle2!.copyWith(
                color: Colors.black54,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
            const Icon(Icons.arrow_drop_down_rounded),
          ],
        ),
      ),
    );
  }

  Widget filterButton(BuildContext context, {
    required String buttonTitle,
    required IconData icon,
    required VoidCallback voidCallback,
    Color? backgroundColor,
    Color? sideColor,
    Color? textColor,
  }) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: backgroundColor ?? Colors.grey[200],
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          onPrimary: Colors.grey,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: sideColor != null
                ? BorderSide(width: 1.0, color: sideColor,)
                : BorderSide.none,
          ),
        ),
        onPressed: voidCallback,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: Icon(
                icon,
                color: textColor ?? Theme.of(context).primaryColor,
                size:20,
              ),
            ),
            const SizedBox(width: 3,),
            Text(
              buttonTitle,
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                color: textColor ?? Theme.of(context).primaryColor,
                fontWeight: FontWeight.normal,
                fontSize: 13,
              ),
            )
          ],
        )
    );
  }

  Widget restaurantList() {

    return SliverPadding(
      padding: const EdgeInsets.only(
        top: 15,
        left: 15,
        bottom: 15,
        right: 15,
      ),
      sliver: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if(state.status == HomeStatus.loadRestaurantDataSuccess) {
            _refreshController.refreshCompleted();
          }
        },
        builder: (context, state){
          return SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 220,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return FooderRestaurantCard(
                  state: state,
                  index: index,
                );
              },
              childCount: state.status == HomeStatus.loadRestaurantDataSuccess ? state.restaurants.length :  4,
            ),
          );
        } ,
      ),
    );
  }

  Widget getNearMeContent() {
    return Stack(
      children: [
        Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.close,
              color: Colors.grey,
              size: 30,
            ),
          ),
        ),
        Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            height: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Enable location service  for better discovery service",
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: FooderCustomButton(
                    isBorder: false,
                    buttonContent: "Enabling location service",
                    onTap: _getLocation,
                  ),
                ),
              ],
            )
        ),
      ] ,
    );
  }

}
