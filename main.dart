import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
      primaryColor: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
      home: ImageGallery(),
    );
  }
}

class ImageGallery extends StatefulWidget {
  @override
  ImageGalleryState createState() => ImageGalleryState();
}

class ImageGalleryState extends State<ImageGallery> {
  late List<String> imageUrls;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      imageUrls = await generateRandomPicsumPhotos(18, []);
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      print('No Image Available $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<String>> generateRandomPicsumPhotos(
    int count, 
    List<int> excludedIds) async {
    List<String> urls = [];
    final random = Random();

    for (int i = 0; i < count; i++) {
     int width = random.nextInt(1000) + 800;
     int height = random.nextInt(1800) + 1200;
      int id;
      do {
        id = random.nextInt(1000);
      } while (excludedIds.contains(id));

      String url = 'https://picsum.photos/id/$id/$width/$height';
      urls.add(url);
    }

    return urls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.image),
        title: Text(
          'Image Gallery',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                ),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SecondPage(
                            imageUrl: imageUrls[index],
                          ),
                        ),
                      );
                    },
                    child: Image.network(
                      imageUrls[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  final String imageUrl;

  SecondPage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Viewer'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}