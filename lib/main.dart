import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'my_page.dart'; // MyPage를 유지
import 'find.dart'; // find.dart import

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _TmapScreenState();
}

class _TmapScreenState extends State<MainScreen> {
  late WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        "MapChannel", // JavaScript와 연결되는 채널
        onMessageReceived: (message) {
          if (message.message == "map_clicked") {
            // HTML에서 "map_clicked" 메시지를 수신하면 find.dart로 이동
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RouteFindingScreen()),
            );
          }
        },
      )
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

                    // 지도 클릭 이벤트 추가
                    map.addListener("click", function() {
                        // Flutter로 메시지 전송
                        MapChannel.postMessage("map_clicked");
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
          '메인페이지',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.home, color: Colors.black, size: 28),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: '목적지를 입력해주세요...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.account_circle, color: Colors.black, size: 28),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyPage()), // MyPage로 이동
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              // 지도
              Text(
                '현재 내 위치',
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
              SizedBox(height: 20),
              // 버스 정보
              Container(
                padding: EdgeInsets.all(16.0),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '버스 정보',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    BusInfoTile(busNumber: '7734', description: '명지중고등학교(여유) 3정거장'),
                    BusInfoTile(busNumber: '7021', description: '명지대 사거리(여유) 4정거장'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // 최근 이용한 경로
              Container(
                padding: EdgeInsets.all(16.0),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '최근 이용한 경로',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RouteButton(routeName: '서울역'),
                        RouteButton(routeName: '청량리'),
                        RouteButton(routeName: '명지진문대'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 버스 정보 타일 위젯
class BusInfoTile extends StatelessWidget {
  final String busNumber;
  final String description;

  BusInfoTile({required this.busNumber, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              busNumber,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 10),
          Expanded(child: Text(description)),
        ],
      ),
    );
  }
}

// 경로 버튼 위젯
class RouteButton extends StatelessWidget {
  final String routeName;

  RouteButton({required this.routeName});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.black),
        ),
      ),
      child: Text(routeName),
    );
  }
}
