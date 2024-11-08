import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RouteFindingScreen(),
    );
  }
}

class RouteFindingScreen extends StatefulWidget {
  @override
  State<RouteFindingScreen> createState() => _RouteFindingScreenState();
}

class _RouteFindingScreenState extends State<RouteFindingScreen> {
  late WebViewController controller;
  bool isSearching = false;
  final TextEditingController startController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  void toggleSearch() {
    setState(() {
      isSearching = !isSearching;
    });
  }

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
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
                        center: new Tmapv2.LatLng(37.5665, 126.9780),
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
          '길찾기',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller), // Tmap이 표시되는 WebView
          // 검색 바 또는 출발지/목적지 입력 칸
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
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
              child: isSearching
                  ? Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: startController,
                      decoration: InputDecoration(
                        hintText: '출발지 입력',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: destinationController,
                      decoration: InputDecoration(
                        hintText: '목적지 입력',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: toggleSearch, // 뒤로 가기 버튼
                  ),
                ],
              )
                  : Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.menu, color: Colors.black),
                    onPressed: () {},
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '장소, 버스, 지하철, 주소 검색',
                        border: InputBorder.none,
                      ),
                      onTap: toggleSearch,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.mic, color: Colors.black),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.black),
                    onPressed: toggleSearch,
                  ),
                ],
              ),
            ),
          ),
          // 즐겨찾기 버튼 (검색 바 아래에 위치)
          Positioned(
            top: 80,
            left: 16,
            child: ElevatedButton.icon(
              onPressed: () {}, // 즐겨찾기 기능 추가 시 사용할 콜백
              icon: Icon(Icons.star_border),
              label: Text('즐겨찾기'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shadowColor: Colors.grey.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 3,
              ),
            ),
          ),
          // 길찾기 버튼 (목적지 입력 필드 아래 오른쪽에 위치)
          if (isSearching)
            Positioned(
              top: 80,
              right: 16,
              child: ElevatedButton.icon(
                onPressed: () {
                  // 길찾기 기능 구현
                },
                icon: Icon(Icons.directions),
                label: Text('길찾기'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
        ],
      ),
      // 하단 내비게이션 바
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: '주변',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: '저장',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            label: '대중교통',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.navigation),
            label: '네비게이션',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '내 정보',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
