import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class ImageSaver extends StatefulWidget {
  const ImageSaver({super.key});

  @override
  State<ImageSaver> createState() => _ImageSaverState();
}

class _ImageSaverState extends State<ImageSaver> {
  TextEditingController inputController = TextEditingController();
  bool showGambar = false;
  String linkGambar = '';

  ambilGambar(String imageURL) async {
    if (imageURL.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Tidak Ada URL'),
          content: const Text('Silakan Isi URL Gambar yang Benar'),
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
      showGambar = true;
      linkGambar = imageURL;
    });
  }

  Future<void> simpanGambar(String imageURL) async {
    if (imageURL.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Tidak Ada URL'),
          content: const Text('Silakan Isi URL Gambar yang Benar'),
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
    String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final filePath = '${apkDir.path}/$fileName';

    Dio dio = Dio();

    await dio.download(imageURL, filePath);

    await GallerySaver.saveImage(filePath, albumName: 'Flutter Download');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gambar Telah Tersimpan di Galeri')),
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
                  prefixIcon: const Icon(Icons.image_search_outlined),
                  labelText: 'Link',
                  hintText: 'Input Link',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        inputController.text = "";
                        showGambar = false;
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
                      ambilGambar(inputController.text);
                    },
                    icon: const Icon(Icons.image),
                    label: const Text('Lihat'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                    ),
                  ),
                  if (showGambar)
                    ElevatedButton.icon(
                      onPressed: () {
                        simpanGambar(inputController.text);
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
              if (showGambar)
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
                          offset: const Offset(5, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(21),
                      child: Image.network(linkGambar!),
                    ),
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Silakan Masukkan URL Gambar untuk Dilihat'),
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
