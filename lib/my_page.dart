import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'alarm_settings_screen.dart';
import 'my_page_modify.dart'; // 내 정보 수정 페이지 import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<MyPage> {
  late WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..loadHtmlString('''
        <!DOCTYPE html>
        <html lang="ko">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <script src="https://apis.openapi.sk.com/tmap/jsv2?version=latest&appKey=TVBrEtYkTX31JmnOksxwK52pup7Ku3Oua4xqHBN4"></script>
            <style>
                body, html {
                    margin: 0;
                    padding: 0;
                    height: 100vh;
                    width: 100vw;
                    overflow: hidden;
                }
                #map {
                    width: 100%;
                    height: 100%;
                }
            </style>
        </head>
        <body onload="initTmap()">
            <div id="map"></div>
            <script>
                function initTmap() {
                    var map = new Tmapv2.Map("map", {
                        center: new Tmapv2.LatLng(37.6044055, 127.0603859),
                        width: "100%",
                        height: "100%",
                        zoom: 15
                    });
                }
            </script>
        </body>
        </html>
      ''');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        elevation: 0,
        title: Text(
          '내 정보',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 아이콘 및 닉네임
            Row(
              children: [
                Icon(Icons.person, color: Colors.black, size: 28),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '닉네임',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Divider(thickness: 1, color: Colors.black),
            SizedBox(height: 10),

            // 내정보 수정 및 알림 설정
            ListTile(
              leading: Icon(Icons.edit, color: Colors.black),
              title: Text('내정보 수정'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPageModify()), // 내 정보 수정 페이지로 이동
                );
              },
            ),
            Divider(thickness: 1, color: Colors.grey), // 줄 추가
            ListTile(
              leading: Icon(Icons.notifications, color: Colors.black),
              title: Text('알림 설정'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AlarmSettingsScreen()),
                );
              },
            ),
            Divider(thickness: 1, color: Colors.grey), // 줄 추가
            SizedBox(height: 20),

            // 타임라인 및 지도
            Text(
              '타임라인',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  WebViewWidget(controller: controller),
                  if (isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
            Spacer(), // 남은 공간을 채우기 위해 Spacer 사용

            // 로그아웃 버튼
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'LOG OUT',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
