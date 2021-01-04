import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:e_catalog/constants.dart';

class ItemCounterButton extends StatelessWidget {
  Function itemAdd;
  Function itemReduce;
  Function onTextSubmit;
  double componentHeight, componentWidth;
  String fieldText;

  ItemCounterButton(
      {this.fieldText,
      this.onTextSubmit,
      this.itemAdd,
      this.itemReduce,
      this.componentWidth,
      this.componentHeight});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.001),
      // height: size.height * 0.045,
      child: Container(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                onTap: itemReduce,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(5)),
                      color: kBlueMainColor),
                  height: componentHeight,
                  width: componentWidth,
                  child: Center(
                    child:
                        FittedBox(child: Icon(Icons.remove, color: Colors.white)),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                color: kGrayConcreteColor,
                height: componentHeight,
                width: componentWidth * 1.5,
                child: TextField(
                  textAlign: TextAlign.center,
                  expands: true,
                  maxLines: null,
                  style: kCalibriBold,
                  decoration: null,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onSubmitted: (value) {
                    onTextSubmit(value);
                  },
                  controller: TextEditingController(text: fieldText),
                ),
              ),
              InkWell(
                onTap: itemAdd,
                child: Container(
                  // onPressed: () {
                  //     itemUpdate(element, element.count + 1);
                  //   },
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.horizontal(right: Radius.circular(5)),
                      color: kBlueMainColor),
                  height: componentHeight,
                  width: componentWidth,
                  child: Center(
                    child: FittedBox(child: Icon(Icons.add, color: Colors.white)),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
