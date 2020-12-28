import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:e_catalog/constants.dart';

class ItemCounterButton extends StatelessWidget {
  Function itemAdd;
  Function itemReduce;
  Function onTextSubmit;
  String fieldText;

  ItemCounterButton(
      {this.fieldText, this.onTextSubmit, this.itemAdd, this.itemReduce});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.001),
      height: size.height * 0.045,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            InkWell(
              onTap: itemReduce,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(5)),
                    color: kBlueDarkColor),
                height: size.height * 0.05,
                width: size.height * 0.05,
                child: Center(
                  child:
                      FittedBox(child: Icon(Icons.remove, color: Colors.white)),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              color: kGrayConcreteColor,
              width: size.width * 0.1,
              height: size.height * 0.05,
              child: TextField(
                textAlign: TextAlign.center,
                expands: true,
                maxLines: null,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
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
                    color: kBlueDarkColor),
                height: size.height * 0.05,
                width: size.height * 0.05,
                child: Center(
                  child: FittedBox(child: Icon(Icons.add, color: Colors.white)),
                ),
              ),
            ),
          ]),
    );
  }
}
