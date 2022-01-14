import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/helper/data.dart';
import 'package:news_app/helper/news.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/category_model.dart';
import 'package:news_app/views/article_view.dart';

import 'category_news.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> _categories = [];
  List<ArticleModel> _articles = [];

  bool _loading = true;

  void initState() {
    _categories = getCategories();
    getNews();
    super.initState();
  }

  getNews() async {
    News news = News();
    await news.getNews();
    _articles = news.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Flutter", style: TextStyle(color: Colors.black)),
            Text("News", style: TextStyle(color: Colors.blue))
          ],
        ),
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
                  height: 100,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: _categories.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        return CategoryTile(
                          categoryName: _categories[index].categoryName,
                          imgUrl: _categories[index].imgUrl,
                        );
                      }),
                ),
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

class CategoryTile extends StatelessWidget {
  final imgUrl, categoryName;

  const CategoryTile({Key? key, this.imgUrl, this.categoryName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context)=> CategoryNews(category: categoryName.toString().toLowerCase() ,)
              )
          );
        },
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  width: 120,
                  height: 60,
                  fit: BoxFit.cover,
                  imageUrl: imgUrl,
                )),
            Container(
                alignment: Alignment.center,
                width: 120,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.black26,
                ),
                child: Text(
                  categoryName,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String imgUrl, title, desc,url;

  const BlogTile(
      {Key? key, required this.imgUrl, required this.title, required this.desc,
        required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        child: GestureDetector(
          onTap: (){
            Navigator.push(context,
              MaterialPageRoute(builder: (context)=> ArticleView(blogUrl: url,))
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                ClipRRect(
                  child: Image.network(imgUrl),
                  borderRadius: BorderRadius.circular(6),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(title, style: TextStyle(fontSize: 18, color: Colors.black87)),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    desc,
                    style: TextStyle(color: Colors.black26),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
