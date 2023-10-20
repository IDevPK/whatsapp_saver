import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mopub_flutter/mopub_banner.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:whatsapp_saver/module/dataModule.dart';
import 'dart:io';



class VideoPlay extends StatefulWidget {
  VideoPlay({this.videoPath});
  final String videoPath;

  @override
  _VideoPlayState createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  ChewieController chewieController;
  VideoPlayerController videoPlayerController;
  @override
  void initState() {
    // TODO: implement initState
    videoPlayerController = VideoPlayerController.file(File(widget.videoPath));
    chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        looping: true,
        allowMuting: true,
        autoInitialize: true,
        allowFullScreen: true,
        aspectRatio: videoPlayerController.value.aspectRatio,
        errorBuilder: (context,errorMessage){
          return Center(child: Text(errorMessage),);
        }

    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var dataModule = Provider.of<DataModule>(context);
     return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: FaIcon(Icons.share,color: Colors.white,), onPressed: (){
            Share.shareFiles([widget.videoPath]);
          }),
          IconButton(icon: FaIcon(FontAwesomeIcons.download,color: Colors.white,), onPressed: (){
            dataModule.saveFile(widget.videoPath);
            dataModule.showSnackBar(context, dataModule.msg);
          }),
          IconButton(icon: FaIcon(Icons.delete,color: Colors.white,), onPressed:(){
            dataModule.confirmDelete(context,widget.videoPath).then((value) => Navigator.pop(context));
          }),
                ],
        leading: IconButton(icon: FaIcon(FontAwesomeIcons.windowClose),onPressed: (){
          Navigator.pop(context);
        },),
      ),
      body: ListView(
        children: [
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
          Hero(tag: widget.videoPath,
            child: Chewie(
              controller: chewieController
            ),
          ),
        ],
      ),
    );
  }
}
