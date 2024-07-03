import 'package:dio/dio.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class VideoSaver extends StatefulWidget {
  const VideoSaver({super.key});

  @override
  State<VideoSaver> createState() => _VideoSaverState();
}

class _VideoSaverState extends State<VideoSaver> {
  TextEditingController inputController = TextEditingController();
  late VideoPlayerController _videoPlayerController;
  late FlickManager _flickManager;
  bool showVideo = false;

  ambilVideo(String videoURL) async {
    if (videoURL.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Tidak Ada URL'),
          content: const Text('Silakan Isi URL Video yang Benar'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      showVideo = true;
    });

    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(videoURL))..initialize();
    _flickManager = FlickManager(videoPlayerController: _videoPlayerController);
  }

  Future<void> simpanVideo(String videoURL) async {
    if (videoURL.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Tidak Ada URL'),
          content: const Text('Silakan Isi URL Video yang Benar'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final apkDir = await getApplicationDocumentsDirectory();
    String fileName = '${DateTime.now().millisecondsSinceEpoch}.mp4';
    final filePath = '${apkDir.path}/$fileName';

    Dio dio = Dio();

    await dio.download(videoURL, filePath);

    await GallerySaver.saveVideo(filePath, albumName: 'Flutter Download');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Video Telah Tersimpan di Galeri')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: inputController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.slow_motion_video),
                  labelText: 'Link',
                  hintText: 'Input Link',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        inputController.text = "";
                        showVideo = false;
                      });
                    },
                    icon: const Icon(Icons.cancel_presentation_outlined),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      ambilVideo(inputController.text);
                    },
                    icon: const Icon(Icons.ondemand_video),
                    label: const Text('Lihat'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                    ),
                  ),
                  if (showVideo)
                    ElevatedButton.icon(
                      onPressed: () {
                        simpanVideo(inputController.text);
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Simpan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                      ),
                    ),
                ],
              ),
              const SizedBox(
                height: 25.0,
              ),
              if (showVideo)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset:
                              const Offset(5, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(21),
                        child: AspectRatio(
                          aspectRatio: _videoPlayerController.value.aspectRatio,
                          child: FlickVideoPlayer(
                            flickManager: _flickManager,
                          ),
                        )),
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Silakan Masukkan URL Video untuk Dilihat'),
                ),
              const SizedBox(
                height: 45.0,
              )
            ],
          ),
        ),
      ),
    ));
  }
}
