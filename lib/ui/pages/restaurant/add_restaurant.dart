import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification/core/service/geo/geo_location.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_notification/bloc/add-restaurant/add_restaurant_bloc.dart';
import 'package:flutter_notification/bloc/restaurant-location/restaurant_location_bloc.dart';
import 'package:flutter_notification/model/providers/user_model.dart';
import 'package:flutter_notification/model/restaurant_category_model.dart';
import 'package:flutter_notification/ui/shared/widget/custom_app_bar.dart';
import 'package:flutter_notification/ui/shared/widget/custom_button.dart';
import 'package:flutter_notification/ui/shared/widget/custom_text_form_field.dart';
import 'package:flutter_notification/ui/shared/widget/loading.dart';
import 'package:provider/provider.dart';

class FooderAddRestaurantScreen extends StatefulWidget {
  static const String routeName = '/add-restaurant';
  const FooderAddRestaurantScreen({Key? key}) : super(key: key);

  @override
  State<FooderAddRestaurantScreen> createState() => _FooderAddRestaurantScreenState();
}

class _FooderAddRestaurantScreenState extends State<FooderAddRestaurantScreen> {
  final _formkey = GlobalKey<FormState>();
  late AddRestaurantBloc _addRestaurantBloc;
  late RestaurantLocationBloc _restaurantLocationBloc;
  late TextEditingController _addressFieldTextEditingController;
  late TextEditingController _restaurantNameController;
  late TextEditingController _phoneController;
  final _geolocationService = GeoLocationService();

  @override
  void initState() {
    _addRestaurantBloc = BlocProvider.of<AddRestaurantBloc>(context);
    _restaurantLocationBloc = BlocProvider.of<RestaurantLocationBloc>(context);
    _addressFieldTextEditingController = TextEditingController();
    _restaurantNameController = TextEditingController();
    _phoneController = TextEditingController();
    _restaurantNameController.addListener(restaurantNameListener);
    _phoneController.addListener(phoneListener);
    _addRestaurantBloc.add(FetchRestaurantCategoriesEvent());
    super.initState();
  }

  @override
  void dispose() {
    _addressFieldTextEditingController.dispose();
    _restaurantNameController.dispose();
    super.dispose();
  }

  void restaurantNameListener() {
    _addRestaurantBloc.add(SetRestaurantName(_restaurantNameController.text));
  }
  void phoneListener() {
    _addRestaurantBloc.add(SetRestaurantPhoneNumber(_phoneController.text));
  }

  void _changeSearchAddressValue() {
    final place = _restaurantLocationBloc.state.selectedPlace;
    if(place != null) {
      _addRestaurantBloc.add(GetAdressEvent(place));
      _addressFieldTextEditingController.text = place.address;
    }

  }


