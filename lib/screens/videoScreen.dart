import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mopub_flutter/mopub_banner.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_saver/module/dataModule.dart';
import 'package:whatsapp_saver/screens/VideoPlay.dart';

class VideoScreen extends StatelessWidget {
  static const id = 'Videos';

  @override
  Widget build(BuildContext context) {
    var dataModule = Provider.of<DataModule>(context);
    return Scaffold(
        body: dataModule.checkWhatsApp()
            ? ListView(
                children: [
                  Container(
                    height: 60,
                    child: Text('VideoScreen'),
                  ),
                  // MoPubBannerAd(
                  //   //adUnitId from my account aba99d9bfed7473bbbd813f8f33abf25
                  //   adUnitId: 'b195f8dd8ded45fe847ad89ed1d016da',
                  //   bannerSize: BannerSize.MATCH_VIEW,
                  //   keepAlive: true,
                  //   listener: (result, dynamic) {
                  //     print('$result');
                  //     print(dynamic);
                  //   },
                  // ),
                  Container(
                    padding: EdgeInsets.all(5),
                      height: MediaQuery.of(context).size.height - 200,
                      child: GridView.builder(
                          itemCount: dataModule.listOfStatusVideos.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemBuilder: (context, index) {
                            var videoUrl = dataModule.listOfStatusVideos[index];
                            return dataModule.isVideoThumbLoading
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Container(
                              decoration: BoxDecoration(
                                boxShadow: [BoxShadow(color: Colors.grey,blurRadius: 5,spreadRadius: 1)]
                              ),
                                    child: InkWell(
                                      onTap: () {
                                        if (File(videoUrl).existsSync()) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      VideoPlay(
                                                        videoPath: videoUrl,
                                                      )));
                                        }
                                      },
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Hero(
                                              tag: videoUrl,
                                              child: Image.file(
                                                File(
                                                    '${dataModule.getThumbnailsbyName(videoUrl)}'),
                                                fit: BoxFit.cover,
                                              ))),
                                    ),
                                  );
                          }))
                ],
              )
            : Center(
                child: Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'We are unable to find WhatsApp on your Mobile',
                      style: GoogleFonts.timmana(fontSize: 25),
                    )),
              ));
  }
}
