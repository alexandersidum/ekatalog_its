import 'package:e_catalog/constants.dart';
import 'package:e_catalog/models/item.dart';
import 'package:e_catalog/models/item_search.dart';
import 'package:e_catalog/utilities/item_services.dart';
import 'package:flutter/material.dart';
import 'package:e_catalog/components/item_tile.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class SearchedItemScreen extends StatefulWidget {
  @override
  _SearchedItemScreenState createState() => _SearchedItemScreenState();
}

class _SearchedItemScreenState extends State<SearchedItemScreen> {
  IconData actionIcon = Icons.search;
  ItemService _itemService = ItemService();
  Widget appBarTitle = Text('Home');
  bool onSearch = false;
  String searchQuery;
  bool isLoading = true;
  List<Item> searchedItem;
  ItemSearch _itemSearch;
  sortedBy sorted = sortedBy.Default;

  //ITEM SEARCH MODE 0 = Kategori , Mode 1 = Search
  @override
  void initState() {
    _itemSearch = context.read<ItemSearch>();
    if (_itemSearch.mode == 0) {
      print("kategori");
      fetchItemByCategory(_itemSearch.keyword);
    } else {
      print("search");
      fetchItemSearched(_itemSearch.keyword);
    }
    super.initState();
  }

  void manageItems() {
    switch (sorted) {
      case sortedBy.HargaTerendah:
        searchedItem.sort((a, b) {
          return a.price.compareTo(b.price);
        });
        break;
      case sortedBy.HargaTertinggi:
        searchedItem.sort((a, b) {
          return b.price.compareTo(a.price);
        });
        break;
      //TODO Terbaru terlamanya sepertinya kebalik
      case sortedBy.Terbaru:
        searchedItem.sort((a, b) {
          return a.creationDate.compareTo(b.creationDate);
        });
        break;
      case sortedBy.Terlama:
        searchedItem.sort((a, b) {
          return b.creationDate.compareTo(a.creationDate);
        });
        break;
      case sortedBy.Default:
        searchedItem = searchedItem;
        break;
      default:
        searchedItem = searchedItem;
    }
    setState(() {});
  }

  fetchItemSearched(String keyword) async {
    print("Fetching $keyword");
    setState(() {
      isLoading = true;
    });
    searchedItem =
        await _itemService.getItemListBySearch(keyword.trim().toLowerCase());
    setState(() {
      isLoading = false;
    });
  }

  fetchItemByCategory(String category) async {
    setState(() {
      isLoading = true;
    });
    searchedItem =
        await _itemService.getItemListByCategory(category.trim().toLowerCase());
    setState(() {
      isLoading = false;
    });
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      leadingWidth: 50,
      titleSpacing: 0,
      toolbarHeight: MediaQuery.of(context).size.height / 11,
      elevation: 0,
      backgroundColor: kBlueMainColor,
      title: Container(
        height: MediaQuery.of(context).size.height / 16,
        child: TextField(
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 5, left: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(3)),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: 'Search'),
          onSubmitted: (value) {
            context.read<ItemSearch>().setKeyword(value);
            context.read<ItemSearch>().setMode(1);
            print(context.read<ItemSearch>().keyword);
            print(context.read<ItemSearch>().mode);
            fetchItemSearched(context.read<ItemSearch>().keyword);
          },
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(actionIcon),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () {},
        ),
      ],
    );
  }

  List<DropdownMenuItem> dropDownSort(Size size) {
    List<DropdownMenuItem> output = [];
    sortedBy.values.forEach((element) {
      output.add(DropdownMenuItem(
        value: element,
        child: Text(
          element.toString().split(".").last,
          style: kMaven.copyWith(fontSize: size.height / 50),
        ),
      ));
    });
    return output;
  }

  void updateSortedStatus(sortedBy) {
    setState(() {
      sorted = sortedBy;
    });
  }

  @override
  Widget build(BuildContext context) {
    _itemSearch = context.watch<ItemSearch>();
    Size size = MediaQuery.of(context).size;



    return Scaffold(
        appBar: appBar(context),
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Container(
            child: Column(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height / 100,
                              horizontal: size.width / 30),
                          child:
                              searchedItem == null || searchedItem.length <= 0
                                  ? SizedBox()
                                  : Text(
                                      _itemSearch != null
                                          ? _itemSearch.getInfo()
                                          : "",
                                      style: _itemSearch.mode == 0
                                          ? kCalibriBold.copyWith(
                                              fontSize: size.height / 40,
                                              color: kBlueMainColor)
                                          : kCalibri.copyWith(
                                              fontSize: size.height / 40,
                                              color: kBlueMainColor)))),
                  searchedItem == null || searchedItem.length <= 0
                      ? SizedBox()
                      : Container(
                          margin: EdgeInsets.only(left: size.width / 50),
                          height: size.height / 20,
                          padding: EdgeInsets.only(
                              right: size.width / 100, left: size.width / 50),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              border: Border.all(
                                  color: kGrayConcreteColor,
                                  width: 1,
                                  style: BorderStyle.solid)
                                ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: Colors.white,
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  value: sorted,
                                  items: dropDownSort(size),
                                  onChanged: (value) {
                                    sorted = value;
                                    manageItems();
                                    setState(() {});
                                  }),
                            ),
                          ),
                        ),
                ],
              ),
              Expanded(
                child: searchedItem == null || searchedItem.length <= 0
                    ? Center(
                        child: Text(
                        isLoading
                            ? ""
                            : _itemSearch.mode==0? "Tidak ada Produk dalam kategori ${_itemSearch.keyword}":"'${_itemSearch.keyword}' Tidak ditemukan ",
                        style: kCalibri,
                      ))
                    : StaggeredGridView.countBuilder(
                        //Crossaxiscount belum menyesuaikan size hp
                        crossAxisCount: 2,
                        staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                        itemBuilder: (context, index) {
                          Item currentItem = searchedItem[index];
                          return ItemTile(
                            item: currentItem,
                            size: size,
                          );
                        },
                        itemCount: searchedItem.length),
              )
            ]),
          ),
        ));
  }
}

enum sortedBy {
  HargaTerendah,
  HargaTertinggi,
  Terbaru,
  Terlama,
  Default,
}
