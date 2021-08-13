import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inodyawebservice/anasayfa.dart';
import 'package:inodyawebservice/homepage.dart';

class kullaniciList extends StatefulWidget {
  @override
  _kullaniciListState createState() => _kullaniciListState();
}

class _kullaniciListState extends State<kullaniciList> {
  var kullaniciBilgisi;
  var result;
  var data;
  String isim = '';
  String id = '';
  String customernumber = '';
  String newList = '';
  List<String> StringList = [''];
  int sayac = 0;

  void login() async {
    var headers = {
      'Cookie':
          'laravel_session=e123213yJpdiI6IkVlMVlxdzgwb0kyT3R3eUFwVEMrUUtCU1IyYWlMWmdNdStQMUV2Z3dGTUE9IiwidmFsdWUiOiJSY0twSngrRit2VEdiWEJEQmdQYzd4VjkzUVJ3aytQS3pGU0lBV2tGcWxZNVFNU2VUZ3NNWmQ4ZWs0cU56TjZlWGQrblFvVEgrSmg1WnNGaDR6Zm12UT09IiwibWFjIjoiYTdjMmIzOGI1MzQ2YjRjNmFlYzRhMDFkNTUzZjcyOWFhMWQ3M2I1ZjgxMmMzYWY1NDVkZWFmZDYyY2VlNjc2NyJ9'
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse('https://4com.manas.com.tr/login?ajax=true'));

    request.fields.addAll({'username': '', 'password': '', 'lang': 'tr'});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      result = await response.stream.bytesToString();
      Map mesaj = jsonDecode(result);
      var mesajicerigi = mesaj;
      String mesajicerigison = mesajicerigi['message']['errors'].toString();
      print(mesajicerigison);
    } else {
      String ortek = (response.reasonPhrase).toString();
      String result = '$ortek';
      print(result);
    }
  }

  void kullaniciGetir() async {
    var headers = {
      'Cookie':
          'laravel_session=eyJpdiI6Im9SbXYwMmMxQ0tsQ2pZQXZPK1l4SWFUV1ptc2pqTzZheCtubTdPN3hHY2M9IiwidmFsdWUiOiJxNG5nTTFrRVNjUFVjKyt2OFpWb0pDUTBvNDdHYVd6MEhzME51YVwva1AzeGk3YXVIcnVBRXNoVXA4VWJaWHRocGFObnlIRWN3RGlUWGFabmYzSmE1T0E9PSIsIm1hYyI6IjBiMDAxODk4YzA0OTNkZjBiYmM5YTY3NzJjN2M3MTExZGQ1ZDFhMjYyYjJiNTYwMmVjNGRmNzE3NjE4MGVmNDcifQ%3D%3D'
    };

    var request = http.Request('GET',
        Uri.parse('https://4com.manas.com.tr/definitions/customer/fetch'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      data = await response.stream.bytesToString();
      Map valueMap = jsonDecode(data);
      kullaniciBilgisi = valueMap;
      newList = kullaniciBilgisi['data']['data'].toString();
      StringList = newList.split('null},');
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: StreamBuilder(
          stream: null,
          builder: (context, index) {
            kullaniciGetir();
            login();
            Timer(Duration(seconds: 1), () {
              setState(() {});
            });
            return Scaffold(
                appBar: AppBar(
                  title: Padding(
                    padding: EdgeInsets.only(left: (size.width * .15)),
                    child: Text('Kullanıcı Listesi'),
                  ),
                  leading: new IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => anaSayfa()));
                      },
                      icon: Icon(Icons.arrow_back)),
                ),
                body: (data == null)
                    ? Container(
                        color: Colors.white,
                      )
                    : Align(
                        alignment: Alignment.topCenter,
                        child: ListView.builder(
                            itemCount: StringList.length,
                            itemBuilder: (BuildContext context, index) {
                              newList =
                                  kullaniciBilgisi['data']['data'].toString();
                              StringList = newList.split('null},');
                              id = kullaniciBilgisi['data']['data'][index]['id']
                                  .toString();
                              isim = kullaniciBilgisi['data']['data'][index]
                                      ['name_surname']
                                  .toString();
                              customernumber = kullaniciBilgisi['data']['data']
                                      [index]['customer_nr']
                                  .toString();

                              return Column(
                                children: [
                                  SizedBox(
                                    height: size.height * .03,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomePage(
                                                  id: kullaniciBilgisi['data']
                                                          ['data'][index]['id']
                                                      .toString(),
                                                  isim: kullaniciBilgisi['data']
                                                              ['data'][index]
                                                          ['name_surname']
                                                      .toString(),
                                                  customernumber:
                                                      kullaniciBilgisi['data']
                                                                      ['data']
                                                                  [index]
                                                              ['customer_nr']
                                                          .toString())));
                                    },
                                    child: Center(
                                      child: Container(
                                        height: size.height * .1,
                                        width: size.width * .85,
                                        decoration: BoxDecoration(
                                            color: Colors.blue.withOpacity(.75),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(.75),
                                                  blurRadius: 10,
                                                  spreadRadius: 2)
                                            ]),
                                        child: Center(
                                          child: Text(
                                            '$isim',
                                            style: TextStyle(
                                                fontSize: size.width * .05),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * .03,
                                  ),
                                ],
                              );
                            }),
                      ));
          }),
    );
  }
}
