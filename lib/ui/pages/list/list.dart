import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification/model/providers/navigator_model.dart';
import 'package:flutter_notification/model/providers/user_model.dart';
import 'package:flutter_notification/ui/shared/widget/custom_button.dart';
import 'package:provider/provider.dart';

class FooderMyListScreen extends StatefulWidget {
  const FooderMyListScreen({Key? key}) : super(key: key);

  @override
  _FooderMyListScreenState createState() => _FooderMyListScreenState();
}

class _FooderMyListScreenState extends State<FooderMyListScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<AuthModel>(
          builder: (_, auth,__) {
            if(auth.user == null) {
              if(context.watch<NavigatorModel>().index == 3) {
                Future(() =>
                    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false)
                );
              }
              context.read<NavigatorModel>().resetIndex();
              return Container();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Center(
                      child: Text(
                        '${auth.user!.user!.username}\'s My List',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                ),
                const Divider(),
                createListButton(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: CustomScrollView(
                      slivers: [
                        for(var index = 0; index < 20; index++)
                          SliverToBoxAdapter(
                            child: ListCard(),
                          ),
                      ],
                    )
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget createListButton() {
    return Container(
        width: 200,
        height: 40,
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            primary: Theme.of(context).primaryColor,
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/add-list');
          },
          child: Row(
            children: [
              const Icon(Icons.add, color: Colors.white),
              Text(
                'Create New My List',
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        )
    );
  }

  Widget ListCard() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text(
                'testing',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                fontSize: 18
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text(
              'subtitle',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
          ),
          CachedNetworkImage(
            imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png",
            imageBuilder: (context, imageProvider) => Container(
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
              ),
            )),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.bookmark_border, color: Colors.grey[400],),
              ],
            ),
          )
        ],
      ),
    );
  }
}
