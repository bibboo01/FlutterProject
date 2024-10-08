import 'dart:async';
import 'package:flutter/material.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  late Timer _timer;

  final List<String> _images = [
    'assets/Image/index/slider1.jpg',
    'assets/Image/index/slider2.jpg',
    'assets/Image/index/slider3.jpeg',
    'assets/Image/index/slider4.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _images.length;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/Image/Logo/SciLogo.png',
              height: 50,
            ),
            SizedBox(width: 8),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'คณะวิทยาศาสตร์และนวัตกรรมดิจิทัล',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color.fromRGBO(0, 75, 195, 1),
              ),
            ),
            Text(
              'มหาวิทยาลัยทักษิณ',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              child: Container(
                height: 135,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        _images[index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            _buildPageIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_images.length, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentIndex == index ? Colors.blueAccent : Colors.grey,
          ),
        );
      }),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ยินดีต้อนรับสู่',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Your App Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('แบบฟอร์มนิสิต'),
            onTap: () {
              Navigator.pushNamed(context, '/Student');
            },
          ),
          ListTile(
            leading: Icon(Icons.login),
            title: Text('เข้าสู่ระบบ'),
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
          SizedBox(
            height: 300,
          ),
          Divider(),
          ListTile(
            title: Text(
              'ติดต่อเรา',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'คณะวิทยาศาสตร์และนวัตกรรมดิจิทัล\nมหาวิทยาลัยทักษิณ\n222 หมู่ 2 ต.บ้านพร้าว อ.ป่าพะยอม\nจ.พัทลุง 93210',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
