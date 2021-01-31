import "package:flutter/material.dart";
import 'package:e_catalog/utilities/account_services.dart';
import 'package:e_catalog/models/account.dart';
import 'package:e_catalog/components/custom_alert_dialog.dart';
import '../../constants.dart';

class UserPendingScreen extends StatefulWidget {
  @override
  _UserPendingScreenState createState() => _UserPendingScreenState();
}

class _UserPendingScreenState extends State<UserPendingScreen> {
  Stream<List<Account>> streamUserPending;
  AccountService _accountService = AccountService();

  @override
  void initState() {
    streamUserPending = _accountService.getStreamPendingAccount();
    super.initState();
  }


  Widget userTile(Account user) {
    return Builder(
      builder: 
      (context)=>
       Container(
        width: double.infinity,
        child: Card(
          child: Container(
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Kalau penyedia diberi nama perusahaan juga
                    Text(user.name+(user.role==2?' - '+(user as Seller).namaPerusahaan:""), style: kCalibriBold),
                    Text(user.email, style: kCalibri),
                    Text(user.getRole, style: kCalibriBold),
                    if(user.role==1)Text((user as PejabatPengadaan).getUnit, style: kCalibriBold),
                    if(user.role==3)Text((user as PejabatPembuatKomitmen).getUnit, style: kCalibriBold),
                  ],
                ),
                PopupMenuButton(
                  child: Row(
                    children: [
                      Text("Action", style: kMavenBold.copyWith(color: kBlueMainColor)),
                      Icon(Icons.more_vert)
                    ],
                  ),
                  // icon: Icon(Icons.more_vert),
                  itemBuilder: (context){
                    List <PopupMenuEntry<int>> listMenu = [
                      PopupMenuItem(
                        value: 1,
                        child: Text("Accept",style: kCalibri),
                      ),
                      PopupMenuDivider(),
                      PopupMenuItem(
                        value: 2,
                        child: Text("Decline",style: kCalibri),
                      ),
                    ];
                    return listMenu;
                  },
                  onSelected: (value)async{
                    if(value==1){
                      bool isSuccess = await _accountService.setAccountStatus(isAccepted : true, uid: user.uid);
                      if(isSuccess) Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Berhasil Accept', style: kCalibri,))
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlueMainColor,
        title: Text("Pending User", style:kCalibriBold),
      ),
      body: StreamBuilder(
        stream: streamUserPending,
        builder: (context, AsyncSnapshot<List<Account>> listUser) {
          if (listUser.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (listUser.connectionState == ConnectionState.active) {
            if (listUser.hasData) {
              listUser.data.forEach((e) => print(e.name));
              return Container(
                child: ListView(
                  children:
                      ListTile.divideTiles(
                        context: context,
                  tiles:
                      listUser.data.map((user) => userTile(user)).toList(),
                ).toList(),
                ),
              );
            } else {
              return Center(child: Text("No Data"));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
