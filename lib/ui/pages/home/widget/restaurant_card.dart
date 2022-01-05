import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification/bloc/home/home_bloc.dart';
import 'package:flutter_notification/model/restaurant_model.dart';
import 'package:flutter_notification/ui/pages/unknown/unknown.dart';
import 'package:skeleton_text/skeleton_text.dart';

class FooderRestaurantCard extends StatefulWidget {
  FooderRestaurantCard({
    Key? key,
    required this.state,
    required this.index,
  }) : super(key: key);
  final HomeState state;
  int index;
  @override
  _FooderRestaurantCardState createState() => _FooderRestaurantCardState();
}

class _FooderRestaurantCardState extends State<FooderRestaurantCard> {
  final _skeletonColor = Colors.grey[300];

  void _routeToRestaurantInfo(Restaurant restaurant) {
    Navigator.of(context).pushNamed('/restaurant-info', arguments: {
      'uniqueId': restaurant.uniqueId,
    });
  }

  String distanceFormatter(double distance) {
    if(distance < 1000) {
      return '${distance.round()}m';
    }
    double totalDistance = distance / 1000;
    int distanceDecimal = totalDistance.truncate();
    double distancePoint = totalDistance - distanceDecimal;
    return '${totalDistance.toStringAsFixed(2)}km';
  }
  @override
  Widget build(BuildContext context) {
    if(widget.state.status == HomeStatus.onLoadRestaurantData) {
      return onLoadingSkeleton();
    } else if(widget.state.status == HomeStatus.loadRestaurantDataSuccess) {
      return restaurantContainer();
    }
    return FooderUnknownScreen();
  }

  Widget restaurantContainer() {
    final restaurant = widget.state.restaurants[widget.index];
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {
        _routeToRestaurantInfo(restaurant);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
            )
        ),
        child: Column(
          children: [
            Container(
              height: 130,
              decoration: BoxDecoration(
                color: _skeletonColor,
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(restaurant.restaurantName, style: textTheme.subtitle2,),
                              const SizedBox(
                                height: 5,
                              ),
                              Text('${restaurant.state} - ${distanceFormatter(restaurant.distance)}', style: textTheme.subtitle2!.copyWith(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),),
                            ],
                          )
                        ),
                        Text(widget.state.restaurants[widget.index].rating.toString(), style: textTheme.headline2,),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                              Icons.visibility_rounded,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                              const SizedBox(
                                width: 2,
                              ),
                            Expanded(
                                  child: Text(
                                    '${restaurant.view}',
                                    style: textTheme.headline2!.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        size: 18,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Expanded(
                          child: Text(
                            '${restaurant.comments}',
                            style: textTheme.headline2!.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                      )
                    ],
                  ),
                ),

                      ],
                    )
                  ],
                )
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget onLoadingSkeleton() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
          )
      ),
      child: Column(
        children: [
          SkeletonAnimation(
            shimmerColor: Colors.white12,
            borderRadius: BorderRadius.circular(20),
            shimmerDuration: 1000,
            child: Container(
              height: 130,
              decoration: BoxDecoration(
                color: _skeletonColor,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonAnimation(
                          shimmerColor: Colors.white12,
                          borderRadius: BorderRadius.circular(20),
                          shimmerDuration: 1000,
                          child: Container(
                            height: 10,
                            decoration: BoxDecoration(
                              color: _skeletonColor,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SkeletonAnimation(
                          shimmerColor: Colors.white12,
                          borderRadius: BorderRadius.circular(20),
                          shimmerDuration: 1000,
                          child: Container(
                            height: 10,
                            width: 50,
                            decoration: BoxDecoration(
                              color: _skeletonColor,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  SkeletonAnimation(
                                    shimmerColor: Colors.white12,
                                    borderRadius: BorderRadius.circular(20),
                                    shimmerDuration: 1000,
                                    child: ClipOval(
                                      child: Container(
                                        width: 15,
                                        height: 15,
                                        color: _skeletonColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Expanded(
                                    child: SkeletonAnimation(
                                      shimmerColor: Colors.white12,
                                      borderRadius: BorderRadius.circular(20),
                                      shimmerDuration: 1000,
                                      child: Container(
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: _skeletonColor,
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  SkeletonAnimation(
                                    shimmerColor: Colors.white12,
                                    borderRadius: BorderRadius.circular(20),
                                    shimmerDuration: 1000,
                                    child: ClipOval(
                                      child: Container(
                                        width: 15,
                                        height: 15,
                                        color: _skeletonColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Expanded(
                                    child: SkeletonAnimation(
                                      shimmerColor: Colors.white12,
                                      borderRadius: BorderRadius.circular(20),
                                      shimmerDuration: 1000,
                                      child: Container(
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: _skeletonColor,
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  // rating skeleton
                  SkeletonAnimation(
                    shimmerColor: Colors.white12,
                    borderRadius: BorderRadius.circular(20),
                    shimmerDuration: 1000,
                    child: Container(
                      margin: const EdgeInsets.only(
                        left: 5,
                      ),
                      decoration: BoxDecoration(
                        color: _skeletonColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: 30,
                      height: 30,
                    ),
                  ),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
