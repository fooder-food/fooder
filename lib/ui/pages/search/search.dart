import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification/bloc/search-restaurant/search_restaurant_bloc.dart';
import 'package:flutter_notification/bloc/search-restaurant/search_restaurant_repo.dart';
import 'package:flutter_notification/core/service/storage/storage_service.dart';
import 'package:flutter_notification/model/providers/user_model.dart';
import 'package:flutter_notification/model/restaurant_search_history_model.dart';
import 'package:flutter_notification/model/search_restaurant_model.dart';
import 'package:flutter_notification/ui/shared/widget/custom_back_button.dart';
import 'package:flutter_notification/ui/shared/widget/custom_text_form_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class FooderSearchScreen extends StatefulWidget {
  const FooderSearchScreen({Key? key}) : super(key: key);

  @override
  _FooderSearchScreenState createState() => _FooderSearchScreenState();
}

class _FooderSearchScreenState extends State<FooderSearchScreen> {

  late final TextEditingController _searchController;
  late SearchRestaurantBloc _searchRestaurantBloc;
  final SearchRestaurantRepo _searchRestaurantRepo = SearchRestaurantRepo();
  bool _iskey = false;

  @override
  void initState() {
    _searchRestaurantBloc = BlocProvider.of<SearchRestaurantBloc>(context);
    _searchController = TextEditingController();
    Future(() => getHistory());
    _searchController.addListener(() {
      if(_searchController.text.isNotEmpty) {
        _searchRestaurantBloc.add(SearchResturantByKeyword(_searchController.text));
        setState(() {
          _iskey = true;
        });
      } else {
        getHistory();
        setState(() {
          _iskey = false;
        });
      }
    });
    super.initState();
  }


  void getHistory() {
    final auth = context.read<AuthModel>();
    if(auth.user == null) {
      _searchRestaurantBloc.add(const GetLocalSearchHistory());
    } else {
      _searchRestaurantBloc.add(const GetSearchHistory());
    }


  }

  void _deleteHistory(RestaurantSearchHistory history) async {
    final auth = context.read<AuthModel>();
    if(auth.user == null) {
      _searchRestaurantBloc.add(DelLocalSearchHistory(history));
    } else {
      _searchRestaurantBloc.add(DelSearchHistory(history.restaurantUniqueId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<AuthModel>(
            builder: (_, authModel,__) {
             return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: FooderCustomTextFormField(
                      enablePrefixIcon: true,
                      textEditingController: _searchController,
                      prefixIcon: Icon(Icons.search, color: Theme.of(context).secondaryHeaderColor,),
                      labelName: "",
                      placeholderName: "Search with keyword",
                    ),
                  ),
                  const Divider(),
                  if(_iskey)
                    liveSearch(),
                  if(!_iskey)
                    recentSearch(),
                ],
              );
            }
        ),
      ),
    );
  }

  Widget recentSearch() {
    return  Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent Searches',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontSize: 18,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: BlocConsumer<SearchRestaurantBloc, SearchRestaurantState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if(state.status == SearchRestaurantStatus.onGetHistory) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if(state.status == SearchRestaurantStatus.getHistorySuccess) {
                      if(state.historyList.isEmpty) {
                        return const Center(
                          child: Text('No History Found'),
                        );
                      }
                      return CustomScrollView(
                        slivers: [
                          for(var i = 0;  i < state.historyList.length; i++)
                            SliverToBoxAdapter(
                              child: searchHistoryCard(state.historyList[i]),
                            ),
                        ],
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchHistoryCard(RestaurantSearchHistory history) {
    return  InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/restaurant-info', arguments: {
          'uniqueId': history.restaurantUniqueId,
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.history_rounded, size: 24, color: Theme.of(context).secondaryHeaderColor,),
                  const SizedBox(width: 15,),
                  Text(history.historyName,
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        fontWeight: FontWeight.w400,
                      )
                  ),
                ],
              ),
            ),
             GestureDetector(
               onTap: () {
                 _deleteHistory(history);
                   print('del');
               },
               child: const Center(child: Icon(Icons.close_rounded))
             ),
          ],
        ),
      ),
    );
  }

  Widget liveSearch() {
    return  Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: BlocConsumer<SearchRestaurantBloc, SearchRestaurantState>(
            listener: (context, state) {},
            builder: (context, state) {
              if(state.status == SearchRestaurantStatus.onSearch) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if(state.status == SearchRestaurantStatus.searchSuccess) {
                if(state.restaurants.isEmpty) {
                  return const Center(
                    child: Text('No Restaurant Found'),
                  );
                }
                return CustomScrollView(
                  slivers: [
                    for(var i = 0;  i < state.restaurants.length; i++)
                      SliverToBoxAdapter(
                        child: liveSearchCard(state.restaurants[i]),
                      ),
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget liveSearchCard(SearchRestaurant restaurant) {
    return  InkWell(
      onTap: () async {
        final auth = context.read<AuthModel>();
        if(auth.user != null) {
          _searchRestaurantRepo.addSearchHistory(
            title: restaurant.restaurantName,
            restaurantUniqueId: restaurant.uniqueId,
          );
        } else {
          final rawHistoryList = await StorageService().getByKey('history_list') ?? '';
          final historyList = rawHistoryList == '' ? '' : jsonDecode(rawHistoryList);
          if(historyList.isEmpty) {
            final List<RestaurantSearchHistory> newHistoryList = [];
            newHistoryList.add(RestaurantSearchHistory(
                historyName: restaurant.restaurantName,
                restaurantUniqueId: restaurant.uniqueId)
            );
            final String historyListEncode = jsonEncode(newHistoryList);
            await StorageService().setStr('history_list', historyListEncode);
          } else {
            final newHistoryList = (historyList as List).map((e) => RestaurantSearchHistory.fromJson(e)).toList();
            final ifExist = newHistoryList.where((history) => history.restaurantUniqueId == restaurant.uniqueId).toList();
            if(ifExist.isEmpty) {
              newHistoryList.add(RestaurantSearchHistory(
                  historyName: restaurant.restaurantName,
                  restaurantUniqueId: restaurant.uniqueId));
              final String historyListEncode = jsonEncode(newHistoryList);
              await StorageService().setStr('history_list', historyListEncode);
            }
          }

        }
        Navigator.of(context).pushNamed('/restaurant-info', arguments: {
          'uniqueId': restaurant.uniqueId,
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 24, color: Theme.of(context).secondaryHeaderColor,),
                  const SizedBox(width: 15,),
                  Text(restaurant.restaurantName,
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        fontWeight: FontWeight.w400,
                      )
                  ),
                ],
              ),
            ),
            GestureDetector(
                onTap: () {
                  print('del');
                },
                child: Center(child: Icon(Icons.north_east,size: 24,  color: Theme.of(context).secondaryHeaderColor))
            ),
          ],
        ),
      ),
    );
  }
}
