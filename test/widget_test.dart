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
      home: TmapScreen(),
    );
  }
}

class TmapScreen extends StatefulWidget {
  @override
  State<TmapScreen> createState() => _TmapScreenState();
}

class _TmapScreenState extends State<TmapScreen> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: 'https://www.example.com', // 테스트용 URL
        javascriptMode: JavascriptMode.unrestricted,  // 여기가 문제면 패키지 문제
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
        },
      ),
    );
  }
}
