import 'package:flutter/material.dart';
import 'package:tugas_5_flutter_media_saver/image_saver.dart';
import 'package:tugas_5_flutter_media_saver/video_saver.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas 5 Simpan Gambar & Video dari URL',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Tugas 5-Simpan Gambar & Video dari URL'),
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.image),
                  text: 'Gambar',
                ),
                Tab(
                  icon: Icon(Icons.video_library),
                  text: 'Video',
                ),
              ],
              indicatorColor: Colors.amber,
            ),
          ),
          body: const SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: TabBarView(
              children: [
                ImageSaver(),
                VideoSaver(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
