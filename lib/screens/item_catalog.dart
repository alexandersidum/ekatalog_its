
import 'package:e_catalog/components/item_tile.dart';
import 'package:e_catalog/models/item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_catalog/constants.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

//Fitur rating
//Fitur Sort belum disempurnakan

class ItemCatalog extends StatefulWidget {

  ItemCatalog({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState()=>ItemCatalogState();

}

class ItemCatalogState extends State<ItemCatalog>{

  bool onSearch = false;
  String searchText;
  sortedBy sorted = sortedBy.init;
  bool isInit = true;
  var listCategory = ['AC', 'Notebook', 'PC', 'Printer', 'Proyektor', 'Router', 'Furniture'];
  var listSelectedCategory = [];
  var selectedList = [];

  void sortItem(List<Item> initialList){
    if(initialList==null) return;
    switch (sorted) {
      case sortedBy.lowestPrice:
          selectedList.sort((a,b){return a.price.compareTo(b.price);}); 
        break;
      case sortedBy.highestPrice:
          selectedList.sort((a,b){return b.price.compareTo(a.price);});
        break;
      case sortedBy.init:
          selectedList = List.from(initialList); 
        break;
      default:
        selectedList = List.from(initialList); 
    }
    setState(() {
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
              element.name.toLowerCase().contains(searchQuery.toLowerCase())
              ||element.seller.toLowerCase().contains(searchQuery.toLowerCase())
              )
          .toList();
    }
    //Perlu diperbaiki??
    onSearch?sortItem(searchedList(searchText)):sortItem(itemList);

    return SafeArea(
      child: Container(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: kBlueMainColor,
              stretch: false,
              centerTitle: true,
              title: Text("E-Katalog"),
              floating: false,
              pinned: false,
            ),
            SliverPersistentHeader(
              delegate: UpperContainer(
                onChangedSearch: (search){
                  searchText = search;
                  setState(() {
                    if(search!=null||search!=''){
                      onSearch=true;
                      selectedList = searchedList(searchText);
                    }
                    else{
                      selectedList = List.from(itemList);
                      // selectedList = itemList.map((e) => Item(image: e.image,name: e.name,isReady: e.isReady,price: e.price,seller: e.seller)).toList();
                    }
                  });
                },
                maxExtent: size.height*0.1, 
                minExtent: size.height*0.1,
                ),
              floating : true,
              pinned: true,
            ),
            SliverStaggeredGrid.countBuilder(
              //Crossaxiscount belum menyesuaikan size hp 
              crossAxisCount: 2, 
              staggeredTileBuilder: (index) => StaggeredTile.fit(2), 
              itemBuilder: (context, index) {
                          Item currentItem = selectedList!=null?selectedList[index]:itemList[index];
                          return ItemTile(item: currentItem, size: size,);
                        }, 
              itemCount: selectedList!=null?selectedList.length:itemList.length
            ),
          ],
        ),
      ),
    );
  }
}

class UpperContainer extends SliverPersistentHeaderDelegate{

  final double minExtent;
  final double maxExtent;
  Function onChangedSearch;
  UpperContainer({this.onChangedSearch(String param), this.maxExtent, this.minExtent});
  
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        height: MediaQuery.of(context).size.height*0.07,
        decoration: BoxDecoration(
          color: kBlueMainColor,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))
        ),
        child: TextField(
          onChanged: onChangedSearch,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top:5, left:5),
            suffixIcon: Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5)
              ),
              borderSide: BorderSide(
                width: 0, 
                style: BorderStyle.none,
            ),
            ),
            hintText: 'Search'),
        ),
      );
    }
  
    @override
    bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate)=>true;

}


class CollapsedAppBar extends SliverPersistentHeaderDelegate{

  final double minExtent;
  final double maxExtent;
  final Color color;

  CollapsedAppBar({this.minExtent, this.maxExtent, this.color});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
      return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height*0.17,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10)
        )
      ),
      child: Text(
        "E-Catalog",
        textAlign: TextAlign.center,
      ),
    );
    }
  
    @override
    bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>true;
}

class TopContainer extends StatelessWidget {
  const TopContainer({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: size.height*0.17,
      decoration: BoxDecoration(
        color: kBlueMainColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10)
        )
      ),
    );
  }
}


enum sortedBy{
  lowestPrice,
  highestPrice,
  newest,
  oldest,
  init,
}