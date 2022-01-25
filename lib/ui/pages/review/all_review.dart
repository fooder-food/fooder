import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification/bloc/restaurant-details/restaurant_details_bloc.dart';
import 'package:flutter_notification/ui/pages/restaurant/widget/restaurant_comment.dart';
import 'package:flutter_notification/ui/shared/widget/custom_app_bar.dart';

class FooderAllReviewScreen extends StatefulWidget {
  static const routeName = '/all-review';
  const FooderAllReviewScreen({Key? key}) : super(key: key);

  @override
  _FooderAllReviewScreenState createState() => _FooderAllReviewScreenState();
}

class _FooderAllReviewScreenState extends State<FooderAllReviewScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this,);

    Future.delayed(Duration.zero, initReview);
    super.initState();
  }

  void initReview() {
    final arg = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final index = arg["index"];
    _tabController.index = index;
    setState(() {
      _currentIndex = _tabController.index;
    });
  }
  
  void onPageChangeListener() {
    print('test');
  }

  @override
  Widget build(BuildContext context) {
    final appbarTheme = Theme.of(context).appBarTheme;

    return Scaffold(
      appBar: screenAppBar(appbarTheme, appTitle: 'Reviews'),
      body: Column(
        children: [
          BlocConsumer<RestaurantDetailsBloc, RestaurantDetailsState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1), // changes position of shadow
                      ),
                    ]
                ),
                padding: const EdgeInsets.only(top: 8,),
                child: TabBar(
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  controller: _tabController,
                  indicatorColor: Theme.of(context).primaryColor,
                  tabs: [
                    Tab(
                      child: tabBarItem(
                          state.restaurant!.comments.length,
                          'All',
                          0),
                    ),
                    Tab(
                      icon: tabBarItem(
                        state.restaurant!.comments.where((item) => item.type.toUpperCase() == 'GOOD').toList().length,
                        'Delicious',
                        1),
                    ),
                    Tab(
                      icon: tabBarItem(
                        state.restaurant!.comments.where((item) => item.type.toUpperCase() == 'NORMAL').toList().length,
                        'Not Bad',
                        2),
                    ),
                    Tab(
                      icon: tabBarItem(
                        state.restaurant!.comments.where((item) => item.type.toUpperCase() == 'BAD').toList().length,
                        'Normal',
                        3),
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: BlocConsumer<RestaurantDetailsBloc, RestaurantDetailsState>(
              listener: (context, state) {},
              builder: (context, state) {
                return TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children:  <Widget>[
                    ListView(
                      children: [
                        FooderCommentCard(
                          restaurantUnique: state.restaurant!.uniqueId,
                          restaurantName: state.restaurant!.restaurantName,
                          type: 'ALL',
                          comments: state.restaurant!.comments,
                        ),
                      ],
                    ),
                    ListView(
                      children: [
                        FooderCommentCard(
                          restaurantUnique: state.restaurant!.uniqueId,
                          restaurantName: state.restaurant!.restaurantName,
                          type: 'ALL',
                          comments: state.restaurant!.comments.where((item) => item.type.toUpperCase() == 'GOOD').toList(),
                        ),
                      ],
                    ),
                    ListView(
                      children: [
                        FooderCommentCard(
                          restaurantUnique: state.restaurant!.uniqueId,
                          restaurantName: state.restaurant!.restaurantName,
                          type: 'ALL',
                          comments: state.restaurant!.comments.where((item) => item.type.toUpperCase() == 'NORMAL').toList(),
                        ),
                      ],
                    ),
                    ListView(
                      children: [
                        FooderCommentCard(
                          restaurantUnique: state.restaurant!.uniqueId,
                          restaurantName: state.restaurant!.restaurantName,
                          comments: state.restaurant!.comments.where((item) => item.type.toUpperCase() == 'BAD').toList(),
                          type: 'ALL',
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),

        ],
      ),
    );
  }

  Widget tabBarItem(int count, String text, int index) {
    final textTheme = Theme.of(context).textTheme;
   return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$count',
          style: textTheme.subtitle2!.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: _currentIndex == index
                ? Theme.of(context).primaryColor
                : Colors.black,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          text,
          style: textTheme.subtitle2!.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: _currentIndex == index
                ? Theme.of(context).primaryColor
                : Colors.black,
          ),
        ),
      ],
    );
  }
}
