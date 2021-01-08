import 'package:e_catalog/components/item_tile.dart';
import 'package:e_catalog/models/item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_catalog/constants.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

//Dropdown Sort
//Pin Category
//Fungsi Category
// The method 'findAncestorStateOfType' was called on null.
// Receiver: null
// Tried calling: findAncestorStateOfType<NavigatorState>()

class ItemCatalog extends StatefulWidget {
  ItemCatalog({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ItemCatalogState();
}

class ItemCatalogState extends State<ItemCatalog> {
  bool onSearch = false;
  String searchText;
  sortedBy sorted = sortedBy.Default;
  bool isInit = true;
  var listCategory = [
    'AC',
    'Notebook',
    'PC',
    'Printer',
    'Proyektor',
    'Router',
    'Furniture',
    'Smartphone',
    'Laptop',
    'Kursi'
  ];
  var listSelectedCategory = [];
  List<Item> selectedList = [];

  //TODO sort by newest and oldest
  void manageItems(List<Item> initialList) {
    if (initialList == null) return;
    switch (sorted) {
      case sortedBy.HargaTerendah:
        selectedList.sort((a, b) {
          return a.price.compareTo(b.price);
        });
        break;
      case sortedBy.HargaTertinggi:
        selectedList.sort((a, b) {
          return b.price.compareTo(a.price);
        });
        break;
      //TODO Terbaru terlamanya sepertinya kebalik
      case sortedBy.Terbaru:
        selectedList.sort((a, b) {
          return a.creationDate.compareTo(b.creationDate);
        });
        break;
      case sortedBy.Terlama:
        selectedList.sort((a, b) {
          return b.creationDate.compareTo(a.creationDate);
        });
        break;
      case sortedBy.Default:
        selectedList = List.from(initialList);
        break;
      default:
        selectedList = List.from(initialList);
    }

    listSelectedCategory.isNotEmpty
        ? selectedList = selectedList.where((item) {
            return listSelectedCategory.contains(item.category);
          }).toList()
        : null;
    setState(() {});
  }

  bool checkCategory(String category) {
    return listSelectedCategory.contains(category);
  }

  void addSelectedCategory(String category) {
    checkCategory(category)
        ? listSelectedCategory.remove(category)
        : listSelectedCategory.add(category);
    setState(() {});
  }

  void updateSortedStatus(sortedBy) {
    setState(() {
      sorted = sortedBy;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Item> itemList = Provider.of<List<Item>>(context);
    //List untuk pencarian
    List<Item> searchedList(String searchQuery) {
      return itemList
          .where((element) =>
              element.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              element.seller.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    //Perlu diperbaiki??
    onSearch ? manageItems(searchedList(searchText)) : manageItems(itemList);

    return SafeArea(
      child: Container(
        color: kBackgroundMainColor,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              toolbarHeight: size.height / 10,
              backgroundColor: kBlueMainColor,
              stretch: false,
              centerTitle: true,
              title: Text(
                "E-Katalog",
                style: kMavenBold,
              ),
              floating: false,
              pinned: false,
            ),
            SliverPersistentHeader(
              delegate: UpperContainer(
                sorted: sorted,
                updateSortedStatus: updateSortedStatus,
                listCategory: listCategory,
                listSelectedCategory: listSelectedCategory,
                checkCategory: checkCategory,
                onTapCategory: addSelectedCategory,
                size: size,
                onChangedSearch: (search) {
                  searchText = search;
                  setState(() {
                    if (search != null || search != '') {
                      onSearch = true;
                      selectedList = searchedList(searchText);
                    } else {
                      selectedList = List.from(itemList);
                      // selectedList = itemList.map((e) => Item(image: e.image,name: e.name,isReady: e.isReady,price: e.price,seller: e.seller)).toList();
                    }
                  });
                },
                maxExtent: size.height * 0.2,
                minExtent: size.height * 0.2,
              ),
              floating: true,
              pinned: true,
            ),
            SliverStaggeredGrid.countBuilder(
                //Crossaxiscount belum menyesuaikan size hp
                crossAxisCount: 2,
                staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                itemBuilder: (context, index) {
                  Item currentItem = selectedList != null
                      ? selectedList[index]
                      : itemList[index];
                  return ItemTile(
                    item: currentItem,
                    size: size,
                  );
                },
                itemCount: selectedList != null
                    ? selectedList.length
                    : itemList.length),
          ],
        ),
      ),
    );
  }
}

class UpperContainer extends SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;
  var listCategory;
  var listSelectedCategory;
  Size size;
  Function onTapCategory;
  Function checkCategory;
  Function onChangedSearch;
  Function updateSortedStatus;
  sortedBy sorted;
  UpperContainer(
      {this.onChangedSearch(String param),
      this.maxExtent,
      this.minExtent,
      this.listCategory,
      this.listSelectedCategory,
      this.onTapCategory,
      this.checkCategory,
      this.size,
      this.sorted,
      this.updateSortedStatus});

  List<DropdownMenuItem> dropDownSort() {
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

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          height: MediaQuery.of(context).size.height * 0.1,
          decoration: BoxDecoration(
              color: kBlueMainColor,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
          child: TextField(
            onChanged: onChangedSearch,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 5, left: 5),
                suffixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                hintText: 'Search'),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: size.width / 50, horizontal: size.height / 50),
            color: kBackgroundMainColor,
            child: Row(
                //Fungsi Sort Dropdown
                children: [
                  Container(
                    margin: EdgeInsets.only(right: size.width / 100),
                    height: size.height / 20,
                    padding: EdgeInsets.only(
                        right: size.width / 100, left: size.width / 50),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        border: Border.all(
                            color: kGrayConcreteColor,
                            width: 1,
                            style: BorderStyle.solid)),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Colors.white,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          
                            value: sorted,
                            items: dropDownSort(),
                            onChanged: (value) {
                              updateSortedStatus(value);
                            }),
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: listCategory
                          .map<Widget>((e) => InkWell(
                                onTap: () {
                                  onTapCategory(e);
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: size.width / 150),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width / 80),
                                  height: size.height / 20,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: checkCategory(e)
                                        ? kBlueMainColor
                                        : Colors.white,
                                    border: Border.all(
                                        color: kGrayConcreteColor,
                                        width: 1,
                                        style: BorderStyle.solid),
                                  ),
                                  child: Text(
                                    e,
                                    style: kMaven.copyWith(
                                      color: checkCategory(e)
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ]),
          ),
        )
      ],
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

class CollapsedAppBar extends SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;
  final Color color;

  CollapsedAppBar({this.minExtent, this.maxExtent, this.color});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))),
      child: Text(
        "E-Catalog",
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

enum sortedBy {
  HargaTerendah,
  HargaTertinggi,
  Terbaru,
  Terlama,
  Default,
}
