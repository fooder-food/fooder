import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_notification/bloc/restaurant-location/restaurant_location_bloc.dart';
import 'package:flutter_notification/bloc/search-country/search_country_bloc.dart';
import 'package:flutter_notification/model/country_model.dart';
import 'package:flutter_notification/ui/shared/widget/custom_back_button.dart';
import 'package:flutter_notification/ui/shared/widget/custom_text_form_field.dart';
import 'package:flutter_notification/ui/shared/widget/loading.dart';

class FooderSearchCountryScreen extends StatefulWidget {
  static const routeName = '/search-country';
  const FooderSearchCountryScreen({Key? key}) : super(key: key);

  @override
  _FooderSearchCountryScreenState createState() => _FooderSearchCountryScreenState();
}

class _FooderSearchCountryScreenState extends State<FooderSearchCountryScreen> {

  late final SearchCountryBloc _searchCountryBloc;
  late final RestaurantLocationBloc _restaurantLocationBloc;
  final TextEditingController _searchFieldTextEditingController = TextEditingController();
  late final FocusNode _searchFieldFocusNode;
  @override
  void initState() {
    _searchCountryBloc = BlocProvider.of<SearchCountryBloc>(context);
    _restaurantLocationBloc = BlocProvider.of<RestaurantLocationBloc>(context);
    _searchCountryBloc.add(FetchAllCountry());
    _searchFieldFocusNode = FocusNode();
    _searchFieldTextEditingController.addListener(_searchFieldListener);
    super.initState();
  }

  @override
  void dispose() {
    _searchFieldTextEditingController.dispose();
    _searchFieldFocusNode.dispose();
    super.dispose();
  }

  void _searchFieldListener() {
    final keyword = _searchFieldTextEditingController.text;
    _searchCountryBloc.add(SearchCountry(keyword));
  }

  void _onSelectCountry(Country country) {
    _searchFieldFocusNode.unfocus();
    _restaurantLocationBloc.add(SelectCountry(country));
    Navigator.of(context).pop();
  }



  @override
  Widget build(BuildContext context) {
    final appbarTheme = Theme.of(context).appBarTheme;
    return Scaffold(
      appBar: screenAppBar(appbarTheme),
      body: RefreshIndicator(
        onRefresh: () async {
          _searchCountryBloc.add(ReFetchAllCountry());
          await Future.delayed(const Duration(seconds: 3));
        },
        child: BlocBuilder<SearchCountryBloc, SearchCountryState>(
          builder: (context, state) {
            if(state.status == CountryLoadingStatus.loading) {
              return const FooderLoadingWidget();
            }
            return searchCountryBody();
          },
        )
      ),
    );
  }

  Widget searchCountryBody() {
    return Column(
      children: [
        searchCountryTextField(),
        countryList(),

      ],
    );
  }

  Widget searchCountryTextField() {
    return Container(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 10,
      ),
      child: FooderCustomTextFormField(
        focusNode: _searchFieldFocusNode,
        prefixIcon: const Icon(Icons.search, color: Colors.grey,),
        suffixIcon: GestureDetector(
          onTap: () {
           _searchFieldTextEditingController.text = '';
          },
          child: const Icon(Icons.cancel),
        ),
        textEditingController: _searchFieldTextEditingController,
        enablePrefixIcon: true,
        enableSuffixIcon: true,
        labelName: '',
        placeholderName: 'Search Your Country',
      ),
    );
  }

  Widget countryList() {
    return BlocBuilder<SearchCountryBloc, SearchCountryState>(
      builder: (BuildContext context, SearchCountryState state) {
        List<Country> _countries = [];

        if(state.status == CountryLoadingStatus.success || state.status == CountryLoadingStatus.searchSuccess) {
          _countries = state.status == CountryLoadingStatus.success ?  state.countries: state.selectedCountries;
          return Expanded(
              child: ListView.builder(
                itemCount: _countries.length,
                itemExtent: 50,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      _onSelectCountry(_countries[index]);
                    },
                    leading: SizedBox(
                      width: 50,
                      height: 30,
                      child: SvgPicture.network(_countries[index].flags.svg, ),
                    ),
                    title: Text(
                      _countries[index].name.official,
                    ),
                  );
                },
              ));
        }

        return Container();
      },
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
      title: Text('Search Country', style: appbarTheme.titleTextStyle,),
    );
  }
}
