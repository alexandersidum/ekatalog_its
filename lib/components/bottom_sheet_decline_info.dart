import 'package:e_catalog/components/custom_raised_button.dart';
import 'package:e_catalog/components/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:e_catalog/constants.dart';

class DeclineBottomSheet extends StatefulWidget {
  Function callback;
  String id;

  DeclineBottomSheet({this.id, this.callback});

  @override
  State<DeclineBottomSheet> createState() => DeclineBottomSheetState();
  
}

class DeclineBottomSheetState extends State<DeclineBottomSheet>{
  String keterangan = '';
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StatefulBuilder(builder: (context, setState) {
      
      return Container(
        height: size.height / 4,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(size.height / 30))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Keterangan Penolakan ${widget.id}",
                style: kMavenBold,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.03,
                    vertical: size.height * 0.015),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Keterangan",
                        style: kCalibriBold.copyWith(
                          color: kGrayTextColor,
                          fontSize: size.height * 0.025,
                        )),
                    Text("Max 300",
                        style: kCalibriBold.copyWith(
                          color: kLightGrayTextColor,
                          fontSize: size.height * 0.02,
                        )),
                  ],
                ),
              ),
              Container(
                  height: size.height / 10,
                  child: CustomTextField(
                    callback: (value) {
                      print(value);
                      keterangan = value;
                      print(keterangan);
                    },
                    maxLine: 5,
                    hintText: "Alasan penolakan..",
                    maxLength: 300,
                  )),
              Container(
                height: size.height / 20,
                width: size.width / 3,
                child: CustomRaisedButton(
                  color: kRedButtonColor,
                  callback: (){
                    widget.callback(keterangan);
                    Navigator.of(context).pop();
                    },
                  buttonChild: Text("Submit",
                      style: kCalibriBold.copyWith(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

}
