
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification/bloc/add-list/add_list_bloc.dart';
import 'package:flutter_notification/ui/shared/widget/custom_app_bar.dart';

class FooderEditListScreen extends StatefulWidget {
  static const String routeName = '/edit-list';
  const FooderEditListScreen({Key? key}) : super(key: key);

  @override
  _FooderEditListScreenState createState() => _FooderEditListScreenState();
}

class _FooderEditListScreenState extends State<FooderEditListScreen> {
  bool _isMoveEnable = false;
  late final AddListBloc _addListBloc;
  @override
  void initState() {
    _addListBloc = BlocProvider.of<AddListBloc>(context);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   final appbarTheme = Theme.of(context).appBarTheme;


    return SafeArea(
      child: Scaffold(
        appBar: screenAppBar(
          appbarTheme,
          appTitle: 'Edit MyList',
          actions: [
            IconButton(
                onPressed: () async {
                  _addListBloc.add(ReOrderConfirm(_addListBloc.state.info!.uniqueId));
                },
                icon: Icon(
                  Icons.check_rounded,
                  color: Theme.of(context).secondaryHeaderColor,
                )
            )
          ]
        ),
        body: BlocConsumer<AddListBloc, AddListState>(
          listener: (context, state) {
            if(state.status == CollectionListStatus.reorderSuccess) {
              _addListBloc.add(FetchListInfo(uniqueId: _addListBloc.state.info!.uniqueId));
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            return ReorderableListView.builder(
              itemCount: state.info!.items.length,
              buildDefaultDragHandles: _isMoveEnable,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  key: Key(state.info!.items[index].order.toString()),
                  leading: Container(
                    margin: const EdgeInsets.only(top: 5),
                      child: GestureDetector(
                        onTap: () async {
                          showDialog(
                              context: context,
                              builder: (context) =>  AlertDialog(
                                content: const Text('Did you want delete your item?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      _addListBloc.add(DeleteListItem(
                                        itemUniqueId: state.info!.items[index].uniqueId,
                                        listUniqueId: state.info!.uniqueId,
                                      ));
                                      Navigator.of(context).pop(true);
                                    },
                                    child: const Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: const Text('No'),
                                  ),
                                ],
                              ),
                          );
                        },
                        child: Icon(Icons.remove_circle_rounded,
                          size: 30,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: state.info!.items[index].restaurant.image,
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
                            titleContent(state.info!.items[index].restaurant.name),
                            const SizedBox(
                              height: 5,
                            ),
                            ratingContent(state.info!.items[index].restaurant.rating.toDouble().toString()),
                          ],
                        ),
                      )
                    ],
                  ),
                  trailing: GestureDetector(
                      onTap: () {
                        print('test');
                        setState(() {
                          _isMoveEnable = true;
                        });
                      },
                      onDoubleTapCancel: () {
                        setState(() {
                          _isMoveEnable = false;
                        });
                      },
                      child: const Icon(Icons.menu_rounded)
                  ),
                );
              },
              onReorder: (int oldIndex, int newIndex) {
                _addListBloc.add(ReOrderListItem(oldIndex: oldIndex, newIndex: newIndex));

                // setState(() {
                //   if (oldIndex < newIndex) {
                //     newIndex -= 1;
                //   }
                //   final int item = _items.removeAt(oldIndex);
                //   _items.insert(newIndex, item);
                // });
              },
            );
          },
        ),
      ),
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
