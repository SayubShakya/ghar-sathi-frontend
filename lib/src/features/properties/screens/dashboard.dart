import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ghar_sathi/src/features/properties/screens/detailpagegrid.dart';

// Retained for navigation
// import 'package:demopcps/model/newsapi.dart'; // Removed as API model is not needed
// import 'package:demopcps/core/static.dart'; // Removed as static data/model is not needed

// --- Dummy Model for UI Demonstration ---
class Articles {
  final String? title;
  final String? author;
  final String? publishedAt;
  final String? urlToImage;

  Articles({this.title, this.author, this.publishedAt, this.urlToImage});
}

// Dummy StaticValue class to hold clicked article for navigation
class StaticValue {
  static Articles? clickedarticle;
}
// ----------------------------------------


class dashboard extends StatefulWidget {
  const dashboard({super.key});

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  // --- Dummy Data for UI ---
  final List<Articles> _dummyArticles = [
    Articles(
      title: "Exclusive: New Technology Set to Revolutionize Mobile Communication",
      author: "Tech Reporter",
      publishedAt: "2025-11-19",
      urlToImage: "https://picsum.photos/400/200?random=1",
    ),
    Articles(
      title: "Global Market Trends: What to Expect in the Next Quarter",
      author: "Finance Analyst",
      publishedAt: "2025-11-18",
      urlToImage: "https://picsum.photos/400/200?random=2",
    ),
    Articles(
      title: "Health & Wellness: The Importance of a Balanced Diet and Exercise",
      author: "", // Empty author case
      publishedAt: "2025-11-17",
      urlToImage: "https://picsum.photos/400/200?random=3",
    ),
    Articles(
      title: "Travel Guide: Must-Visit Destinations for the Winter Season",
      author: "Travel Blogger",
      publishedAt: "2025-11-16",
      urlToImage: "https://picsum.photos/400/200?random=4",
    ),
  ];
  // -------------------------

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Widget horizontalcard(size, heading, date, String url) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            // Placeholder URL launch (original behavior)
            var url = Uri(scheme: 'https', host: 'season.info.np', path: 'headers/');
            _launchInBrowser(url);
          },
          child: Container(
              margin: const EdgeInsets.only(left: 15),
              height: size.height / 5,
              width: size.width / 1.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.black12,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(.7),
                ),
              )),
        ),
        Container(
          margin: const EdgeInsets.only(left: 15),
          height: size.height / 5,
          width: size.width / 1.5,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        Positioned(
          bottom: 15,
          left: 25,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size.width / 1.9,
                child: Text(
                  heading,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        const Positioned(
            right: 15,
            bottom: 15,
            child: Icon(
              Icons.play_circle,
              size: 35,
              color: Colors.white,
            ))
      ],
    );
  }

  Widget verticalcard(size, String heading, author, date, String url,
      Articles? article) {
    return GestureDetector(
      onTap: () {
        StaticValue.clickedarticle = article;
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => const detailpagegrid(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.only(top: 10, left: 10),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                    height: 100,
                    width: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                      ),
                    )),
                Container(
                  height: 100,
                  width: 150,
                  decoration: BoxDecoration(
                    // color: Colors.green,
                      borderRadius: BorderRadius.circular(15)),
                  child: const Center(
                    child: Icon(
                      Icons.play_circle,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: size.width / 2,
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    heading,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Conditional check for author being empty
                    author == ""
                        ? Container()
                        : Container(
                      width: 100,
                      margin: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 10, bottom: 10),
                      child: Text(
                        author,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Container(
                        width: 80,
                        child: Text(
                          date,
                          style: const TextStyle(color: Colors.black),
                          maxLines: 1,
                        ))
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    // Get the dummy data
    List<Articles> articles = _dummyArticles;

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 45,
          ),

          // --- Horizontal ListView (Replaced FutureBuilder) ---
          Container(
            height: size.height / 5,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: articles.length,
              itemBuilder: (BuildContext context, int index) {
                return horizontalcard(
                  size,
                  articles[index].title,
                  articles[index].publishedAt,
                  articles[index].urlToImage!,
                );
              },
            ),
          ),
          // ----------------------------------------------------

          // The EsewaPayButton part is commented out in the original code,
          // so it remains commented out or removed entirely in the refactored UI.
          /*
          // EsewaPayButton (Kept commented as in original code)
          EsewaPayButton(
            // ... (paymentConfig, onSuccess, onFailure properties)
          ),
          */

          // --- Vertical ListView (Replaced FutureBuilder) ---
          Container(
            height: size.height / 1.4,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: articles.length,
              padding: EdgeInsets.zero,
              itemBuilder: (BuildContext context, int index) {
                return verticalcard(
                  size,
                  articles[index].title!,
                  articles[index].author,
                  articles[index].publishedAt,
                  articles[index].urlToImage!,
                  articles[index],
                );
              },
            ),
          ),
          // ----------------------------------------------------
        ],
      ),
    );
  }
}