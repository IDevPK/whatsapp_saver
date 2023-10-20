import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_saver/module/fileUtil.dart';
import '../module/dataModule.dart';
import 'imageView.dart';

class ImagesScreen extends StatelessWidget {
  static const id = 'Images';

  @override
  Widget build(BuildContext context) {
    var dataModule = Provider.of<DataModule>(context);
    return dataModule.listOfStatusImages.isNotEmpty
        ? Container(
            child: ListView(
              children: [
                Container(height: 60, child: Text('Images Screen')),
                // MoPubBannerAd(
                //   //adUnitId from my account aba99d9bfed7473bbbd813f8f33abf25
                //   adUnitId: 'b195f8dd8ded45fe847ad89ed1d016da',
                //   bannerSize: BannerSize.MATCH_VIEW,
                //   keepAlive: true,
                //   listener: (result, dynamic) {
                //     print('$result');
                //     print(dynamic);
                //   },
                // )
                //   ,
                // FutureBuilder(
                //     future: dataModule.createListOfImages(),
                //     builder: (context, AsyncSnapshot<List<String>> snapshot) {
                //       if (snapshot.connectionState == ConnectionState.done) {
                //         return Container(
                //             height: MediaQuery.of(context).size.height - 200,
                //             child: GridView.builder(
                //                 itemCount: snapshot.data.length,
                //                 gridDelegate:
                //                     SliverGridDelegateWithFixedCrossAxisCount(
                //                         crossAxisCount: 2,
                //                         crossAxisSpacing: 10,
                //                         mainAxisSpacing: 10),
                //                 itemBuilder: (context, index) {
                //                   var image = dataModule.listOfStatusImages[index];
                //                   return dataModule.isImageLoading
                //                       ? CircularProgressIndicator()
                //                       : InkWell(
                //                           onTap: () {
                //                             Navigator.push(
                //                                 context,
                //                                 MaterialPageRoute(
                //                                     builder: (context) => ImageView(
                //                                           imageLocation: image,
                //                                         ),),);
                //                           },
                //                           child: Hero(
                //                             tag: image,
                //                             child: ClipRRect(
                //                                 borderRadius:
                //                                     BorderRadius.circular(10),
                //                                 child: Image.file(
                //                                   File(image),
                //                                   fit: BoxFit.cover,
                //                                 )),
                //                           ),
                //                         );
                //                 },),);
                //       } else {
                //         return Column(
                //           children: [
                //             Center(child: CircularProgressIndicator()),
                //             Text('Loading Status Images....')
                //           ],
                //         );
                //       }
                //     },),
                dataModule.isImageLoading
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                        padding: EdgeInsets.all(5),
                        height: MediaQuery.of(context).size.height - 200,
                        child: Scrollbar(
                          thickness: 12,
                          child: GridView.builder(
                              itemCount: dataModule.listOfStatusImages.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10),
                              itemBuilder: (context, index) {
                                FileSystemEntity image =
                                    dataModule.listOfStatusImages[index];
                                return dataModule.isImageLoading
                                    ? CircularProgressIndicator()
                                    : InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ImageView(
                                                imageLocation:
                                                    image.path,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Hero(
                                          tag: image.toString(),
                                          child: Container(
                                            // decoration: BoxDecoration(
                                            //     boxShadow: [BoxShadow(color: Colors.grey.withOpacity(.5),blurRadius: 5,spreadRadius: 1)]
                                            // ),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: image != null
                                                    ? Image.file(
                                                        image,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Icon(Icons.image)),
                                          ),
                                        ),
                                      );
                              }),
                        )),
              ],
            ),
          )
        : Center(
            child: Text('WhatsApp Status Images will be shown Here!'),
          );
  }
}