  void _showActionSheet(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    showAdaptiveActionSheet(
      context: context,
      title: Text('Select Action', style: textTheme.subtitle1,),
      actions: <BottomSheetAction>[
        BottomSheetAction(
            leading: Container(
              padding: const EdgeInsets.only(right: 10),
              child: const Icon(Icons.location_searching, color: Colors.grey,),
            ),
            title: Text('Search Address', style: textTheme.subtitle1,),
            onPressed: () {
              Navigator.of(context).pushNamed('/restaurant-add-location');
            }
        ),
        BottomSheetAction(
            leading: Container(
              padding: const EdgeInsets.only(right: 10),
              child: const Icon(Icons.map, color: Colors.grey,),
            ),
            title: Text('Google Map', style: textTheme.subtitle1,),
            onPressed: () async {
              try {
                await _geolocationService.determinePosition(context);
                Navigator.of(context).pushNamed('/map-screen');
              } catch(e) {
                print(e);
              }

            }
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final appbarTheme = Theme.of(context).appBarTheme;
    return Scaffold(
      appBar: screenAppBar(appbarTheme, appTitle: "Add Restaurant"),
      body: addRestaurantForm(context),
    );
  }


  Widget addRestaurantForm(BuildContext context) {
      return SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Consumer<AuthModel>(
            builder: (_, auth, __){
              if(auth.user == null) {
                Future(() =>
                    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false)
                );
              }
              return BlocConsumer<AddRestaurantBloc, AddRestaurantState>(
                listener: (context, state) {
                  if(state.status == AddRestaurantFormStatus.failed) {
                    Navigator.of(context).pushNamed('/error');
                  }
                },
                builder: (context, state) {
                  if(state.status == AddRestaurantFormStatus.onLoad) {
                    return  const FooderLoadingWidget();
                  }
                  return Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Form(
                        key: _formkey,
                        child:  Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:  [
                                getRestaurantName(),
                                getAddressTextFormField(context),
                                getCategoriesList(state.categories),
                                getRestaurantPhoneNumber(),
                                addRestaurantSubmitButton(),
                                ElevatedButton(onPressed: () {
                                  context.read<AuthModel>().logoutUser();
                                }, child: const Text('log out')),
                              ],
                            ),
                          ),
                        ),
                      )
                  );
                },
              );
            },
          ),
        ),
      );


  }

  Widget getRestaurantName() {
    return  FooderCustomTextFormField(
      labelName: 'Restaurant Name',
      textEditingController: _restaurantNameController,
      validator: (value) {
        if(value is String) {
          value = value.trim();
          if(value.isEmpty) {
            return 'restaurant name cannot empty';
          }
        }
      },
    );
  }

  Widget getAddressTextFormField(BuildContext context) {
    return  BlocBuilder<RestaurantLocationBloc, RestaurantLocationState>(
      builder: (context, state) {
        if(state.status == getAddressStatus.findPlaceDetailSuccess) {
          _changeSearchAddressValue();
        }
        return FooderCustomTextFormField(
          labelName: 'Restaurant Address',
          textEditingController: _addressFieldTextEditingController,
          readonly: true,
          maxLines: 4,
          validator: (value) {
            if (value is String) {
              value = value.trim();
              if (value.isEmpty) return "address cannot empty";
            }
          },
          addOnsWidget: [
            Material(
              child: Ink(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,

                ),
                child: InkWell(
                    onTap: () async {
                      _showActionSheet(context);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.add_location_alt_outlined,
                          size: 30,
                          color: Colors.black54,
                        ),
                      ],
                    )
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget getCategoriesList(List<RestaurantCategory> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(
            top: 10,
          ),
          child: Text(
            "Cuisine",
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
            ) ,
          ),
        ),
        Container(
            height: 130,
            margin: const EdgeInsets.symmetric(vertical: 15),
            child: ListView.builder(
              itemCount: categories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return categoryCard(categories[index]);
              },
            )
        ),
      ],
    );


  }

  Widget categoryCard(RestaurantCategory category) {
    final Widget svgIcon = SvgPicture.network(
      category.categoryIcon,
    );
    return  GestureDetector(
      onTap: () {
        _addRestaurantBloc.add(SetSelectedCategoryEvent(category.uniqueId));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocBuilder<AddRestaurantBloc, AddRestaurantState>(
              builder: (context, state) {
                bool isSelected = state.selectedCategoyId == category.uniqueId;
                return Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? Colors.red : Colors.grey,
                        width: isSelected ? 1: 0.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 15,
                          offset: const Offset(5, 10), // changes position of shadow
                        ),
                      ]
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: svgIcon,
                      ),
                      isSelected ?
                      const Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(
                          Icons.check_rounded,
                          color: Colors.red,
                          size: 30,
                      ),
                      ) : Container(),
                    ],
                  ),
                );
              }
            ),
            const SizedBox(
              height: 10,
            ),
            Text(category.categoryName),
          ],
        ),
      ),
    );
  }

  Widget getRestaurantPhoneNumber() {
    return Row(
      children: [
        Expanded(child: FooderCustomTextFormField(
          labelName: 'Restaurant Phone Number',
          prefixWidget: [
            CountryCodePicker(
              onChanged:(value) => _addRestaurantBloc.add(SetRestaurantPhonePrefix(value.toString())),
              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
              initialSelection: 'MY',

            )
          ],
          textInputType: TextInputType.phone,
          textEditingController: _phoneController,
        ),),
      ],
    );
  }

  Widget addRestaurantSubmitButton() {
    return FooderCustomButton(
        isBorder:  false,
        buttonContent: 'Add Restaurant',
        onTap: () {
          if (_formkey.currentState!.validate()) {
            _addRestaurantBloc.add(SubmitAddRestaurantForm());
          }
        }
    );
  }

}
