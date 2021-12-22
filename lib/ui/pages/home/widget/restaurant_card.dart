import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class FooderRestaurantCard extends StatefulWidget {
  const FooderRestaurantCard({Key? key}) : super(key: key);

  @override
  _FooderRestaurantCardState createState() => _FooderRestaurantCardState();
}

class _FooderRestaurantCardState extends State<FooderRestaurantCard> {
  final _skeletonColor = Colors.grey[300];
  @override
  Widget build(BuildContext context) {

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

    return SkeletonAnimation(
      shimmerColor: Colors.white12,
      borderRadius: BorderRadius.circular(20),
      shimmerDuration: 1000,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
        ),
      ),
    );
  }
}
