import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification/bloc/favorite/favorite_bloc.dart';
import 'package:flutter_notification/model/favorite_restaurant_model.dart';
import 'package:flutter_notification/model/providers/navigator_model.dart';
import 'package:flutter_notification/model/providers/user_model.dart';
import 'package:flutter_notification/ui/shared/widget/loading.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FooderFavoriteScreen extends StatefulWidget {
  static const routeName = '/favorite';
  const FooderFavoriteScreen({Key? key}) : super(key: key);

  @override
  _FooderFavoriteScreenState createState() => _FooderFavoriteScreenState();
}

class _FooderFavoriteScreenState extends State<FooderFavoriteScreen> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  late final FavoriteBloc _favoriteBloc;
  @override
  void initState() {
    _favoriteBloc = BlocProvider.of<FavoriteBloc>(context);
    // TODO: implement initState
    super.initState();
  }

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        body: Consumer<AuthModel>(
          builder: (_, auth, __) {
            if(auth.user == null) {
              if(context.watch<NavigatorModel>().index == 4) {
                Future(() =>
                    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false)
                );
              }
              context.read<NavigatorModel>().resetIndex();
              return Container();
            }
            _favoriteBloc.add(const FetchFavorite());
            return Column(
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Center(
                      child: Text(
                        'Favorite List',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                ),
                const Divider(),
                Expanded(
                  child: SmartRefresher(
                    onRefresh: _onRefresh,
                    enablePullDown: true,
                    enablePullUp: false,
                    controller: _refreshController,
                    child:  BlocConsumer<FavoriteBloc, FavoriteState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if(state.status == FavoriteListStatus.loadSuccess) {
                          if(state.favoriteList.isEmpty) {
                            return  Center(
                              child: Text(
                                'Your Don\'t have any favorite restaurant',
                                style: textTheme.headline2!.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[600],
                                ),
                              ),
                            );
                          }
                          return ListView.separated(
                            itemCount: state.favoriteList.length,
                            separatorBuilder: (context, index) {
                              return Divider(
                                color: Theme.of(context).secondaryHeaderColor.withOpacity(0.5),
                              );
                            },
                            itemBuilder: (context, index) {
                              return favoriteCard(state.favoriteList[index].restaurant, state.favoriteList[index].isActive);
                            },
                          );
                        }
                        if(state.status == FavoriteListStatus.onLoad) {
                          return const FooderLoadingWidget();
                        }
                        return Container(
                          child: Text(state.status.toString()),
                        );
                      },
                    ),
                  )
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget favoriteCard(FavoriteRestaurant restaurant, bool isActive) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () async {
       await Navigator.of(context).pushNamed('/restaurant-info', arguments: {
          'uniqueId': restaurant.uniqueId,
        });
       _favoriteBloc.add(const FetchFavorite());
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          height: 120,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: restaurant.image,
                imageBuilder: (ctx, imageProvider) {
                  return Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
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
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.state,
                      style: textTheme.subtitle2!.copyWith(
                          color: Theme.of(context).secondaryHeaderColor
                      ),
                    ),
                    Text(
                      restaurant.name,
                      style: textTheme.subtitle1!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(restaurant.rating.toString(),
                      style: textTheme.subtitle1!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.visibility_rounded,
                              size: 20,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(restaurant.view.toString(),
                              style: textTheme.headline2!.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[600],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(restaurant.review.toString(),
                              style: textTheme.headline2!.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[600],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              isActive
              ? Icon(
                Icons.star_rounded,
                size: 30,
                color: Theme.of(context).primaryColor,
              )
              : Icon(
                Icons.star_border_rounded,
                size: 30,
                color: Theme.of(context).primaryColor,
              ),
            ],
          )
      ),
    );
  }
}
