import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:inodyawebservice/sayaclistesi.dart';

class sayacIcerigi extends StatefulWidget {
  String id = '';
  String isim = '';
  String customernumber = '';

  sayacIcerigi(
      {required this.id, required this.isim, required this.customernumber});

  @override
  State<sayacIcerigi> createState() => _sayacIcerigiState();
}

class _sayacIcerigiState extends State<sayacIcerigi> {
  var workOrderIdGetir = '';
  var data;
  var result;
  String nameWorkOrder = '';
  String newWorkOrderId = '';
  void login() async {
    var headers = {
      'Cookie':
          'laravel_session=eyJ123213pdiI6IkVlMVlxdzgwb0kyT3R3eUFwVEMrUUtCU1IyYWlMWmdNdStQMUV2Z3dGTUE9IiwidmFsdWUiOiJSY0twSngrRit2VEdiWEJEQmdQYzd4VjkzUVJ3aytQS3pGU0lBV2tGcWxZNVFNU2VUZ3NNWmQ4ZWs0cU56TjZlWGQrblFvVEgrSmg1WnNGaDR6Zm12UT09IiwibWFjIjoiYTdjMmIzOGI1MzQ2YjRjNmFlYzRhMDFkNTUzZjcyOWFhMWQ3M2I1ZjgxMmMzYWY1NDVkZWFmZDYyY2VlNjc2NyJ9'
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

  void oku() async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie':
          'laravel_session=eyJpdiI6InNLQUtVRXRMYUMzWjZFY2ZPUzlHRm5GTGpXQ3FRSEFMUDQybVkrYzRmSHc9IiwidmFsdWUiOiJzR0dWa3dnSU5lUmtGd0dERE00WnB0YTJEZTlpMEF5MlhTSFpQcmFJT3cxYnRSVUl3OHFodEVGcm9Va2ZTSDFcL2pKQm15YjFJcjhnSWpSbmFNWEYwZFE9PSIsIm1hYyI6IjZiOWJmMzIyMTEyZTQwNjBmYTY4NTkwYzc4MTI5YjQ1NTQ4NDY2YmIzMWNlNzlmYWQ0YjIyMWJmNDg3YTM4MzUifQ%3D%3D'
    };
    var request = http.Request(
        'PUT',
        Uri.parse(
            'https://4com.manas.com.tr/operation/meter_action/update/8095'));
    request.body = json.encode({
      "action_type": 1,
      "datetime": "2020-08-11 19:56:18",
      "workorder": {"readMeter": true, "parseResponse": true}
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      data = await response.stream.bytesToString();
      Map WorkOrderMap = jsonDecode(data);
      newWorkOrderId = WorkOrderMap['data']['id'].toString();
      nameWorkOrder = WorkOrderMap['data']['encodedActionType'].toString();

      if (nameWorkOrder == 'Sayaç Oku') {
        nameWorkOrder = 'Sayaç okuma iş emri gönderildi.';
      }
      print(newWorkOrderId);
      Fluttertoast.showToast(
          msg: "$nameWorkOrder",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      print(response.reasonPhrase);
      Fluttertoast.showToast(
          msg: "İş emri gönderilemedi!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void showWorkOrder() async {
    var headers = {
      'Cookie':
          'laravel_session=eyJpdiI6IlJzbVN5YVpPTFhZNFd3aXY2UGdxMndseUp1cTVWOGJ4RTZuK0RJcmpnbnM9IiwidmFsdWUiOiJ4UEZJZGVLTkpWT1IybWYxNndWeXFuNitNM2RWY0ZtY2ZYSjZGRCtnWnZDMFh4bVBRMmhhRUlcL0FrNTJZRk1mXC9KMmRxQkE0d2IzNmV0clNndGZPVVpnPT0iLCJtYWMiOiJjNzExMjk0M2U3YjJiMGEwNzdiZTAyNTdlYjM4YjRjZmExYTEyZTgwZTdjMGQzODAwYTJmMDAzMzI2MGUwMmE3In0%3D'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://4com.manas.com.tr/operation/meter_action/show/$newWorkOrderId?render_method=json'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      data = await response.stream.bytesToString();
      Map WorkOrderMap = jsonDecode(data);
      newWorkOrderId = WorkOrderMap['data']['id'].toString();
      nameWorkOrder = WorkOrderMap['data']['status'].toString();
      print(nameWorkOrder);
      if (nameWorkOrder == '0') {
        nameWorkOrder = 'İşlem Başarılı.';
        Fluttertoast.showToast(
            msg: "$nameWorkOrder",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 4,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (nameWorkOrder == '-1') {
        nameWorkOrder = 'İşlem Başarısız!';
        Fluttertoast.showToast(
            msg: "$nameWorkOrder",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 4,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      print(newWorkOrderId);
    } else {
      print(response.reasonPhrase);
      Fluttertoast.showToast(
          msg: "İş Emri Sorgulama Başarısız!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void openMeter() async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie':
          'laravel_session=eyJpdiI6ImJyRzdTdGRMKzFVTk91UVUxbUtaTXk0TDBWYXh4MWg1VnlNbWlzUEd5WFk9IiwidmFsdWUiOiIrRFhhZjZMXC9FXC9tQ2VsM2ZzTEpcL0xnT2R0eFl6Q0wxUlNrNVRPbTVtK3VFd05IRHFiWnR4SkJJQ3JrUFBSRVlGUXJPZkFwcTlDXC9DcU5DVUtwOHlGbFE9PSIsIm1hYyI6ImNkNWNmNTczZTRkMTc0ZTk0ZmMyY2QxODZmNzgzYTEzOTk5YzUyYjBmZjQ4YmIwZWRlYTA0YTJmZTdkMjFlZGQifQ%3D%3D'
    };
    var request = http.Request(
        'PUT',
        Uri.parse(
            'https://4com.manas.com.tr/operation/meter_action/update/8095'));
    request.body = json.encode({
      "action_type": 3,
      "datetime": "2020-08-11 19:56:18",
      "workorder": {"openMeter": true}
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      data = await response.stream.bytesToString();
      Map WorkOrderMap = jsonDecode(data);
      newWorkOrderId = WorkOrderMap['data']['id'].toString();
      nameWorkOrder = WorkOrderMap['data']['encodedActionType'].toString();

      if (nameWorkOrder == 'Sayaç Aç') {
        nameWorkOrder = 'Sayaç açma iş emri gönderildi.';
      }
      print(newWorkOrderId);
      Fluttertoast.showToast(
          msg: "$nameWorkOrder",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      print(response.reasonPhrase);
      Fluttertoast.showToast(
          msg: "İş emri gönderilemedi!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void closeMeter() async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie':
          'laravel_session=eyJpdiI6ImhhN0tEOGpjaTNORFFsN05kXC9oNnd1M1hyYVJNd1c4ZU1OTE5VcUdaZ0x3PSIsInZhbHVlIjoiTFlSZXh5XC9GMUtCeWtZNTVsY3ZxZlh0OStYRFZnRTc0V1A5VTR2WDEzbnpJRXJtVHZGOTlpUys5RTB2K2JOeWJCWlI4MWdzZEFGeWh5MFJqOEZLUTJBPT0iLCJtYWMiOiJjOWY4ZjQ5ZjQwNWU5ODlhYTM0ODM3YTcxNjllYjcyM2NkODMxOTE4YjU1ODcwMGMwZmJiMmM2NzAzMzA3ZGI3In0%3D'
    };
    var request = http.Request(
        'PUT',
        Uri.parse(
            'https://4com.manas.com.tr/operation/meter_action/update/8095'));
    request.body = json.encode({
      "action_type": 2,
      "datetime": "2020-07-01 19:56:18",
      "workorder": {"closeMeter": true}
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      data = await response.stream.bytesToString();
      Map WorkOrderMap = jsonDecode(data);
      newWorkOrderId = WorkOrderMap['data']['id'].toString();
      nameWorkOrder = WorkOrderMap['data']['encodedActionType'].toString();

      if (nameWorkOrder == 'Sayaç Kapat') {
        nameWorkOrder = 'Sayaç kapatma iş emri gönderildi.';
      }
      print(newWorkOrderId);
      Fluttertoast.showToast(
          msg: "$nameWorkOrder",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      print(response.reasonPhrase);
      Fluttertoast.showToast(
          msg: "İş emri gönderilemedi!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Padding(
                padding: EdgeInsets.only(left: (size.width * .15)),
                child: Text('Sayaç Bilgileri'),
              ),
              leading: new IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => sayacListesi()));
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
                        height: size.height * .55,
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
                                height: size.height * 0.03,
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
                                        "Sayac id:${widget.id}",
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
                                        "Seri Numarası:${widget.isim}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.width * .04,
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
                                        "Sayaç Tipi  : ${widget.customernumber}",
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
                                height: size.height * 0.1,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width * .1,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      login();
                                      openMeter();
                                    },
                                    child: Container(
                                      width: size.width * .3,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
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
                                            Icons.lock_open,
                                            size: size.height * .025,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: size.width * .005,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Center(
                                                child: Text(
                                              "Sayacı Aç",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: size.width * .03,
                                              ),
                                            )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width * .05,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      login();
                                      closeMeter();
                                    },
                                    child: Container(
                                      width: size.width * .3,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                          //color: colorPrimaryShade,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: size.width * .02,
                                          ),
                                          Icon(
                                            Icons.lock,
                                            size: size.height * .025,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: size.width * .005,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Center(
                                                child: Text(
                                              "Sayacı Kapat",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: size.width * .03,
                                              ),
                                            )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: size.height * .05,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width * .1,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      login();
                                      oku();
                                    },
                                    child: Container(
                                      width: size.width * .3,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
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
                                            Icons.library_books,
                                            size: size.height * .025,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: size.width * .005,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Center(
                                                child: Text(
                                              "Sayacı Oku",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: size.width * .03,
                                              ),
                                            )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width * .05,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      login();
                                      showWorkOrder();
                                    },
                                    child: Container(
                                      width: size.width * .3,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                          //color: colorPrimaryShade,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: size.width * .02,
                                          ),
                                          Icon(
                                            Icons.mark_chat_read,
                                            size: size.height * .025,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: size.width * .005,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Center(
                                                child: Text(
                                              "İş Emri Sonucu",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: size.width * .028,
                                              ),
                                            )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
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
