import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification/bloc/add-list/add_list_bloc.dart';
import 'package:flutter_notification/model/list_search_restaurant_model.dart';
import 'package:flutter_notification/ui/shared/widget/custom_app_bar.dart';
import 'package:flutter_notification/ui/shared/widget/toast.dart';

class FooderAddListRestaurantScreen extends StatefulWidget {
    static const routeName = '/add-list-restaurant';
    const FooderAddListRestaurantScreen({Key? key}) : super(key: key);

    @override
    _FooderAddListRestaurantScreenState createState() => _FooderAddListRestaurantScreenState();
  }

  class _FooderAddListRestaurantScreenState extends State<FooderAddListRestaurantScreen> {
    final TextEditingController _searchController = TextEditingController();
    final FocusNode _searchFocusNode = FocusNode();
    bool _isSearchText = false;
    late final AddListBloc _addListBloc;
    String uniqueId = '';

    @override
  void initState() {
      _addListBloc = BlocProvider.of<AddListBloc>(context);
    _searchController.addListener(() {
      if(_searchController.text.isNotEmpty) {
        setState(() {
          _isSearchText = true;
        });
      } else {
        setState(() {
          _isSearchText = false;
        });
      }
    });
    _searchFocusNode.requestFocus();
    Future.delayed(Duration.zero, initPage);
    super.initState();
  }

  void initPage() {
    final arg = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    uniqueId = arg["uniqueId"];
  }

    @override
    Widget build(BuildContext context) {
      final appbarTheme = Theme.of(context).appBarTheme;
      return Scaffold(
        appBar: screenAppBar(
            appbarTheme,
            appTitle: '',
          customWidget: TextField(
            onEditingComplete: () {
              print('test');
              print(uniqueId);
              _addListBloc.add(SearchRestaurantByKeyword(_searchController.text, uniqueId));
              _searchFocusNode.unfocus();
            },
            textInputAction: TextInputAction.search,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 18,
            ),
            focusNode: _searchFocusNode,
            controller: _searchController,
            decoration: InputDecoration(
              suffix: _isSearchText ? _cancelIcon() : null,
              hintText: 'Search for restaurants',
            ),
          ),
          onPopCallback: () {
            _addListBloc.add(FetchListInfo(uniqueId: uniqueId));
            Navigator.of(context).pop();
          },
        ),
        body: Container(
          child: BlocConsumer<AddListBloc, AddListState>(
            listener: (context, state) {
              if(state.status == CollectionListStatus.addedToListSuccess) {
                showToast(msg: 'Added to the MyList', context: context);
              }
              if(state.status == CollectionListStatus.delFromListSuccess) {
                showToast(msg: 'Removed to the MyList', context: context);
              }
            },
            builder: (context, state) {
              if(state.status == CollectionListStatus.onSearch) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if(state.status == CollectionListStatus.searchSuccess
                  || state.status == CollectionListStatus.onAddedRestaurantToList
                  || state.status == CollectionListStatus.addedToListSuccess
                  || state.status == CollectionListStatus.delFromListSuccess
                  || state.status == CollectionListStatus.onDelRestaurantToList
              ) {
                return ListView.builder(
                  itemCount: state.restaurants.length,
                  itemBuilder: (context, index) {
                    return restaurantCard(state.restaurants[index]);
                  },
                );
              }

              return Container();
            },
          ),
        ),
      );
    }

    Widget _cancelIcon() {
      return  InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          _searchController.clear();
          setState(() {
            _isSearchText = false;
          });
        },
        child: Container(
          margin: const EdgeInsets.only(top: 5, bottom: 3),
          child: const Icon(Icons.cancel, color: Colors.grey,),
        ),
      );
    }

    Widget restaurantCard( ListSearchRestaurant restaurant) {
      return ListTile(
        contentPadding: const EdgeInsets.all(10),
        key: Key(restaurant.uniqueId),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: restaurant.image,
              imageBuilder: (ctx, imageProvider) {
                return Container(
                  width: 60,
                  height: 60,
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
                  titleContent(restaurant.restaurantName),
                  const SizedBox(
                    height: 5,
                  ),
                  ratingContent(restaurant.rating.toString()),
                ],
              ),
            )
          ],
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            shape: const StadiumBorder(),
            elevation: 0,
            shadowColor: Colors.transparent,
            side: BorderSide(
              color:restaurant.isAdded ? Theme.of(context).primaryColor : Theme.of(context).secondaryHeaderColor,
              width: 1,
            )
          ),
          onPressed: () {
            if(restaurant.isAdded) {
              _addListBloc.add(DelRestaurantBySearch(
                  keyword: _searchController.text,
                  restaurantUniqueId: restaurant.uniqueId,
                  collectionUniqueId: uniqueId)
              );
            } else {
              _addListBloc.add(AddRestaurantBySearch(
                  keyword: _searchController.text,
                  restaurantUniqueId: restaurant.uniqueId,
                  collectionUniqueId: uniqueId)
              );
            }
          },
          child: restaurant.isAdded
              ? Icon(
                Icons.check_rounded,
                color: Theme.of(context).primaryColor,
                size: 30,
              )
              : Text('Add',
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                ), ) ,
        )
      );
    }

    Widget titleContent(String title) {
      return Text(title,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.subtitle2!.copyWith(
          fontSize: 18,
        ),);
    }

    Widget ratingContent(String rating) {
      return Text(rating, style: Theme.of(context).textTheme.subtitle2!.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor ,
      ),);
    }

  }
