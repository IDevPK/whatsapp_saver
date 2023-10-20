import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mopub_flutter/mopub_banner.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import '../screens/folderView.dart';
import '../module/dataModule.dart';

class DocumentsScreen extends StatelessWidget {
  static const id = 'Documents';
  @override
  Widget build(BuildContext context) {
    var dataModule = Provider.of<DataModule>(context);

    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: 60,
            child: Text('Documents Screen'),
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
                    itemCount: dataModule.whatsAppDocs.keys.length,
                    itemBuilder: (context, keyIndex) {
                      var docs = dataModule.whatsAppDocs;
                      print(docs);
                      var keys = docs.keys.toList();
                      var values = docs[keys[keyIndex]];
                       return Container(
                        decoration: BoxDecoration(border:Border(bottom: BorderSide(width: 3,color: Colors.black))),
                        child: ExpansionTile(
                          collapsedBackgroundColor: Colors.grey,
                           title: Container(
                            child: Text('${keys[keyIndex]}'),
                          ),
                          leading: FaIcon(
                            FontAwesomeIcons.solidFolderOpen,
                            color: Colors.yellow,
                          ),
                          // collapsedBackgroundColor: Colors.teal,
                          children: [
                            Scrollbar(
                              hoverThickness: 10,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height - 250,
                                child: ListView.builder(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 30),
                                    itemCount: values.length,
                                    itemBuilder: (context, valueIndex) {
                                      //Files Lists Here
                                      String file =
                                          docs[keys[keyIndex]][valueIndex].path.toString();
                                    String extensionName = path.extension(
                                          values[valueIndex].toString());
                                      if (Directory(file).existsSync() && path.basename(file) != keys[keyIndex] && !file.contains('es_recycle_content')) {
                                        return Container(
                                          decoration: BoxDecoration(color: Colors.blueGrey,border:Border(bottom: BorderSide(width: 2,color: Colors.grey))),
                                          padding: EdgeInsets.all(10),
                                          child: InkWell(
                                            onTap: ()
                                            {
                                                dataModule.createListOfFolderView(file).then((value) {
                                                 Navigator.push(context, MaterialPageRoute(builder: (context)=>FolderView(filePath: file,)));
                                                });
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding:EdgeInsets.all(10),
                                                  child: FaIcon(
                                                    FontAwesomeIcons
                                                        .solidFolderOpen,
                                                    color: Colors.yellow,
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Text(
                                                        '${path.basename(file)}')),
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
                                                    decoration:BoxDecoration(
                                                      border:Border(bottom: BorderSide(width: 2,color: Colors.grey)),
                                                      color: Colors.blueGrey
                                                    ),
                                                    padding: EdgeInsets.all(5),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.all(10),
                                                          child: Column(
                                                            children: [
                                                              FaIcon(
                                                                  FontAwesomeIcons
                                                                      .file),
                                                              Text(
                                                                  '$extensionName')
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: InkWell(
                                                            onTap: () {
                                                              OpenFile.open(file);
                                                            },
                                                            child: Text(
                                                                '${path.basename(values[valueIndex].toString())}'),
                                                          ),
                                                        ), //File Title
                                                        IconButton(
                                                          padding:EdgeInsets.all(3),
                                                            icon: FaIcon(
                                                              Icons.save_alt_rounded,
                                                              color:
                                                                  Colors.blue[900],
                                                            ),
                                                            onPressed: () {
                                                              dataModule
                                                                  .saveFile(
                                                                      file);
                                                              dataModule.showSnackBar(context, dataModule.msg);
                                                            }), //Download Option
                                                        IconButton(
                                                            padding:EdgeInsets.all(3),
                                                            icon: FaIcon(
                                                              Icons.share,
                                                              color:
                                                                  Colors.green[900],
                                                            ),
                                                            onPressed: () {
                                                              try {
                                                                Share
                                                                    .shareFiles(
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
                                                            padding:EdgeInsets.all(3),
                                                            color:Colors.white,
                                                            icon: FaIcon(
                                                              Icons.delete,
                                                              color: Colors.red,
                                                            ),
                                                            onPressed: () {
                                                              dataModule.confirmDelete(
                                                                  context,
                                                                  file,
                                                                  dataModule
                                                                      .whatsAppDocs,
                                                                  keyIndex,
                                                                  valueIndex);
                                                            }), //Delete Option
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container();
                                      }
                                    }),
                              ),
                            ),
                          ],
                        ),
                      );
                    })),
          ),
        ],
      ),
    );
  }
}
