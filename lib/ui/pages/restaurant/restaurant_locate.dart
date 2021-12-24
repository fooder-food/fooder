import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification/bloc/restaurant-location/restaurant_location_bloc.dart';
import 'package:flutter_notification/model/google_autocomplete_place_model.dart';
import 'package:flutter_notification/ui/shared/widget/custom_back_button.dart';
import 'package:flutter_notification/ui/shared/widget/custom_text_form_field.dart';

class FooderRestaurantLocateScreen extends StatefulWidget {
  static const routeName = '/restaurant-add-location';
  const FooderRestaurantLocateScreen({Key? key}) : super(key: key);

  @override
  State<FooderRestaurantLocateScreen> createState() => _FooderRestaurantLocateScreenState();
}

class _FooderRestaurantLocateScreenState extends State<FooderRestaurantLocateScreen> {

  late final RestaurantLocationBloc _restaurantLocationBloc;
  late final TextEditingController _searchAddressTextEditingController;
  @override
  void initState() {
    _restaurantLocationBloc = BlocProvider.of<RestaurantLocationBloc>(context);
    _searchAddressTextEditingController = TextEditingController();
    _searchAddressTextEditingController.addListener(_searchFieldListener);
    super.initState();
  }

  void _searchFieldListener() {
    final keyword = _searchAddressTextEditingController.text;
    final countryCode = _restaurantLocationBloc.state.selectedCountryIsNull ? null : _restaurantLocationBloc.state.selectedCountry!.cca2;
    _restaurantLocationBloc.add(GoogleSearchPlaces(keyword, countryCode));
  }

  @override
  Widget build(BuildContext context) {
    final appbarTheme = Theme.of(context).appBarTheme;
    final textTheme =Theme.of(context).textTheme;
    return Scaffold(
      appBar: screenAppBar(appbarTheme),
      body: Column(
        children: [
         selectionCountrySection(textTheme),
         searchAddressTextField(),
         placesList(textTheme),
        ],
      ),
    );
  }

  Widget searchAddressTextField() {
    return Container(
      padding: const EdgeInsets.only(
        left: 5,
        right: 5,
        top: 10,
      ),
      child: FooderCustomTextFormField(
        labelName: '',
        placeholderName: 'Enter Restaurant Address',
        textInputAction: TextInputAction.go,
        enablePrefixIcon: true,
        textEditingController: _searchAddressTextEditingController,
        prefixIcon: const Icon(Icons.gps_fixed_rounded, color: Colors.grey,),
        
      ),
    );
  }

  Widget placesList(TextTheme textTheme) {
    return BlocBuilder<RestaurantLocationBloc, RestaurantLocationState>(
        builder: (context, state) {
          List<GoogleAutoCompletePlace> _places = state.places;
          return Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.grey,
                ),
                itemCount: _places.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      final String placeId = _places[index].placeId;
                      final String address = _places[index].completeStructure.secondaryText;
                      _restaurantLocationBloc.add(SelectAddress(placeId, address));
                      Navigator.of(context).pop();
                    },

                    title: Text(
                      _places[index].completeStructure.mainText,
                      style: textTheme.subtitle1,
                    ),
                    subtitle: Text(
                      _places[index].completeStructure.secondaryText,
                      style: textTheme.subtitle2!.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  );
                },
              ));
        }
    );
  }

  Widget selectionCountrySection(TextTheme textTheme) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed('/search-country');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                )
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<RestaurantLocationBloc, RestaurantLocationState>(
                builder: (context, state) {
                  final country = state.selectedCountry;
                  if(country != null) {
                    // return Text(
                    //   'Searching in ${country.name.official}',
                    //   style: textTheme.subtitle1,
                    // );
                    return RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(

                                text: 'Searching in ',
                                style: textTheme.subtitle1!.copyWith(
                                  fontWeight: FontWeight.normal,
                                )
                            ),
                            TextSpan(
                              text: country.name.official,
                              style: textTheme.subtitle2,
                            )
                          ]
                      ),
                    );
                  }
                  return Text('Select Your Country',
                    style: textTheme.subtitle1!.copyWith(
                      fontWeight: FontWeight.normal,
                    ),);
                },
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget screenAppBar(AppBarTheme appbarTheme) {
    return AppBar(
      leading: CustomBackbutton(),
      elevation: 0,
      bottom: PreferredSize(
        child: Container(
          color: appbarTheme.foregroundColor,
          height: 0.5,
        ),
        preferredSize: const Size.fromHeight(0.2),
      ),
      backgroundColor: appbarTheme.backgroundColor,
      title: Text('Restaurant Location', style: appbarTheme.titleTextStyle,),
    );
  }
}
