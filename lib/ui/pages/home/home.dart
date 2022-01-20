import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification/bloc/add-restaurant/add_restaurant_bloc.dart';
import 'package:flutter_notification/bloc/home/home_bloc.dart';
import 'package:flutter_notification/core/service/geo/geo_location.dart';
import 'package:flutter_notification/core/service/storage/storage_service.dart';
import 'package:flutter_notification/model/providers/select_place.dart';
import 'package:flutter_notification/model/providers/user_model.dart';
import 'package:flutter_notification/model/providers/user_search_radius.dart';
import 'package:flutter_notification/model/restaurant_category_model.dart';
import 'package:flutter_notification/ui/pages/home/widget/restaurant_card.dart';
import 'package:flutter_notification/ui/pages/home/widget/select_place.dart';
import 'package:flutter_notification/ui/shared/widget/avatar.dart';
import 'package:flutter_notification/ui/shared/widget/custom_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'delegate/presistent_delegate.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'dart:math' as math;

import 'home_init.dart';

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
  bool hasLocation = false;
  bool _toTopButtonIsShow = false;
  late AddRestaurantBloc _addRestaurantBloc;

  @override
  void initState() {
    _addRestaurantBloc = BlocProvider.of<AddRestaurantBloc>(context);
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
    //   await homeInit();
    // });
    homeBloc = BlocProvider.of<HomeBloc>(context);
    initRestaurant();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollControllerListener);

    // if(_geoLocationService.getPermissionIsAlways && _geoLocationService.getServiceEnabled) {
    //   setState(() {
    //     hasLocation = true;
    //   });
    // }
    super.initState();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> initRestaurant() async {

    try {
      final String? _firstView = await StorageService().getByKey('first_view');
      print(_firstView);
      if(_firstView != null) {
        final locationFirst = context.read<SelectPlaceModel>().locationFirst;
        final userSearchModel = context.read<UserSearchRadiusModel>();
        if(locationFirst) {

          final position = await _geoLocationService.determinePosition(context);
          if(_geoLocationService.getServiceEnabled && _geoLocationService.getPermissionIsAlways) {

            homeBloc.add(FetchAllRestaurant(
              sort: userSearchModel.selectedSorting,
              radius: userSearchModel.distance,
              latitude: position.latitude,
              longitude: position.longitude,
              filter: userSearchModel.selectedCategoryIdList,
            ));
            setState(() {
              hasLocation = true;
            });
            return;
          }
        } else {
          final selectedPlace = context.read<SelectPlaceModel>().selectedPlace;
          if(selectedPlace != null) {
            homeBloc.add(FetchAllRestaurant(
              sort: userSearchModel.selectedSorting,
              radius: userSearchModel.distance,
              state: selectedPlace.name,
              filter: userSearchModel.selectedCategoryIdList,
            ));
          }

        }

      }

    } catch(e) {
      if(!_geoLocationService.getServiceEnabled || !_geoLocationService.getPermissionIsAlways) {
        context.read<UserSearchRadiusModel>().updateSelectedSortingInit();
        setState(() {
          hasLocation = false;
        });
      }
    }
    getRestaurant();
  }

  void getRestaurant() {
    final userSearchModel = context.read<UserSearchRadiusModel>();
    homeBloc.add(FetchAllRestaurant(
      sort: userSearchModel.selectedSorting,filter:
      userSearchModel.selectedCategoryIdList)
    );
  }

  Future<void> _onRefresh() async{
      await initRestaurant();
     // getRestaurant();
      _refreshController.refreshCompleted();
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
    showMaterialModalBottomSheet(
      context: context,
      enableDrag: false,
      builder: (context) => FooderSelectPlaceScreen(),
    );
  }

  void _ratingFilter() {
    showMaterialModalBottomSheet(
      context: context,
      enableDrag: false,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: 150,
        child: Column(
          children: [
            Center(
                child: Text(
                  "Sort by",
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    //color: Theme.of(context).primaryColor,
                  ),
                )
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for(var index = 0 ; index < sortList.length; index++)
                  ratingButton(sortList[index]),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "* Turn on location services to sort by distance",
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              ],
            )
          ],
        )

      ),
    );
  }

  void _filterSelection() {
    _addRestaurantBloc.add(FetchRestaurantCategoriesEvent());
    showMaterialModalBottomSheet(
      context: context,
      enableDrag: false,
      builder: (context) => Container(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 2),
          height: 500,
          child: BlocConsumer<AddRestaurantBloc, AddRestaurantState>(
            listener: (context, state) {},
            builder: (context, state) {
              if(state.status == AddRestaurantFormStatus.onLoad) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          final userSearchModel = context.read<UserSearchRadiusModel>();
                          userSearchModel.updateSelectedCategoryListConfirm(true);
                          userSearchModel.updateCurrenSelectedCategoryList(userSearchModel.selectedCategoryIdList);
                          Navigator.of(context).pop();
                          initRestaurant();
                        },
                        child: Text(
                          'Apply Filter',
                          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).primaryColor,
                          ),),
                      ),
                    ],
                  ),
                  const Divider(),
                  Center(
                      child: Text(
                        "Cuisine",
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          //color: Theme.of(context).primaryColor,
                        ),
                      )
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: GridView.builder(
                        itemCount: state.categories.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          mainAxisExtent: 110,
                        ),
                        itemBuilder: (context, index) {
                          return categoryCard(state.categories[index]);
                        }
                    ),
                  )
                ],
              );
            },
          )

      ),
    ).whenComplete(() {
      final userSearchRadiusModel = context.read<UserSearchRadiusModel>();
      if(!userSearchRadiusModel.isSelectedCategoryListConfirm) {
       userSearchRadiusModel.updateSelectedCategoryIdList(userSearchRadiusModel.currentSelectedCategoryList);
      }
      userSearchRadiusModel.updateSelectedCategoryListConfirm(false);
    });
  }

  // void reFetchRestaurant({required double distance, required double longitude, required double latitude}) {
  //   homeBloc.add(FetchAllRestaurant(
  //     radius: distance,
  //     longitude: longitude,
  //     latitude: latitude,
  //   ));
  // }

  void _getLocation() async {
    Navigator.of(context).pop();
    context.read<UserSearchRadiusModel>().updateSelectedSortingAsDistance();
    initRestaurant();
  }


  void _getNearMeModalBottomSheet() async {
    await _geoLocationService.init();
    if(_geoLocationService.getServiceEnabled && _geoLocationService.getPermissionIsAlways) {
      setState(() {
        hasLocation = true;
      });
      context.read<SelectPlaceModel>().updateLocationPriority(true);
      // final position = await _geoLocationService.determinePostionWithOutCheck();
        showMaterialModalBottomSheet(
          context: context,
          enableDrag: false,
          builder: (context) => selectAreaRadius(),
        );
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
              enablePullUp: false,
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
                  Consumer<SelectPlaceModel>(
                    builder: (_, selectedPlaceModel, __) {
                      return Text(
                          selectedPlaceModel.selectedPlace == null ?
                          ''
                          : selectedPlaceModel.selectedPlace!.name,
                          style: textTheme.subtitle2!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          )
                      );
                    },
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
              Consumer<UserSearchRadiusModel>(
                builder: (context, radiusModel,_) {
                  return Consumer<SelectPlaceModel>(
                    builder: (_, selectModel, __) {
                      return filterButton(context,
                        icon: Icons.refresh_rounded,
                        buttonTitle: selectModel.locationFirst
                            ?  hasLocation
                              ? radiusModel.distanceText
                              : 'Near Me'
                            : 'Near Me',

                        voidCallback: _getNearMeModalBottomSheet,
                      );
                    } ,
                  );
                }
              ),
              const SizedBox(
                width: 10,
              ),
              Consumer<UserSearchRadiusModel>(
                builder: (_, userSearchRadiusModel, __) {
                  return filterButton(context,
                    icon: Icons.filter_list_rounded,
                    buttonTitle: 'Filter',
                    sideColor: Colors.grey,
                    backgroundColor: Colors.white,
                    textColor: Colors.grey,
                    isActiveFilter: userSearchRadiusModel.selectedCategoryIdList.isNotEmpty,
                    voidCallback: () {
                      _filterSelection();
                    },
                  );
                },
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
      onTap: () {
        _ratingFilter();
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Consumer<UserSearchRadiusModel>(
              builder: (_, userSearchModel, __) {
                return Text(sortList[userSearchModel.selectedSorting]["title"],
                  style: textTheme.subtitle2!.copyWith(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                );
              }
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
    bool isActiveFilter = false,
  }) {
    return Stack(
      children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: backgroundColor ?? Colors.grey[200],
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              onPrimary: Colors.grey,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: sideColor != null
                    ? isActiveFilter
                      ? BorderSide(width: 1.0, color: Theme.of(context).primaryColor,)
                      : BorderSide(width: 1.0, color: sideColor,)
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
                    color: isActiveFilter
                        ? Theme.of(context).primaryColor
                        : textColor ?? Theme.of(context).primaryColor,
                    size:20,
                  ),
                ),
                const SizedBox(width: 3,),
                Text(
                  buttonTitle,
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    color: isActiveFilter
                        ? Theme.of(context).primaryColor
                        : textColor ?? Theme.of(context).primaryColor,
                    fontWeight: FontWeight.normal,
                    fontSize: 13,
                  ),
                )
              ],
            )
        ),
        isActiveFilter ?
        Positioned(
          right: 0,
          top: 5,
          child: Container(
            width: 25,
            height: 15,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                'ON',
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                  color: Colors.white
                ),
              ),
            ),
          ),
        ): Container(),
      ],
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
        listener: (context, state) async {
          if(state.status == HomeStatus.loadRestaurantDataSuccess) {

            await _geoLocationService.init();
            if(!_geoLocationService.getPermissionIsAlways || !_geoLocationService.getServiceEnabled) {
              setState(() {
                hasLocation = false;
              });
            } else  if(_geoLocationService.getPermissionIsAlways && _geoLocationService.getServiceEnabled){
              setState(() {
                hasLocation = true;
              });
            }
            _refreshController.refreshCompleted();
          }
        },
        builder: (context, state){
          if(state.status == HomeStatus.loadFailed) {
            return SliverToBoxAdapter(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Server Error'),
                    IconButton(
                        onPressed: () async {
                          await _refreshController.requestRefresh();
                          await _onRefresh();
                          if(state.status == HomeStatus.loadFailed) {
                            _refreshController.refreshFailed();
                          }

                        },
                        icon: const Icon(Icons.refresh_rounded),
                    ),
                  ],
                ),
              ),
            );
          }

          if(state.restaurants.isEmpty && state.status == HomeStatus.loadRestaurantDataSuccess) {
            return SliverToBoxAdapter(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('No Data'),
                    IconButton(
                      onPressed: () async {
                        await _refreshController.requestRefresh();
                        await _onRefresh();
                        if(state.status == HomeStatus.loadFailed) {
                          _refreshController.refreshFailed();
                        }

                      },
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                  ],
                ),
              ),
            );
          }
          if(state.status == HomeStatus.initial) {
            return SliverToBoxAdapter(child: Container());
          }

          return SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 230,
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

  Widget selectAreaRadius() {
    return SizedBox(
      height: 200,
      child:  StatefulBuilder(
        builder: (context, setState) {
          final primaryColor = Theme.of(context).primaryColor;
          final textTheme = Theme.of(context).textTheme;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 30),
            child: Consumer<UserSearchRadiusModel>(
              builder: (context, radiusModel, _) {
                return Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          'Select Your want search radius',
                          style: textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            radiusModel.distanceText,
                            style: textTheme.headline2!.copyWith(
                              fontSize: 30,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SfSliderTheme(
                          data: SfSliderThemeData(
                            activeTrackHeight: 3,
                            inactiveTrackHeight: 3,
                            activeTrackColor: primaryColor.withOpacity(0.5),
                            inactiveTrackColor: primaryColor.withOpacity(0.5),
                            activeDividerRadius: 5,
                            inactiveDividerRadius: 5,
                            inactiveDividerColor: primaryColor,
                            activeDividerColor: primaryColor,
                            thumbRadius: 10,
                            thumbColor: primaryColor,

                          ),
                          child: SfSlider(
                            min: 0.0,
                            max: 4.0,
                            value: radiusModel.radius,
                            showDividers: true,
                            interval: 1,
                            onChanged: (value) => radiusModel.updateRadius(value),
                            onChangeEnd: (value) async {
                              Navigator.of(context).pop();
                              final Position position = await _geoLocationService.determinePosition(context);
                              homeBloc.add(FetchAllRestaurant(
                                radius: radiusModel.distance,
                                longitude: position.longitude,
                                latitude: position.latitude,
                                sort: radiusModel.selectedSorting,
                                filter: radiusModel.selectedCategoryIdList,
                              ));
                              await Future.delayed(const Duration(milliseconds: 500));
                              radiusModel.updateRadiusWhenChangeEnd();

                            },
                          ),
                        ),
                        Text(
                          'My Near',
                          style: textTheme.subtitle2!.copyWith(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontWeight: FontWeight.normal,
                          )
                          ,),
                      ],
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget ratingButton(Map<String, dynamic> sort) {
    return GestureDetector(
      onTap: () {
        context.read<UserSearchRadiusModel>().updateSelectedSorting(sort["id"]);
        initRestaurant();
        Navigator.of(context).pop();
      },
      child: Row(
        children: [
          Consumer<UserSearchRadiusModel>(
            builder: (_, userSearchModel, __) {
              return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:userSearchModel.selectedSorting == sort["id"]
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      sort["title"],
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        fontWeight: FontWeight.normal,
                        color:userSearchModel.selectedSorting == sort["id"]
                          ? Theme.of(context).primaryColor
                          : null,
                        fontSize: 16,
                      ),
                    ),
                  )
              );
            },
          ),
          const SizedBox(width: 10,),
        ],
      ),
    );
  }

  Widget categoryCard(RestaurantCategory cuisine) {
    return  GestureDetector(
      onTap: () {
        final UserSearchRadiusModel userSearchRadiusModel = context.read<UserSearchRadiusModel>();
        final selectedList = userSearchRadiusModel.selectedCategoryIdList;
        bool isExist = selectedList.contains(cuisine.uniqueId);
        if(!isExist) {
          selectedList.add(cuisine.uniqueId);
        } else {
         selectedList.removeWhere((selected) => selected == cuisine.uniqueId);
        }
        userSearchRadiusModel.updateSelectedCategoryIdList(selectedList);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Consumer<UserSearchRadiusModel>(
              builder: (_, userSearchRadiusModel, __) {
                return Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: userSearchRadiusModel.selectedCategoryIdList.contains(cuisine.uniqueId)
                              ? Colors.red
                              : Colors.grey,
                        width: userSearchRadiusModel.selectedCategoryIdList.contains(cuisine.uniqueId)
                              ? 1
                              : 0.5,
                        // color: isSelected ? Colors.red : Colors.grey,
                        // width: isSelected ? 1: 0.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 15,
                          offset: const Offset(5, 10), // changes position of shadow
                        ),
                      ]
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: CachedNetworkImage(
                          imageUrl: cuisine.categoryIcon,
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                      userSearchRadiusModel.selectedCategoryIdList.contains(cuisine.uniqueId)
                     ? const Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(
                          Icons.check_rounded,
                          color: Colors.red,
                          size: 30,
                        ),
                      )
                     : Container(),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Text(cuisine.categoryName),
          ],
        ),
      ),
    );
  }

}
