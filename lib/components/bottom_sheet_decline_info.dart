import 'package:e_catalog/components/custom_raised_button.dart';
import 'package:e_catalog/components/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:e_catalog/constants.dart';

class DeclineBottomSheet extends StatefulWidget {
  Function callback;
  String id;
  String title;

  DeclineBottomSheet({this.id, this.callback, this.title});

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
        height: size.height / 2,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              color: kBackgroundMainColor,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(size.height / 30))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal : size.width/10),
                child: Text(
                  widget.title!=null?widget.title : "Alasan Pembatalan ${widget.id}",
                  textAlign: TextAlign.center,
                  style: kCalibriBold,
                ),
              ),
              SizedBox(
                height: size.height/20,
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
                padding: EdgeInsets.symmetric(horizontal:size.width/20),
                  height: size.height / 6,
                  child: CustomTextField(
                    callback: (value) {
                      print(value);
                      keterangan = value;
                      print(keterangan);
                    },
                    maxLine: 6,
                    hintText: "Alasan penolakan..",
                    maxLength: 300,
                  )),
              SizedBox(
                height: size.height/20,
              ),
              Container(
                height: size.height / 20,
                width: size.width / 2,
                child: CustomRaisedButton(
                  color: kRedButtonColor,
                  callback: (){
                    Navigator.of(context).pop();
                    widget.callback(keterangan);
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
