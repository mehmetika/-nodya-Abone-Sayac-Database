import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inodyawebservice/kullaniciList.dart';

class HomePage extends StatefulWidget {
  String id = '';
  String isim = '';
  String customernumber = '';

  HomePage(
      {required this.id, required this.isim, required this.customernumber});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Padding(
                padding: EdgeInsets.only(left: (size.width * .13)),
                child: Text('Kullanıcı Bilgileri'),
              ),
              leading: new IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => kullaniciList()));
                  },
                  icon: Icon(Icons.arrow_back)),
              backgroundColor: Colors.blue,
            ),
            body: WillPopScope(
              onWillPop: () => Future.value(false),
              child: StreamBuilder(
                  stream: null,
                  builder: (context, snapshot) {
                    return Center(
                      child: Container(
                        height: size.height * .35,
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
                                height: size.height * .05,
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Container(
                                width: size.width * .70,
                                padding: EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    //color: colorPrimaryShade,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
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
                                        "Abone No:${widget.id}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.width * .05,
                                        ),
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Container(
                                width: size.width * .70,
                                padding: EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    //color: colorPrimaryShade,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
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
                                        "${widget.isim}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.width * .05,
                                        ),
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Container(
                                width: size.width * .70,
                                padding: EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    //color: colorPrimaryShade,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: size.width * .03,
                                    ),
                                    Icon(
                                      Icons.payments,
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
                                        "Müşteri Numarası : ${widget.customernumber}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.width * .05,
                                        ),
                                      )),
                                    ),
                                  ],
                                ),
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
