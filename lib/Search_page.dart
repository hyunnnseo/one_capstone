import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '검색 페이지',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SearchPage(),
    );
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,  // 탭의 개수 설정
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {},
          ),
          title: TextField(
            decoration: InputDecoration(
              hintText: '장소, 버스, 지하철, 주소 검색',
              border: InputBorder.none,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              onPressed: () {},
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SearchFilterButton(label: '즐겨찾기'),
                  SearchFilterButton(label: '즐겨찾기2'),
                  SearchFilterButton(label: '즐겨찾기3'),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(text: '최근검색'),
                Tab(text: '장소'),
                Tab(text: '버스'),
                Tab(text: '경로'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(child: Text('최근 검색 기록이 없습니다.')),
                  Center(child: Text('장소 검색')),
                  Center(child: Text('버스 검색')),
                  Center(child: Text('경로 검색')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchFilterButton extends StatelessWidget {
  final String label;

  SearchFilterButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        side: BorderSide(color: Colors.black),
      ),
      child: Text(label, style: TextStyle(color: Colors.black)),
    );
  }
}
