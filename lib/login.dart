import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:inodyawebservice/anasayfa.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _networkStatus1 = '';

  Connectivity connectivity = Connectivity();

//İnternet Bağlantısı Kontrol
  void checkConnectivity() async {
    var connectivityResult = await connectivity.checkConnectivity();
    var conn = getConnectionValue(connectivityResult);
    setState(() {
      _networkStatus1 = '' + conn;
    });
  }

  Future<Object> gotoHomePage() async {
    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => anaSayfa()));
  }

  String id = '';
  String sifre = '';
  void login() async {
    var headers = {
      'Cookie':
          'laravel_session=12313eyJpdiI6IkVlMVlxdzgwb0kyT3R3eUFwVEMrUUtCU1IyYWlMWmdNdStQMUV2Z3dGTUE9IiwidmFsdWUiOiJSY0twSngrRit2VEdiWEJEQmdQYzd4VjkzUVJ3aytQS3pGU0lBV2tGcWxZNVFNU2VUZ3NNWmQ4ZWs0cU56TjZlWGQrblFvVEgrSmg1WnNGaDR6Zm12UT09IiwibWFjIjoiYTdjMmIzOGI1MzQ2YjRjNmFlYzRhMDFkNTUzZjcyOWFhMWQ3M2I1ZjgxMmMzYWY1NDVkZWFmZDYyY2VlNjc2NyJ9'
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse('https://4com.manas.com.tr/login?ajax=true'));

    request.fields
        .addAll({'username': '$id', 'password': '$sifre', 'lang': 'tr'});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      Map mesaj = jsonDecode(result);
      var mesajicerigi = mesaj;
      String mesajicerigison = mesajicerigi['message']['errors'].toString();
      print(mesajicerigison);
      switch (mesajicerigison) {
        case 'null':
          Fluttertoast.showToast(
              msg: "Giriş Başarılı.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 4,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          gotoHomePage();
          break;
        case '[Bilinmeyen kullanıcı adı veya yanlış şifre girdiniz. Lütfen bilgilerinizi kontrol ediniz.]':
          Fluttertoast.showToast(
              msg:
                  "Bilinmeyen kullanıcı adı veya yanlış şifre girdiniz. Lütfen bilgilerinizi kontrol ediniz.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 4,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;
        case '[Şifre zorunlu]':
          Fluttertoast.showToast(
              msg: "Şifre zorunlu!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 4,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;

        case '[Kullanıcı 15 dakika süreyle engellendi.]':
          Fluttertoast.showToast(
              msg: "Kullanıcı 15 dakika süreyle engellendi.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 4,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;
      }
    } else {
      String ortek = (response.reasonPhrase).toString();
      String result = 'ortekzortek port $ortek';
      print(result);
    }
  }

  //İnternet bağlantı biçimi
  String getConnectionValue(var connectivityResult) {
    String status = '';
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
        status = 'Mobile';
        break;
      case ConnectivityResult.wifi:
        status = 'Wi-Fi';
        break;
      case ConnectivityResult.none:
        status = 'None';
        break;
      default:
        status = 'None';
        break;
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    checkConnectivity();
    if (_networkStatus1 == 'None') {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Container(
          child: AlertDialog(
            title: const Text('Bağlantı Kesildi'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Bağlantınızı kontrol ediniz.'),
                  Text("Tamam'a bastığınızda çıkış gerçekleşecek."),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Tamam'),
                onPressed: () {
                  exit(0);
                },
              ),
            ],
          ),
        ),
      );
    }
    if (_networkStatus1 == 'Wi-Fi' || _networkStatus1 == 'Mobile') {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          body: WillPopScope(
            onWillPop: () async => false,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: (size.width * .20)),
                child: Container(
                  height: size.height * .5,
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
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                              controller: _emailController,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: Colors.white,
                                ),
                                hintText: 'E-Mail',
                                prefixText: ' ',
                                hintStyle: TextStyle(color: Colors.white),
                                focusColor: Colors.white,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.white,
                                )),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.white,
                                )),
                              )),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          TextField(
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              cursorColor: Colors.white,
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.vpn_key,
                                  color: Colors.white,
                                ),
                                hintText: 'Parola',
                                prefixText: ' ',
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                focusColor: Colors.white,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.white,
                                )),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.white,
                                )),
                              )),
                          SizedBox(
                            height: size.height * 0.08,
                          ),
                          InkWell(
                            onTap: () {
                              id = _emailController.text;
                              sifre = _passwordController.text;
                              login();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  //color: colorPrimaryShade,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(
                                    child: Text(
                                  "Giriş yap",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.width * .05,
                                  ),
                                )),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 1,
                                  width: 75,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Kayıt ol",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Container(
                                  height: 1,
                                  width: 75,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ));
    }
    return Scaffold(
      backgroundColor: Colors.white,
    );
  }
}
