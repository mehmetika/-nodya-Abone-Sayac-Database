import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inodyawebservice/kullaniciList.dart';
import 'package:inodyawebservice/sayaclistesi.dart';

import 'login.dart';

class anaSayfa extends StatefulWidget {
  @override
  _anaSayfaState createState() => _anaSayfaState();
}

class _anaSayfaState extends State<anaSayfa> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Padding(
                padding: EdgeInsets.only(left: (size.width * .15)),
                child: Text('Abone Bilgileri'),
              ),
              backgroundColor: Colors.blue,
            ),
            drawer: StreamBuilder<Object>(
                stream: null,
                builder: (context, snapshot) {
                  return Drawer(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        UserAccountsDrawerHeader(
                          accountName: Text("Ad Soyad"),
                          accountEmail: Text('Email'),
                          currentAccountPicture: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                              "null",
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text('Anasayfa'),
                          leading: Icon(Icons.home),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text('Hesap Ayarları'),
                          onTap: () {},
                          leading: Icon(Icons.person),
                        ),
                        Divider(),
                        ListTile(
                          title: Text('Çıkış yap'),
                          onTap: () {
                            Fluttertoast.showToast(
                                msg: "Çıkış Yapıldı.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 2,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                          leading: Icon(Icons.remove_circle),
                        ),
                      ],
                    ),
                  );
                }),
            body: WillPopScope(
              onWillPop: () => Future.value(false),
              child: StreamBuilder(
                  stream: null,
                  builder: (context, snapshot) {
                    return Center(
                      child: Container(
                        height: size.height * .70,
                        width: size.width * .85,
                        decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(.75),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(.75),
                                  blurRadius: 10,
                                  spreadRadius: 2)
                            ]),
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.22,
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              kullaniciList()));
                                },
                                child: Container(
                                  width: size.width * .70,
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                      //color: colorPrimaryShade,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * .03,
                                      ),
                                      Icon(
                                        Icons.account_circle,
                                        size: size.height * .035,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: size.width * .03,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Center(
                                            child: Text(
                                          "Kullanıcı Listesi",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: size.width * .05,
                                          ),
                                        )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.1,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              sayacListesi()));
                                },
                                child: Container(
                                  width: size.width * .70,
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                      //color: colorPrimaryShade,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * .03,
                                      ),
                                      Icon(
                                        Icons.home,
                                        size: size.height * .035,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: size.width * .03,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Center(
                                            child: Text(
                                          "Sayac Listesi",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: size.width * .05,
                                          ),
                                        )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            )));
  }
}
