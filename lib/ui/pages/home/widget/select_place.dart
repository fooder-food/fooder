import 'dart:convert';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification/bloc/home/home_bloc.dart';
import 'package:flutter_notification/bloc/search_place/search_place_bloc.dart';
import 'package:flutter_notification/core/service/storage/storage_service.dart';
import 'package:flutter_notification/model/find_place_state_model.dart';
import 'package:flutter_notification/model/providers/select_place.dart';
import 'package:flutter_notification/model/providers/user_search_radius.dart';
import 'package:provider/provider.dart';



class FooderSelectPlaceScreen extends StatefulWidget {
  const FooderSelectPlaceScreen({Key? key}) : super(key: key);

  @override
  _FooderSelectPlaceScreenState createState() => _FooderSelectPlaceScreenState();
}

class _FooderSelectPlaceScreenState extends State<FooderSelectPlaceScreen> {
  late SearchPlaceBloc _seachPlaceBloc;
  late HomeBloc _homeBloc;
  bool firstView = false;
  String selectedPlace = '';

  @override
  void initState() {
    super.initState();
    initFirstView();
    _seachPlaceBloc = BlocProvider.of<SearchPlaceBloc>(context);
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    _seachPlaceBloc.add(const FetchStateBasedOnCountry('MY'));

  }

  void initFirstView() async {
    final String? _firstView = await StorageService().getByKey('first_view');
    setState(() {
      firstView = _firstView == null;
    });
  }

  void initSelectedPlace() async {
    final String? _selectedPlace = await StorageService().getByKey('select_place');
    if(_selectedPlace != null) {
      setState(() {
        selectedPlace = _selectedPlace;
      });

      final Map<String, dynamic> decoded = jsonDecode(selectedPlace) as Map<String, dynamic>;

      final FindPlaceState _selectedPlaceModel = FindPlaceState.fromJson(decoded);
      context.read<SelectPlaceModel>().updateState(_selectedPlaceModel);
    }
  }

  Widget header() {
    return firstView
        ? Container()
        :Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.close_rounded, size: 30,),
              ),
            ],
          )
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: SafeArea(
        child: Column(
          children: [
            header(),
            CountryListPick(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  title: Text('Select Country'),
                ),

                // if you need custome picker use this
                pickerBuilder: (context, countryCode){
                  return Container(
                    height: 50,
                    child: ListTile(
                      title: Text(countryCode!.name!),
                      leading: Image.asset(
                        countryCode.flagUri!,
                        package: 'country_list_pick',
                        width: 50,
                      ),
                    ),
                  );
                },

                // To disable option set to false
                theme: CountryTheme(
                  isShowFlag: true,
                  isShowTitle: true,
                  isShowCode: false,
                  isDownIcon: false,
                  showEnglishName: true,
                ),
                // Set default value
                //initialSelection: '+62',
                // or
                initialSelection: 'MY',
                onChanged: (code) {
                  _seachPlaceBloc.add(FetchStateBasedOnCountry(code!.code!));
                },
                // Whether to allow the widget to set a custom UI overlay
                useUiOverlay: true,
                // Whether the country list should be wrapped in a SafeArea
                useSafeArea: false
            ),
            const Divider(),
            BlocConsumer<SearchPlaceBloc, SearchPlaceState>(
              listener: (context, state) {

              },
              builder: (contexts, state) {
                if(state.status == SearchPlaceStatus.initial) {
                  return Container();
                }
                if(state.status == SearchPlaceStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () async {
                            final userRadiusModel = context.read<UserSearchRadiusModel>();
                            final selectedPlaceModel = context.read<SelectPlaceModel>();
                            selectedPlaceModel.updateState(state.states[index]);
                            selectedPlaceModel.updateLocationPriority(false);

                            _homeBloc.add(FetchAllRestaurant(
                              sort: userRadiusModel.selectedSorting,
                              filter: userRadiusModel.selectedCategoryIdList,
                              state: state.states[index].name,
                             )
                            );

                            final String? _firstView = await StorageService().getByKey('first_view');

                            final String? _selectePlace = await StorageService().getByKey('select_place');
                            if(_selectePlace == null) {
                              final selectPlaceEncode = jsonEncode(context.read<SelectPlaceModel>().selectedPlace!);
                              StorageService().setStr('select_place', selectPlaceEncode);
                            }
                            if(_firstView == null) {
                              final String firstViewEncode = jsonEncode(true);
                              await StorageService().setStr('first_view', firstViewEncode);
                              context.read<SelectPlaceModel>().updateLocationPriority(false);
                              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);

                            } else {
                              Navigator.of(context).pop();
                            }

                          },

                          trailing: context.read<SelectPlaceModel>().selectedPlace != null
                            && context.read<SelectPlaceModel>().selectedPlace!.id == state.states[index].id
                          ? Consumer<SelectPlaceModel>(
                            builder: (_, selectedPlaceModel,__ ) {
                              return Icon(
                                Icons.check_rounded,
                                color: Theme.of(context).primaryColor,
                              );
                            }
                          )
                          : null,
                          title: Text(state.states[index].name),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: state.states.length
                  ),
                );
              }
            )

          ],
        ),
      ),
    );
  }
}
