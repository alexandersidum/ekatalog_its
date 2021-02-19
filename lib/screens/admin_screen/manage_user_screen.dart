import 'package:e_catalog/screens/admin_screen/user_detail_screen.dart';
import "package:flutter/material.dart";
import 'package:e_catalog/utilities/account_services.dart';
import 'package:e_catalog/models/account.dart';
import '../../constants.dart';

class ManageUserScreen extends StatefulWidget {
  @override
  _ManageUserScreenState createState() => _ManageUserScreenState();
}

class _ManageUserScreenState extends State<ManageUserScreen> {
  Stream<List<Account>> streamAllUser;
  Stream<List<Account>> streamBlockedUser;
  AccountService _accountService = AccountService();
  int selectedIndex = 0;

  @override
  void initState() {
    streamAllUser = _accountService.getStreamAllAccount();
    streamBlockedUser = _accountService.getStreamBlockedAccount();
    super.initState();
  }

  Widget userTile(Account user) {
    return Builder(
      builder: (context) => Container(
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
                    Text(
                        user.name +
                            (user.role == 2
                                ? ' - ' + (user as Seller).namaPerusahaan
                                : ""),
                        style: kCalibriBold),
                    Text(user.email, style: kCalibri),
                    Text(user.getRole, style: kCalibriBold),
                    if (user.role == 1)
                      Text((user as PejabatPengadaan).namaUnit,
                          style: kCalibriBold),
                    if (user.role == 3)
                      Text((user as PejabatPembuatKomitmen).namaDivisi,
                          style: kCalibriBold),
                  ],
                ),
                PopupMenuButton(
                  child: Row(
                    children: [
                      Text("Action",
                          style: kMavenBold.copyWith(color: kBlueMainColor)),
                      Icon(Icons.more_vert)
                    ],
                  ),
                  // icon: Icon(Icons.more_vert),
                  itemBuilder: (context) {
                    List<PopupMenuEntry<int>> listMenu = user.isBlocked
                        ? [
                            PopupMenuItem(
                              value: 1,
                              child: Text("Unblock", style: kCalibri),
                            ),
                            PopupMenuItem(
                              value: 0,
                              child: Text("Detail User", style: kCalibri),
                            ),
                          ]
                        : [
                            PopupMenuItem(
                              value: 2,
                              child: Text("Block", style: kCalibri),
                            ),
                            PopupMenuDivider(),
                            PopupMenuItem(
                              value: 3,
                              child: Text("Deactivate", style: kCalibri),
                            ),
                            PopupMenuDivider(),
                            PopupMenuItem(
                              value: 0,
                              child: Text("Detail User", style: kCalibri),
                            ),
                          ];
                    return listMenu;
                  },
                  onSelected: (value) async {
                    switch (value) {
                      case 0:
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                UserDetailScreen(user: user)));
                        break;
                      case 1:
                        bool isSuccess = user.role == 3
                            ? await _accountService.setPPKBlock(
                                isBlocked: false, ppk: user)
                            : await _accountService.setAccountBlock(
                                isBlocked: false, uid: user.uid);
                        if (isSuccess)
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(
                            'Berhasil Unblock',
                            style: kCalibri,
                          )));

                        break;
                      case 2:
                        bool isSuccess = user.role == 3
                            ? await _accountService.setPPKBlock(
                                isBlocked: true, ppk: user)
                            : await _accountService.setAccountBlock(
                                isBlocked: true, uid: user.uid);
                        if (isSuccess)
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(
                            'Berhasil Block',
                            style: kCalibri,
                          )));
                        break;
                      case 3:
                        bool isSuccess = user.role == 3
                            ? await _accountService.acceptPPK(
                                isAccepted: false, ppk: user)
                            : await _accountService.setAccountStatus(
                                isAccepted: false, uid: user.uid);
                        if (isSuccess)
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(
                            'Berhasil Deaktivasi',
                            style: kCalibri,
                          )));
                        break;
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
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      initialIndex: selectedIndex,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: kBlueMainColor,
            title: Text("Manage User"),
            bottom: TabBar(
              unselectedLabelColor: Colors.white,
              indicatorWeight: size.height / 150,
              indicatorColor: Colors.white,
              tabs: [
                Tab(child: Text("All User")),
                Tab(child: Text("Blocked User"))
              ],
            ),
          ),
          body: TabBarView(
            children: [
              StreamBuilder(
                stream: streamAllUser,
                builder: (context, AsyncSnapshot<List<Account>> listUser) {
                  if (listUser.connectionState == ConnectionState.active) {
                    if (listUser.hasData) {
                      return TabBarView(
                        children: [
                          Container(
                            child: ListView(
                              children: ListTile.divideTiles(
                                context: context,
                                tiles: listUser.data
                                    .map((user) => userTile(user))
                                    .toList(),
                              ).toList(),
                            ),
                          ),
                          Container(
                            child: ListView(
                              children: ListTile.divideTiles(
                                context: context,
                                tiles: listUser.data
                                    .map((user) => userTile(user))
                                    .toList(),
                              ).toList(),
                            ),
                          )
                        ],
                      );
                    } else
                      return Center(child: Text("No Data"));
                  }
                  if (listUser.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
              StreamBuilder(
                stream: streamBlockedUser,
                builder: (context, AsyncSnapshot<List<Account>> listUser) {
                  if (listUser.connectionState == ConnectionState.active) {
                    if (listUser.hasData) {
                      return TabBarView(
                        children: [
                          Container(
                            child: listUser.data.length <= 0
                                ? Center(
                                    child: Text("No Data", style: kCalibriBold))
                                : ListView(
                                    children: ListTile.divideTiles(
                                      context: context,
                                      tiles: listUser.data
                                          .map((user) => userTile(user))
                                          .toList(),
                                    ).toList(),
                                  ),
                          ),
                          Container(
                            child: ListView(
                              children: ListTile.divideTiles(
                                context: context,
                                tiles: listUser.data
                                    .map((user) => userTile(user))
                                    .toList(),
                              ).toList(),
                            ),
                          )
                        ],
                      );
                    } else
                      return Center(child: Text("No Data"));
                  }
                  if (listUser.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )
            ],
          )),
    );
  }
}
