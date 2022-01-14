import 'package:flutter/material.dart';
import 'package:news_app/helper/news.dart';
import 'package:news_app/models/article_model.dart';

import 'home.dart';

class CategoryNews extends StatefulWidget {
  final String category;
 CategoryNews({ Key? key, required this.category }) : super(key: key);

  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {

  List<ArticleModel> _articles =[];
  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    getCategoryNews();
    super.initState();
  }

  void getCategoryNews() async {
    CategoryNewsClass categoryNews = new CategoryNewsClass();
    await categoryNews.getCategoryNews(widget.category);
    _articles = categoryNews.news;
    setState(() {
      _loading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){Navigator.pop(context);},
            icon: Icon(Icons.arrow_back_ios, color: Colors.black)
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Flutter", style: TextStyle(color: Colors.black)),
            Text("News", style: TextStyle(color: Colors.blue))
          ],
        ),
        actions: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.share, color: Colors.black,))
        ],

        elevation: 0,
        centerTitle: true,
      ),
      body: _loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 800,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _articles.length,
                physics: ClampingScrollPhysics(),
                itemBuilder: (ctx, index) {
                  return BlogTile(
                    imgUrl: _articles[index].urlToImage,
                    title: _articles[index].title,
                    desc: _articles[index].description,
                    url: _articles[index].url,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}