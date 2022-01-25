import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification/bloc/restaurant-details/restaurant_details_bloc.dart';
import 'package:flutter_notification/ui/pages/restaurant/widget/restaurant_photo_wrapper.dart';
import 'package:flutter_notification/ui/shared/widget/custom_app_bar.dart';

class FooderViewAllImages extends StatefulWidget {
  const FooderViewAllImages({Key? key}) : super(key: key);
  static const routeName='/view-all-images';

  @override
  _FooderViewAllImagesState createState() => _FooderViewAllImagesState();
}

class _FooderViewAllImagesState extends State<FooderViewAllImages> {
  late final RestaurantDetailsBloc _restaurantDetailsBloc;
  @override
  void initState() {
    _restaurantDetailsBloc = BlocProvider.of<RestaurantDetailsBloc>(context);
    Future.delayed(Duration.zero, initPhotoPage);
    super.initState();
  }

  void initPhotoPage() {
    final arg = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final restaurantUniqueId = arg['restaurantUniqueId'];
    _restaurantDetailsBloc.add(FetchAllPhotos(restaurantUniqueId));
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RestaurantDetailsBloc, RestaurantDetailsState>(
      listener: (context, state) {},
      builder: (context, state) {
        final appbarTheme = Theme
            .of(context)
            .appBarTheme;

        if(state.status == RestaurantDetailStatus.loadRestaurantDataSuccess) {
          return SafeArea(
            child: Scaffold(
              appBar: screenAppBar(appbarTheme, appTitle: state.restaurant!.restaurantName),
              body: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      // childAspectRatio: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,


                    ),
                    itemCount: state.photos.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => FooderPhotoWrapper(
                                  galleryItems: state.photos,
                                  backgroundDecoration: const BoxDecoration(
                                    color: Colors.black,
                                  ),
                                  initialIndex: index,
                                ),
                              )
                          );
                        },
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: state.photos[index].imageUrl,
                          imageBuilder: (ctx, imageProvider) {
                            return Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                          placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                        ),
                      );
                    }
                ),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: screenAppBar(
              appbarTheme, appTitle: state.restaurant!.restaurantName),
          body: Container(),
        );
      }
    );
  }
}
