import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification/bloc/notification/notifications_bloc.dart';
import 'package:flutter_notification/ui/shared/widget/custom_app_bar.dart';

class FooderNotificationScreen extends StatefulWidget {
  static const String routeName='/notification';
  const FooderNotificationScreen({Key? key}) : super(key: key);

  @override
  _FooderNotificationScreenState createState() => _FooderNotificationScreenState();
}

class _FooderNotificationScreenState extends State<FooderNotificationScreen> {
  late final NotificationsBloc _notificationsBloc;
  @override
  void initState() {
    _notificationsBloc = BlocProvider.of<NotificationsBloc>(context);
    _notificationsBloc.add(const FetchNotifications());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appbarTheme = Theme.of(context).appBarTheme;
    return Scaffold(
      appBar: screenAppBar(appbarTheme, appTitle: 'Notification'),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: BlocConsumer<NotificationsBloc, NotificationsState>(
          listener: (context, state) {},
          builder: (context, state) {
            if(state.status == NotificationStatus.loadSuccess ||
              state.status == NotificationStatus.setRead
            ) {
              return ListView.separated(
                itemCount: state.notificationList.length,
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      if(state.notificationList[index].type.toLowerCase() == 'restaurant') {
                        _notificationsBloc.add(UpdateNotifications(state.notificationList[index].uniqueId));
                        Navigator.of(context).pushNamed('/restaurant-info', arguments: {
                          'uniqueId': state.notificationList[index].params,
                        });
                      }

                    },
                    leading: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: state.notificationList[index].icon,
                      imageBuilder: (ctx, imageProvider) {
                        return Container(
                          height: 50,
                          width: 50,
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
                      errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                    ),
                    trailing: state.notificationList[index].isRead == false
                    ? Container(
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                    ): null,
                    title: Text(state.notificationList[index].content,
                      style: Theme.of(context).textTheme.subtitle2,),
                    subtitle: Text(state.notificationList[index].diffTime,
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.w400,
                      ),),
                  );
                },
              );
            }
            if(state.status == NotificationStatus.onLoad) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
