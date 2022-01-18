import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification/bloc/add-list/add_list_bloc.dart';
import 'package:flutter_notification/model/collection_list_item_model.dart';
import 'package:flutter_notification/model/providers/user_model.dart';
import 'package:flutter_notification/model/user_model.dart';
import 'package:flutter_notification/ui/shared/widget/custom_app_bar.dart';
import 'package:flutter_notification/ui/shared/widget/loading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FooderListInfoScreen extends StatefulWidget {
  static const routeName = '/list-info';
  const FooderListInfoScreen({Key? key}) : super(key: key);

  @override
  _FooderListInfoScreenState createState() => _FooderListInfoScreenState();
}

class _FooderListInfoScreenState extends State<FooderListInfoScreen> {
  late final AddListBloc _addListBloc;
  String uniqueId = '';
  @override
  void initState() {
    _addListBloc = BlocProvider.of<AddListBloc>(context);
    Future.delayed(Duration.zero,initListInfo);
    super.initState();
  }

  void initListInfo() {
    final arg = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    uniqueId = arg["uniqueId"];
    print('uniqueId $uniqueId');
    // setState(() {
    //   uniqueId = arg["uniqueId"];
    // });
    _addListBloc.add(FetchListInfo(uniqueId: uniqueId));

  }

  String dateFormatter(DateTime date) {
    final dateFormatter = DateFormat('yyyy-MM-dd');
    final String formatDate = dateFormatter.format(date);
    return formatDate;
  }

  @override
  Widget build(BuildContext context) {
    final appbarTheme = Theme.of(context).appBarTheme;
    return Scaffold(
      appBar: screenAppBar(appbarTheme, appTitle: '', onPopCallback: () {
        Navigator.of(context).pop();
        _addListBloc.add(const FetchList());
      }),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: BlocConsumer<AddListBloc, AddListState>(
          listener: (context, state) {},
          builder: (context, state) {
            if(state.status == CollectionListStatus.onFetchInfo) {
              return const FooderLoadingWidget();
            }
            if(state.info != null || state.status == CollectionListStatus.fetchInfoSuccess) {
              return ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        dateFormatter(state.info!.updateDate),
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          fontSize: 14,
                          color: Theme.of(context).secondaryHeaderColor,

                        ),
                      ),
                    ],
                  ),
                  userInfo(),
                  const SizedBox(
                    height: 20,
                  ),
                  titleContent(state.info!.title),
                  const SizedBox(
                    height: 20,
                  ),
                  descriptionContent(state.info!.description),
                  const SizedBox(
                    height: 10,
                  ),
                  Divider(color: Theme.of(context).secondaryHeaderColor.withOpacity(0.8),),
                  const SizedBox(
                    height: 10,
                  ),
                  restaurantTitleCount(state.info!.items.length),
                  const SizedBox(
                    height: 10,
                  ),
                  addRestaurantButton(),
                  const SizedBox(
                    height: 10,
                  ),
                  for(int index = 0;index < state.info!.items.length; index ++)
                    restaurantCard(state.info!.items[index]),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget userInfo() {
    return Consumer<AuthModel>(
      builder: (_, authModel, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                avatar(authModel.user!.user),
                const SizedBox(
                  width: 10,
                ),
                writerInfo(authModel.user!.user!.username),
              ],
            ),
            GestureDetector(
              onTap: () {
                final textTheme = Theme.of(context).textTheme;
                showAdaptiveActionSheet(
                  context: context,
                  title: Text('Select Action', style: textTheme.subtitle1,),
                  actions: <BottomSheetAction>[
                    BottomSheetAction(
                        leading: Container(
                          padding: const EdgeInsets.only(right: 10),
                          child: const Icon(Icons.description_rounded, color: Colors.grey,),
                        ),
                        title: Text('Edit information', style: textTheme.subtitle1,),
                        onPressed: () {

                        }
                    ),
                    BottomSheetAction(
                        leading: Container(
                          padding: const EdgeInsets.only(right: 10),
                          child: const Icon(Icons.edit_rounded, color: Colors.grey,),
                        ),
                        title: Text('Edit List', style: textTheme.subtitle1,),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/edit-list');
                        }
                    ),
                    BottomSheetAction(
                        leading: Container(
                          padding: const EdgeInsets.only(right: 10),
                          child: const Icon(Icons.delete_rounded, color: Colors.grey,),
                        ),
                        title: Text('Delete', style: textTheme.subtitle1,),
                        onPressed: () {

                        }
                    ),
                  ],
                );
              },
              child: const Icon(Icons.more_vert_rounded, size: 24,),
            )
          ],
        );
      },
    );
  }

  Widget avatar(User? user) {
    if(user != null) {
      return CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: user.avatar,
        imageBuilder: (ctx, imageProvider) {
          return Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        placeholder: (context, url) =>
        const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    }
    return SizedBox(
      width:40,
      height: 40,
      child: ClipOval(
        child: SvgPicture.asset(
          'assets/img/guest-avatar.svg',
        ),
      ),
    );

  }

  Widget writerInfo(String name) {
    return Column(
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.subtitle2!.copyWith(
            fontSize: 18,
          ),),
      ],
    );
  }

  Widget titleContent(String title) {
    return Expanded(child: Text(title, style: Theme.of(context).textTheme.subtitle2!.copyWith(
      fontSize: 24,
    ),));
  }

  Widget descriptionContent(String description) {
    return Expanded(
      child: Text(description, style: Theme.of(context).textTheme.subtitle2!.copyWith(
        fontSize: 14,
        color: Theme.of(context).secondaryHeaderColor ,
      ),),
    );
  }

  Widget restaurantTitleCount(int total) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Restaurants', style: Theme.of(context).textTheme.subtitle2!.copyWith(
          fontSize: 20,
        ),),
        const SizedBox(
          width: 10,
        ),
        Text(total.toString(), style: Theme.of(context).textTheme.subtitle2!.copyWith(
          color: Theme.of(context).primaryColor,
          fontSize: 14,
        ),),
      ],
    );
  }

  Widget addRestaurantButton() {
    return ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add-list-restaurant', arguments: {
            "uniqueId": uniqueId,
          });
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
          primary: Colors.grey[300],
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add,
              size: 16,
              color: Theme.of(context).secondaryHeaderColor
            ),
            const SizedBox(width: 10,),
            Text(
                'Add Restaurants',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
          ],
        )
    );
  }

  Widget restaurantCard(CollectionListItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/restaurant-info', arguments: {
          'uniqueId': item.restaurant.uniqueId,
        });
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ]
            ),
            child: Column(
              children: [
                CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: item.restaurant.image,
                  imageBuilder: (ctx, imageProvider) {
                    return Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 100,
                              child: Text(item.restaurant.name,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5,),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 100,
                              child: Text(item.restaurant.address,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                  fontSize: 14,
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(item.restaurant.rating.toDouble().toString(),
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                          fontSize: 30,
                          color: Theme.of(context).primaryColor,
                        ),

                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            top: 10,
            right: 10,
            child: Icon(Icons.star_border_rounded, size: 35, color: Colors.white,),
          )
        ],
      ),
    );
  }

}
