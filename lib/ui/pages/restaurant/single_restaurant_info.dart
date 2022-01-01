import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification/bloc/restaurant-details/restaurant_details_bloc.dart';
import 'package:flutter_notification/model/geo_model.dart';
import 'package:flutter_notification/model/providers/user_model.dart';
import 'package:flutter_notification/ui/pages/restaurant/widget/restaurant_comment.dart';
import 'package:flutter_notification/ui/shared/widget/custom_app_bar.dart';
import 'package:flutter_notification/ui/shared/widget/loading.dart';
import 'package:flutter_notification/ui/shared/widget/toast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class FooderRestaurantInfoScreen extends StatefulWidget {
  static const routeName = '/restaurant-info';
  const FooderRestaurantInfoScreen({Key? key}) : super(key: key);

  @override
  _FooderRestaurantInfoScreenState createState() => _FooderRestaurantInfoScreenState();
}

class _FooderRestaurantInfoScreenState extends State<FooderRestaurantInfoScreen> {
  final imageList = [
    'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png',
  ];

  final Map<MarkerId, Marker> _marker = {};
  LatLng target = const LatLng(37.42796133580664, -122.085749655962);
  final Completer<GoogleMapController> _mapController = Completer();
  late final CameraPosition _initialPosition;
  late final RestaurantDetailsBloc _restaurantDetailsBloc;
  late final AuthModel auth;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      auth = context.read<AuthModel>();
    });
    _restaurantDetailsBloc = BlocProvider.of<RestaurantDetailsBloc>(context);
    _initialPosition = CameraPosition(
      target: target,
      zoom: 14.4746,
    );
    Future.delayed(Duration.zero,initRestaurantInfo);
  }

  @override
  void dispose() {
    //_restaurantDetailsBloc.close();
    super.dispose();
  }

  void initRestaurantInfo() {
    final arg = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final uniqueId = arg["uniqueId"];
    _restaurantDetailsBloc.add(FetchRestaurantInfo(uniqueId,
      userUniqueId: auth.user?.user?.uniqueId,
    ));
  }
  
  void _copyAddress(String data) {
    Clipboard.setData(ClipboardData(text: data));
    showToast(
      context: context,
      msg: 'Copy Address Successful'
    );
  }

  _ifIsGuest() {
    if(auth.user == null) {
      return Navigator.of(context).pushNamed('/login');
    }
  }


  void _addFavorite(RestaurantDetailsState state) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final uniqueId = arg["uniqueId"];
    _ifIsGuest();
    _restaurantDetailsBloc.add(SetRestaurantFavorite(
      !(state.isFavorite),
      userUniqueId: auth.user!.user!.uniqueId,
      restaurantUniqueId: state.restaurant!.uniqueId,
      uniqueId: uniqueId,
    ));
  }

  void _writeComment() {
    _ifIsGuest();
  }

  void _addList() {
    _ifIsGuest();
  }

  void _toGoogleMap(Geo geo) async {
    String fallbackUrl = 'https://www.google.com/maps/search/?api=1&query=${geo.lat},${geo.lng}';
    var url = 'google.navigation:q=${geo.lat.toString()},${geo.lng.toString()}';
    try {
      bool launched =
      await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  void _toWaze(Geo geo) async {
    var url = 'waze://?ll=${geo.lat.toString()},${geo.lng.toString()}';
    var fallbackUrl =
        'https://waze.com/ul?ll=${geo.lat.toString()},${geo.lng.toString()}&navigate=yes';
    try {
      bool launched =
      await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  void _moveCamera(RestaurantDetailsState state) async {
    setState(() {
      target =  LatLng(state.restaurant!.geo.lat, state.restaurant!.geo.lng);
    });
    MarkerId markerId = const MarkerId('unique');
    Marker marker =  Marker(
        markerId: markerId,
        position: target,
        draggable: false,
        onTap: () {
        }
    );
    setState(() {
      _marker[markerId] = marker;
    });
    final controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: target,
        zoom: 14,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<RestaurantDetailsBloc, RestaurantDetailsState>(
      listener: (context, state) {
        if(state.status == RestaurantDetailStatus.loadRestaurantDataSuccess) {
          _moveCamera(state);
        }
      },
      builder: (context, state) {
        if (
        state.status == RestaurantDetailStatus.loadRestaurantDataSuccess ||
        state.status == RestaurantDetailStatus.onSetFavorite
        ) {
          return restaurantScaffold(state);
        }
        return const FooderLoadingWidget();
      },
    );
  }

  Widget restaurantScaffold(RestaurantDetailsState state) {
    final appbarTheme = Theme.of(context).appBarTheme;
    return Scaffold(
      appBar: screenAppBar(appbarTheme, appTitle: state.restaurant!.restaurantName),
      body: ListView(
        children: [
          SizedBox(
              height: 150,
              child: restaurantImage()
          ),
          restaurantInfo(state),
          restaurantSelection(state),
          const Divider(),
          restaurantAddress(state),
          restaurantMap(state),
          const SizedBox(
            height: 5 ,
          ),
          restaurantGeoFunctionList(state),
          const Divider(),
          restaurantExtraInfo(state),
          const Divider(),
          reportSection(),
          const Divider(),
          commentSection(state),
        ],
      ),
    );
  }

  Widget restaurantImage() {
    final textTheme = Theme.of(context).textTheme;
    return ListView.separated(
      itemCount: imageList.length <= 5 ? imageList.length : 5 ,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        bool isLast = index == 4;
        return Material(
            child: Ink(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  color:isLast ? Colors.black87 : Colors.transparent,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter:isLast ?
                      ColorFilter.mode(Colors.black.withOpacity(0.4),
                          BlendMode.dstATop)
                      : null,
                    image: NetworkImage(
                        imageList[index]
                    ),
                  )
              ),
              child: InkWell(
                onTap: () {},
                child: Stack(
                  children: [
                    isLast ?
                    Align(
                      child: Text(
                        'See More Picture',
                        style: textTheme.subtitle2!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    )
                    : Container(),
                  ],
                ),
              ),
            )
        );
      }, separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 150,
          width: 5,
        );
    },
    );
  }

  Widget restaurantInfo(RestaurantDetailsState state) {
    final textTheme = Theme.of(context).textTheme;
    final secondaryColor = Theme.of(context).secondaryHeaderColor;
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.restaurant!.restaurantName,
                      style: textTheme.headline2!.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      state.restaurant!.state,
                      style: textTheme.subtitle1!.copyWith(
                        fontWeight: FontWeight.normal,
                        color: secondaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    restaurantInfoStatus(secondaryColor, state)
                  ],
                ),
              ),
              Text(
                '${state.restaurant!.rating}',
                style: textTheme.headline1!.copyWith(
                  fontSize: 40,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).primaryColor
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget restaurantInfoStatus(Color secondaryColor, RestaurantDetailsState state) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Row(
          children: [
            Icon(
              Icons.visibility_rounded,
              size: 16,
              color: secondaryColor,
            ),
            const SizedBox(
              width: 5,
            ),
            Text('${state.restaurant!.view}',
              style: textTheme.subtitle2!.copyWith(
                fontWeight: FontWeight.normal,
                color: secondaryColor,
              ),
            )
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Row(
          children: [
            Icon(
              Icons.grade,
              size: 16,
                color: secondaryColor,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(state.restaurant!.totalFollowers,
              style: textTheme.subtitle2!.copyWith(
                fontWeight: FontWeight.normal,
                color: secondaryColor,
              ),
            )
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Row(
          children: [
            Icon(
              Icons.edit,
              size: 16,
              color: secondaryColor,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(state.restaurant!.totalComments,
              style: textTheme.subtitle2!.copyWith(
                fontWeight: FontWeight.normal,
                color: secondaryColor,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget restaurantSelection(RestaurantDetailsState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    _addFavorite(state);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          state.isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                          color: Theme.of(context).primaryColor,
                          size: 40,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Favorite",
                          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    _writeComment();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit_rounded,
                          color: Theme.of(context).primaryColor,
                          size: 40,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Add Review",
                          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    _addList();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.playlist_add,
                          color: Theme.of(context).primaryColor,
                          size: 40,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Add List",
                          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget restaurantAddress(RestaurantDetailsState state) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Expanded(
        child: Text(
          state.restaurant!.address,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
  
  Widget restaurantMap(RestaurantDetailsState state) {
    return SizedBox(
      height: 100,
      child: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        myLocationEnabled: false,
        zoomGesturesEnabled: false,
        scrollGesturesEnabled: false,
        markers: Set<Marker>.of(_marker.values),
        initialCameraPosition: _initialPosition,
        onMapCreated: (GoogleMapController controller) {
          _mapController.complete(controller);
        },
        onTap: (latLng) {
          print('map');
        },
      ),
    );
  }

  Widget restaurantGeoFunctionList(RestaurantDetailsState state) {

    return Container(
      height: 105,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    _toGoogleMap(state.restaurant!.geo);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.5,
                            ),
                            shape: BoxShape.circle,
                          ),
                          width: 45,
                          height: 45,
                          child: const Center(
                            child: Icon(
                              Icons.directions,
                              color: Colors.grey,
                              size: 25,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Find Direction",
                          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    _toWaze(state.restaurant!.geo);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.5,
                            ),
                            shape: BoxShape.circle,
                          ),
                          width: 45,
                          height: 45,
                          child: const Center(
                            child: Icon(
                              Icons.directions_car,
                              color: Colors.grey,
                              size: 25,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Navigator",
                          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    _copyAddress(state.restaurant!.address);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.5,
                            ),
                            shape: BoxShape.circle,
                          ),
                          width: 45,
                          height: 45,
                          child: const Center(
                            child: Icon(
                              Icons.file_copy,
                              color: Colors.grey,
                              size: 25,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Copy Address",
                          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget restaurantExtraInfo(RestaurantDetailsState state) {
    final textTheme = Theme.of(context).textTheme;
    final dateFormatter = DateFormat('yyyy-MM-dd');
    final String formatDate = dateFormatter.format(state.restaurant!.updateDate);
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
               'Extra Information',
                style: textTheme.subtitle1,
              ),
              Text(
                'Update Date $formatDate',
                style: textTheme.subtitle2!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price',
                style: textTheme.subtitle2!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 16,
                ),
              ),
              Text(
                '${state.restaurant!.pricePerson}/ 1 person',
                style: textTheme.subtitle1!.copyWith(
                  fontWeight: FontWeight.normal,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
             Ink(
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(10),
               ),
               child: InkWell(
                 onTap: () {},
                 child: Container(
                   padding: const EdgeInsets.all(5),
                   child: Row(
                     children: [
                       Text('View More Information',
                         style: textTheme.subtitle2!.copyWith(
                           fontSize: 14,
                           fontWeight: FontWeight.normal,
                           color: Theme.of(context).secondaryHeaderColor,
                         ),
                       ),
                       Icon(
                         Icons.chevron_right_rounded,
                         size: 20,
                         color: Theme.of(context).secondaryHeaderColor,
                       ),
                     ],
                   ),
                 ),
               ),
             )
            ],
          )
        ],
      ),
    );
  }

  Widget reportSection() {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 30,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'If any error message please tell us',
                    style: textTheme.subtitle2!.copyWith(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              )
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 30,
              color: Theme.of(context).secondaryHeaderColor,
            )
          ],
        )
      ),
    );
  }

  Widget commentSection(RestaurantDetailsState state) {
    final textTheme = Theme.of(context).textTheme;
    final int total = state.restaurant!.good + state.restaurant!.normal + state.restaurant!.bad;
    return Column(
      children: [
        Text(
          'Review ($total)',
          style: textTheme.headline2!.copyWith(
            color: Theme.of(context).primaryColor
          ),
        ),
        commentType(state),
        const Divider(),
        FooderCommentCard(comments: state.restaurant!.comments,)
      ],
    );
  }

  Widget commentType(RestaurantDetailsState state) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
       margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mood,
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                        Text(
                          'Delicious! (${state.restaurant!.good})',
                          style: textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Theme.of(context).primaryColor,
                          ) ,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sentiment_dissatisfied,
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                        Text(
                          'Not Bad (${state.restaurant!.normal})',
                          style: textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Theme.of(context).primaryColor,
                          ) ,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sentiment_dissatisfied_rounded,
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                        Text(
                          'Normal (${state.restaurant!.bad})',
                          style: textTheme.subtitle2!.copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Theme.of(context).primaryColor,
                              overflow: TextOverflow.ellipsis
                          ) ,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
