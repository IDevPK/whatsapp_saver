import 'package:flutter/material.dart';
import 'package:mopub_flutter/mopub_banner.dart';
import 'dart:io';
import 'package:share/share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_saver/module/dataModule.dart';

class ImageView extends StatelessWidget {
  ImageView({this.imageLocation});
  final String imageLocation;
  @override
  Widget build(BuildContext context) {

    var dataModule = Provider.of<DataModule>(context);
    return Scaffold(
      appBar: AppBar(actions: [
          IconButton(icon: FaIcon(Icons.share,color: Colors.white,), onPressed: (){
            Share.shareFiles([imageLocation]);
          }),
        IconButton(icon: FaIcon(FontAwesomeIcons.download,color: Colors.white,), onPressed: (){
          dataModule.saveFile(imageLocation);
          dataModule.showSnackBar(context, dataModule.msg);
    }),
        IconButton(icon: FaIcon(Icons.delete,color: Colors.white,), onPressed:(){
          print(File(imageLocation));
          dataModule.confirmDelete(context,imageLocation).then((value) => Navigator.pop(context));
        }),
      ],),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
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
        Container(
        height: MediaQuery.of(context).size.height-150,
          padding: EdgeInsets.all(5),
          child: SingleChildScrollView(child: Center(child: Hero(
              tag: imageLocation.toString(),
              child: Image.file(File(imageLocation),fit: BoxFit.cover,))))),
          Text('Image View'),
    ],),);
  }
}
