import 'package:flutter/material.dart';
import 'package:flutter_notification/ui/shared/widget/custom_back_button.dart';
import 'package:flutter_notification/ui/shared/widget/custom_text_form_field.dart';
import 'package:flutter_svg/svg.dart';

class FooderSearchScreen extends StatefulWidget {
  const FooderSearchScreen({Key? key}) : super(key: key);

  @override
  _FooderSearchScreenState createState() => _FooderSearchScreenState();
}

class _FooderSearchScreenState extends State<FooderSearchScreen> {

  late final TextEditingController _searchController;
  bool _iskey = false;

  @override
  void initState() {
    _searchController = TextEditingController();
    _searchController.addListener(() {
      if(_searchController.text.isNotEmpty) {
        setState(() {
          _iskey = true;
        });
      } else {
        setState(() {
          _iskey = false;
        });
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: FooderCustomTextFormField(
                enablePrefixIcon: true,
                textEditingController: _searchController,
                prefixIcon: Icon(Icons.search, color: Theme.of(context).secondaryHeaderColor,),
                labelName: "",
                placeholderName: "Search with keyword",
              ),
            ),
            const Divider(),
            if(_iskey)
             liveSearch(),
            if(!_iskey)
             recentSearch(),
          ],
        ),
      ),
    );
  }

  Widget recentSearch() {
    return  Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent Searches',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontSize: 18,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: CustomScrollView(
                  slivers: [
                    for(var i = 0;  i < 20; i++)
                      SliverToBoxAdapter(
                        child: searchHistoryCard(),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchHistoryCard() {
    return  InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.history_rounded, size: 24, color: Theme.of(context).secondaryHeaderColor,),
                  const SizedBox(width: 15,),
                  Text('mcd',
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        fontWeight: FontWeight.w400,
                      )
                  ),
                ],
              ),
            ),
             GestureDetector(
               onTap: () {
                   print('del');
               },
               child: const Center(child: Icon(Icons.close_rounded))
             ),
          ],
        ),
      ),
    );
  }

  Widget liveSearch() {
    return  Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: CustomScrollView(
            slivers: [
              for(var i = 0;  i < 20; i++)
                SliverToBoxAdapter(
                  child: liveSearchCard(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget liveSearchCard() {
    return  InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 24, color: Theme.of(context).secondaryHeaderColor,),
                  const SizedBox(width: 15,),
                  Text('mcd',
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        fontWeight: FontWeight.w400,
                      )
                  ),
                ],
              ),
            ),
            GestureDetector(
                onTap: () {
                  print('del');
                },
                child: Center(child: Icon(Icons.north_east,size: 24,  color: Theme.of(context).secondaryHeaderColor))
            ),
          ],
        ),
      ),
    );
  }
}
