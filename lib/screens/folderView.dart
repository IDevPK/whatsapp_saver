import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mopub_flutter/mopub_banner.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../module/dataModule.dart';

class FolderView extends StatelessWidget {
  static const id = 'Folder Files';
  final String filePath;
  final String baseUrl = '/storage/emulated/0/';

  FolderView({this.filePath});

  @override
  Widget build(BuildContext context) {
    var dataModule = Provider.of<DataModule>(context);

    return WillPopScope(
      onWillPop: () {
        if (path.dirname(filePath).endsWith('Media')) {
          return;
        } else {
          String prevPath = path.dirname(filePath);
          dataModule.createListOfFolderView(prevPath).then((value) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FolderView(
                          filePath: prevPath,
                        )));
          });
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(id),
          leading: IconButton(icon:FaIcon(FontAwesomeIcons.windowClose),onPressed: (){
            Navigator.of(context).pop();
          },),
        ),
        body: ListView(
          children: [
            Container(
              height: 60,
              child: Text('Folder View Screen'),
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
            // Container(
            //     height: MediaQuery.of(context).size.height-200,
            //     child: ListView(children: dataModule.whatsDocsView(context),))
            Scrollbar(
              child: Container(
                  padding: EdgeInsets.only(bottom: 10),
                  height: MediaQuery.of(context).size.height - 200,
                  child: ListView.builder(
                      itemCount: dataModule.listOfFolderView.length,
                      itemBuilder: (context, index) {
                        var docs = dataModule.listOfFolderView;
                        var file = docs[index];
                        String ext = path.extension(file);
                        if (Directory(file).existsSync() &&
                            !file.contains('es_recycle_content')) {
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                border: Border(
                                    bottom: BorderSide(
                                        width: 2, color: Colors.grey))),
                            padding: EdgeInsets.all(10),
                            child: InkWell(
                              onTap: () {
                                dataModule
                                    .createListOfFolderView(file);
                                //     .then((value) {
                                //
                                //   Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) => FolderView(
                                //                 filePath: file,
                                //               )));
                                // });
                              },
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: FaIcon(
                                      FontAwesomeIcons.solidFolderOpen,
                                      color: Colors.yellow,
                                    ),
                                  ),
                                  Expanded(
                                      child: Text('${path.basename(file)}')),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return File(file).existsSync() &&
                                  !file.contains('.nomedia')
                              ? Column(
                                  children: [
                                    // Container(child: Text('${docs[keys[keyIndex]][valueIndex]}'),),
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 2,
                                                  color: Colors.grey)),
                                          color: Colors.blueGrey),
                                      padding: EdgeInsets.all(5),
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                FaIcon(FontAwesomeIcons.file),
                                                Text(ext)
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                OpenFile.open(file);
                                              },
                                              child: Text(
                                                  '${path.basename(file)}'),
                                            ),
                                          ), //File Title
                                          IconButton(
                                              padding: EdgeInsets.all(3),
                                              icon: FaIcon(
                                                Icons.save_alt_rounded,
                                                color: Colors.blue[900],
                                              ),
                                              onPressed: () {
                                                dataModule.saveFile(file);
                                                dataModule.showSnackBar(
                                                    context, dataModule.msg);
                                              }), //Download Option
                                          IconButton(
                                              padding: EdgeInsets.all(3),
                                              icon: FaIcon(
                                                Icons.share,
                                                color: Colors.green[900],
                                              ),
                                              onPressed: () {
                                                try {
                                                  Share.shareFiles(
                                                    [file],
                                                    text:
                                                        'App Name https://play.google.com/store/apps/dev?id=6548781422425207107',
                                                    subject:
                                                        'A Document is shared with WhatsApp Saver App',
                                                    // sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
                                                  );
                                                } catch (e) {
                                                  print(e);
                                                }
                                              }), //Share Option
                                          IconButton(
                                              padding: EdgeInsets.all(3),
                                              color: Colors.white,
                                              icon: FaIcon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                dataModule.confirmDelete(
                                                  context,
                                                  file,
                                                  dataModule.whatsAppDocs,
                                                  index,
                                                );
                                              }), //Delete Option
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Container();
                        }
                      })),
            ),
          ],
        ),
      ),
    );
  }
}
