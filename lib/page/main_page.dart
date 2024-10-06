import 'package:flutter/material.dart';

import '../fragment/fragment_generate_image.dart';
import '../fragment/fragment_generate_text.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber.shade100,
        centerTitle: true,
        title: const Text('Example Gemini AI',
          style: TextStyle(
              color: Color(0xFF5A5A5A)
          )
        ),
        bottom: setTabBar(),
      ),
      body: TabBarView(
        controller: tabController,
        children: const [
          FragmentGenerateText(),
          FragmentGenerateImage(),
        ],
      ),
    );
  }

  TabBar setTabBar() {
    return TabBar(
        controller: tabController,
        labelColor: const Color(0xFF5A5A5A),
        unselectedLabelColor: Colors.black26,
        indicatorColor: const Color(0xFF5A5A5A),
        tabs: const [
          Tab(
            text: 'Generate Text',
            icon: Icon(Icons.text_fields),
          ),
          Tab(
            text: 'Generate Image',
            icon: Icon(Icons.image_search),
          ),
        ]
    );
  }
}
