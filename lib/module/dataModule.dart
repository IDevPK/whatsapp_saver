import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mopub_flutter/mopub.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thumbnails/thumbnails.dart';

import 'unit.dart';

class DataModule with ChangeNotifier {
  DataModule() {
    permissionChecker();
    // inStatePermissionRequest();
    initServices();
  }

  bool permissionsForInitServices = false;

  mobAdsInit() {
    // MoPub.init('b195f8dd8ded45fe847ad89ed1d016da', testMode: true);
  }

  initServices() async {
    createMapofDocs();
    checkAppDirectory();
    listOfWhatsApps = await createWhatsAppDirectoryList();
    createListOfImages().then((value) {
      // mobAdsInit();
      return isImageLoading = false;
    });
    createThumbs().then((value) => isVideoThumbLoading = false);
    // createListOfDocuments();
    notifyListeners();
  }

  final String downloaded = '/storage/emulated/0/Download/';
  final String appDirectory = '/storage/emulated/0/WhatsApp Saver';
  final String thumbVideosFolder =
      '/storage/emulated/0/WhatsApp Saver/.thumbVideos';


  List<FileSystemEntity> listOfWhatsApps = [];
  List<FileSystemEntity> listOfStatusImages = [];
  List<String> listOfThumbs = [];
  List<String> listOfStatusVideos = [];

  // List<String> listOfDocuments = [];
  List<String> listOfFolderView = [];
  List<String> listOfDocFolders = [];
  String msg = '';
  bool isImageLoading = true;
  bool isVideoThumbLoading = true;

  //Permission Related Functions
  int storagePermissionCheck;
  Future<int> storagePermissionChecker;
  Map<String, List<FileSystemEntity>> whatsAppDocs = {};



  checkAppDirectory() async {
    if (Directory(appDirectory).existsSync()) {
      print('App Directory Already Exists');
      return;
    } else {
      Directory(appDirectory).createSync();
      print('App Directory Created');
    }
  }

  checkDownloadDirectory() {
    if (Directory(downloaded).existsSync()) {
      print('Download Directory already Exists');
      return;
    } else {
      Directory(downloaded).createSync();
      print('Download Directory created');
    }
  }

  Future<int> checkStoragePermission() async {
    final result = await Permission.storage.status;
    print('Checking Storage Permission ' + result.toString());
    storagePermissionCheck = 1;
    if (result.isDenied) {
      return 0;
    } else if (result.isGranted) {
      initServices();
      return 1;
    } else {
      return 0;
    }
  }

//Request Storage Permissions if not Granted.
  Future<int> requestStoragePermission() async {
    var status = await Permission.storage.status;
    //Permission Problem need to be fixed
    var abc = await Permission.manageExternalStorage.status;
    if (!abc.isGranted) {
      await Permission.manageExternalStorage.request();
    }
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    final result = await [Permission.storage].request();
    print(result);
    if (result[Permission.storage].isDenied) {
      return 0;
    } else if (result[Permission.storage].isGranted) {
      initServices();
      return 1;
    } else {
      return 0;
    }
  }

  inStatePermissionRequest() async {
    storagePermissionChecker = requestStoragePermission();
    notifyListeners();
  }

  permissionChecker() async {
    ///check methods and usages
    var abc = await FilesUtils.getAllFiles(showHidden: true);
    print(abc.where((element) => element.toString().contains('.Statuses')));

    storagePermissionChecker = (() async {
      int storagePermissionCheckInt;
      int finalPermission;
      print('Initial Values of $storagePermissionCheck');
      if (storagePermissionCheck == null || storagePermissionCheck == 0) {
        storagePermissionCheck = await checkStoragePermission();
      } else {
        storagePermissionCheck = 1;
      }
      if (storagePermissionCheck == 1) {
        storagePermissionCheckInt = 1;
      } else {
        storagePermissionCheckInt = 0;
      }
      if (storagePermissionCheckInt == 1) {
        finalPermission = 1;
      } else {
        finalPermission = 0;
      }
      return finalPermission;
    })();
    notifyListeners();
  }

  //Permission Related Functions Ends Here.

  Future<List<FileSystemEntity>> createWhatsAppDirectoryList() async {
    List<Directory> directories = await FilesUtils.getStorageList();
    List<FileSystemEntity> paths = [];
    for (FileSystemEntity ab in directories) {
            List<String> c = ab.path.split('/');
            if(c.contains('0'))
              {
                List<FileSystemEntity> listDirs =  Directory(ab.path).listSync().where((element) => element.path.contains('WhatsApp')).toList();
                paths = listDirs;
              }
               }
       return paths;
    // var drList = phoneStorage
    //     .listSync(followLinks: true)
    //     .map((e) => e.path)
    //     .where((element) => element.contains('WhatsApp'))
    //     .toList();
    // return drList;
  }

  bool checkWhatsApp() {
    return listOfWhatsApps.toString().contains('WhatsApp');
  }

  // createListOfImages() async {
  //   phoneStorage
  //       .listSync()
  //       .map((e) => e.path)
  //       .where((element) => element.contains('WhatsApp'))
  //       .forEach((element) {
  //     Directory('$element')
  //         .listSync()
  //         .map((e) => e.path)
  //         .where((element) => element.contains('Media'))
  //         .forEach((element) {
  //       Directory('$element')
  //           .listSync()
  //           .map((e) => e.path)
  //           .where((element) => element.contains('.Statuses'))
  //           .forEach((element) {
  //         Directory('$element')
  //             .listSync()
  //             .map((e) => e.path)
  //             .where((element) => element.endsWith('.jpg'))
  //             .forEach((element) {
  //           if (element != null &&
  //               !listOfStatusImages.contains(element.toString())) {
  //             listOfStatusImages.add(element.toString());
  //           }
  //         });
  //       });
  //     });
  //   });
  // }

  // Future createListOfDocuments() async {
  //   phoneStorage
  //       .listSync()
  //       .map((e) => e.path)
  //       .where((element) => element.contains('WhatsApp'))
  //       .forEach((element) {
  //     Directory('$element')
  //         .listSync()
  //         .map((e) => e.path)
  //         .where((element) => element.contains('Media'))
  //         .forEach((element) {
  //       Directory('$element')
  //           .listSync()
  //           .map((e) => e.path)
  //           .where((element) => element.contains('Documents'))
  //           .forEach((element) {
  //         Directory('$element')
  //             .listSync()
  //             .map((e) => e.path)
  //             .forEach((element) {
  //           if (element != null &&
  //               !listOfStatusImages.contains(element.toString()))
  //
  //           {
  //             listOfDocuments.add(element.toString());
  //           }
  //         });
  //       });
  //     });
  //   });
  // }

//   <-----List of Images ------>

  //trying to understand futures
  Future<List<FileSystemEntity>> createListOfImages() async {
    List<FileSystemEntity> tempList = [];
    for (FileSystemEntity path in listOfWhatsApps) {
      List<FileSystemEntity> waPath = Directory(path.path)
          .listSync(recursive: true)
          .where((element) => element.path.contains('.Statuses')&&element.path.contains('.jpg')).toList();
      for(var i in waPath)
        {
          if(i.existsSync())
            {
              tempList.add(i);
            }
        }
    }
    // await phoneStorage
    //     .list(recursive: true,followLinks: true)
    //     .map((event) => event.path)
    //     .where((event) => event.contains('WhatsApp'))
    //     .where((event) => event.contains('.Statuses'))
    //     .where((event) => event.contains('.jpg'))
    //     .toList();
    listOfStatusImages = tempList;
    notifyListeners();
    return tempList;
  }

  //Creates Thumbnails if not available. If Thumbnail already exists then it will go to thumbnail folder to use that picture.
  Future<String> getImage(String videoPathUrl) async {
    var videoNameList = videoPathUrl.split((RegExp(r'/')));
    var videoName = videoNameList.last
        .toString()
        .splitMapJoin((RegExp(r'.mp4')), onMatch: (m) => '');
    var thumbUrl = "$thumbVideosFolder/$videoName.png";
    if (File(thumbUrl).existsSync()) {
      return thumbUrl;
    } else {
      final thumb = await Thumbnails.getThumbnail(
          thumbnailFolder: thumbVideosFolder,
          videoFile: videoPathUrl,
          imageType:
              ThumbFormat.PNG, //this image will store in created folderPath
          quality: 10);
      return thumb;
    }
  }

  //creates thumbnails on initState This will create all the thumbs to avoid any delay in opening video tab
  createThumbs() async {
    isVideoThumbLoading = true;
    if (checkWhatsApp()) {
      listOfWhatsApps.forEach((element) {
        var statuses = Directory(element.path)
            .listSync(recursive: true)
            .map((e) => e.path)
            .where((element) => element.contains('.Statuses'))
            .toList();
        statuses.forEach((element) async {
          if (element.endsWith('.mp4')) {
            listOfStatusVideos.add(element);
            await getImage(element);
          }
        });
      });
    } else {
      print('Unable to create Thumbs folder and files');
    }
    isVideoThumbLoading = false;
  }

  getThumbnailsbyName(String videoUrl) {
    final videoName = path.basenameWithoutExtension(videoUrl);
    if (File(videoUrl).existsSync()) {
      var fileName = '$thumbVideosFolder/$videoName.png';
      return fileName;
    } else {
      return 'File Does not Exist';
    }
  }

  Future<bool> confirmDelete(BuildContext context, String docPath,
      [Map<String, List<FileSystemEntity>> docs, int keyIndex, int valueIndex]) async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Icon(
                Icons.warning_amber_rounded,
                size: 100,
                color: Colors.red,
              ),
              title: Text(
                  '${path.basename(docPath)} Will be permanently Deleted from Storage! Are you Sure?'),
              actions: [
                TextButton(
                  style: ButtonStyle(
                      animationDuration: Duration(milliseconds: 200)),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5)),
                      width: 75,
                      height: 50,
                      child: Center(
                          child: Text(
                        'No',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ))),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                TextButton(
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.blueGrey),
                      enableFeedback: true,
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      animationDuration: Duration(milliseconds: 200)),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5)),
                    width: 75,
                    height: 50,
                    child: Center(
                        child: Text(
                      'Yes',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                  onPressed: () {
/// Need to fix image delete issue.
                    if (listOfStatusImages.contains(docPath) ||
                        listOfStatusVideos.contains(docPath)) {
                      deleteMedia(docPath);
                      showSnackBar(context, msg);
                      Navigator.pop(context, true);
                      notifyListeners();
                    }else if(listOfDocFolders.contains(docPath))
                    {
                      deleteMapDocs(docPath, docs, keyIndex, valueIndex);
                      showSnackBar(context, msg);
                      Navigator.pop(context, false);
                      notifyListeners();
                    }
                    else {
                      msg = 'Nothing to delete';
                    }
                  },
                ),
              ],
            ));
  } //Delete confirm Function ends here

  // deleteFromList(String filePath) {
  //   if (listOfStatusImages.contains(filePath)) {
  //     listOfStatusImages.remove(filePath);
  //   } else if (listOfStatusVideos.contains(filePath)) {
  //     listOfStatusVideos.remove(filePath);
  //   } else if (listOfDocuments.contains(filePath)) {
  //     listOfDocuments.remove(filePath);
  //   }
  //   else {
  //     msg = 'Could not find the File';
  //   }
  // }

  deleteMedia(String file) async {
    if (listOfStatusImages.contains(file)) {
      print(file);
      if (Directory(file).existsSync()) {
        Directory(file).delete();
        listOfStatusImages.remove(File(file));
        msg = 'Folder ${path.basename(file)} deleted from Storage';
      } else if (File(file).existsSync()) {
        File(file).delete();
        listOfStatusImages.remove(File(file));
        msg = 'File ${path.basename(file)} deleted from Storage';
      }
    } else if (listOfStatusVideos.contains(file)) {
      if (Directory(file).existsSync()) {
        Directory(file).delete();
        listOfStatusVideos.remove(file);
        msg = 'Folder ${path.basename(file)} deleted from Storage';
      } else if (File(file).existsSync()) {
        File(file).delete();
        listOfStatusVideos.remove(file);
        msg = 'File ${path.basename(file)} deleted from Storage';
      }
    }

    // else if (listOfFolderView.contains(file)) {
    //   File(file).delete();
    //   listOfFolderView.remove(file);
    //   msg = 'File ${path.basename(file)} deleted from Storage';
    // }
    //Checks file in the map and then checks the file in storage if exists then delete it
  }

  deleteMapDocs(
    String file, [
    Map<String, List<FileSystemEntity>> docs,
    int keyIndex,
    int valueIndex,
  ]) async {
    // else if (listOfDocuments.contains(file)) {
    //   listOfDocuments.remove(file);
    // }
    ///Checks file in the map and then checks the file in storage if exists then delete it
    List<String> keys = whatsAppDocs.keys.toList();
    if (docs[keys[keyIndex]][valueIndex].path.contains(file)) {
      if (File(file).existsSync()) {
        print('File Exists and delete function can be applied');
        File(file).delete();
        List<String> keys = docs.keys.toList();
        docs[keys[keyIndex]].removeAt(valueIndex);
        msg = ('File ${path.basename(file)} has been deleted');
      } else if (Directory(file).existsSync()) {
        Directory(file).delete();
        docs[keys[keyIndex]].removeAt(valueIndex);
        msg = 'Folder ${path.basename(file)} deleted from Storage';
      } else {
        msg = 'Could Not Delete File. Something went Wrong!';
        notifyListeners();
      }
    } else {
      msg = 'File Does not exists';
      notifyListeners();
    }
  }

  //TODO create a method to delete file from folder and map as well
//   deleteFromFolderList(String file,Map<String,List<String>> docs,int keyIndex,int valueIndex,BuildContext context) async{
//     if(File(file).existsSync()){
//       File(file).delete();
//       List<String> keys = docs.keys.toList();
//       print(docs[keys[keyIndex]].removeAt(valueIndex));
//       showSnackBar(context, '${path.basename(file)} has been deleted');
//     }else {
//       showSnackBar(context, 'Unable to delete ${path.basename(file)}');
//     }
// notifyListeners();
//   }

  showSnackBar(BuildContext context, String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      elevation: 10,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<File> copyFileAssets(String assetName) async {
    Uint8List assetByteData = await File(assetName).readAsBytes();

    final List<int> byteList = assetByteData.buffer
        .asUint8List(assetByteData.offsetInBytes, assetByteData.lengthInBytes);
    final currntData = DateTime.now().toString();
    final newFileName = 'Vidoe-$currntData.mp4';
    var fullTemporaryPath = '$downloaded/$newFileName';
      return new File(fullTemporaryPath)
        .writeAsBytes(byteList, mode: FileMode.writeOnly, flush: true);
  }

  //Save file when path is provided
  saveFile(String filePath) async {
    if (File(filePath).existsSync()) {
      if (filePath.endsWith('.jpg')) {
        await ImageGallerySaver.saveFile(filePath);
        msg = 'File ${path.basename(filePath)} saved to Gallery';
        notifyListeners();
      } else if (filePath.endsWith('.mp4')) {
        final currntData = DateTime.now().toString();
        final newFileName = 'Vidoe-$currntData.mp4';
        checkDownloadDirectory();
        copyFileAssets(filePath).then((value) => print(value));
        // File(filePath).copySync('$downloaded/$newFileName');
        msg = 'File $newFileName saved to Download Folder';
        notifyListeners();
      } else {
        checkDownloadDirectory();
        File(filePath).copySync('$downloaded/${path.basename(filePath)}');
        msg = 'File ${path.basename(filePath)} saved to Download Folder';
        notifyListeners();
      }
    } else {
      msg = 'An Error Occurred';
    }
    notifyListeners();
  }

  Future createListOfFolderView(String location) async {
    if (Directory(location).existsSync()) {
      listOfFolderView =
          Directory(location).listSync().map((event) => event.path).toList();
    } else if (File(location).existsSync()) {
      listOfFolderView.add(location);
    }
    notifyListeners();
  }

  void createMapofDocs() async {
    ///Temporarily adds directory names as list then we will combine it with map.
    List<String> whtsAppDr = [];

    ///creates list of All the documents available in the whatsapp folders.
    List<FileSystemEntity> whtsappDocsAll = [];
    for (Directory whatsApps in listOfWhatsApps)
  {
    List<FileSystemEntity> tempDir = whatsApps.listSync(recursive: true).where((element) => element.path.contains('Documents')).toList();
    whtsappDocsAll.addAll(tempDir);
    // print(tempDir);
     }
     ///Following loop will checks which whatsapp are installed and saves its name as list which will be used as key in map.
    for (var i in whtsappDocsAll) {
      String folderpath = path.dirname(i.path);

      String folderBaseName = path.basename(folderpath);
      ///Following Conditions to check conditions

      if (folderpath.contains('Documents')) {
        whtsAppDr.add(folderBaseName);
        // print("FolderName = $folderBaseName");
      }
    }
    ///This will create map of having key and value as list of all the whatsapps separately.
    for (String singleWhatsApp in whtsAppDr) {
      // print(singleWhatsApp);
      List<FileSystemEntity> singleWhatsAppList = whtsappDocsAll
          .where((element) => element.path.contains(singleWhatsApp))
          .toList();

      Map<String, List<FileSystemEntity>> whatsappDocsTemp = {
        singleWhatsApp: singleWhatsAppList
      };
      whatsAppDocs.addAll(whatsappDocsTemp);
      // print('WhatsApp Documents = $whatsAppDocs');
      // print('WhatsApp Temp $whatsappDocsTemp');
    }
  }

  //This will create and return list of Widgets according to available Status videos.
  // whatsDocsView(BuildContext context) {
  //   List<Widget> docsWidgets = [];
  //   for (var i in listOfDocuments) {
  //     // print(path.basename(path.dirname(i)));
  //     //This will check if the file exists and file name is not noMedia file.
  //     if (File(i).existsSync() && !i.contains('nomedia')) {
  //       //Splits and extracts file name which is at the end of path String
  //       //This can be done with the help of path
  //       // path.basename(i);
  //       var fileName = i.split('/').last;
  //       //Extracts Extension name.
  //       var extns = fileName.split('.').last;
  //       //Following code can check file / document size.
  //       // var fileSize = File(i).lengthSync() / 1024 / 1024;
  //       docsWidgets.add(Container(
  //         decoration: BoxDecoration(border: Border()),
  //         padding: EdgeInsets.all(5),
  //         child: Row(
  //           children: [
  //             Container(
  //                 width: 40,
  //                 child: Column(children: [
  //                   Center(
  //                       child: FaIcon(
  //                     FontAwesomeIcons.file,
  //                     color: Colors.blue,
  //                   )),
  //                   Center(child: Text(extns))
  //                 ])),
  //             Expanded(
  //                 child: InkWell(
  //               onTap: () {
  //                 OpenFile.open(i);
  //               },
  //               child: Container(
  //                   padding: EdgeInsets.all(5), child: Text(fileName)),
  //             )),
  //             // Container(
  //             //     padding: EdgeInsets.all(5),
  //             //     child: Text('${fileSize.toStringAsFixed(3)}')),
  //             IconButton(
  //               icon: Icon(
  //                 Icons.download_rounded,
  //                 color: Colors.blue,
  //               ),
  //               onPressed: () {
  //                 //directory and file check should be added
  //                 try {
  //                   File(i).copySync(downloaded + '/$fileName');
  //                   msg = 'File $fileName copied to Download Folder';
  //                   showSnackBar(context, msg);
  //                 } catch (e) {
  //                   print(e);
  //                 }
  //               },
  //             ),
  //             IconButton(
  //               icon: FaIcon(
  //                 Icons.delete,
  //                 color: Colors.red,
  //               ),
  //               onPressed: () {
  //                 confirmDelete(context, i);
  //               },
  //             ),
  //             IconButton(
  //               icon: Icon(
  //                 Icons.share,
  //                 color: Colors.green,
  //               ),
  //               onPressed: () {
  //                 //directory and file check should be added
  //                 // final RenderBox box = context.findRenderObject();
  //                 try {
  //                   Share.shareFiles(
  //                     [i],
  //                     text:
  //                         'App Name https://play.google.com/store/apps/dev?id=6548781422425207107',
  //                     subject: 'A Document is shared with WhatsApp Saver App',
  //                     // sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
  //                   );
  //                 } catch (e) {
  //                   print(e);
  //                 }
  //               },
  //             )
  //           ],
  //         ),
  //       ));
  //       // print('${File(i).lengthSync() / 1024} KB');
  //     } else if (Directory(i).existsSync()) {
  //       var dir = i.split('/').last;
  //       docsWidgets.add(
  //         InkWell(
  //           onTap: () {
  //             createListOfFolderView(i);
  //           },
  //           child: Container(
  //             padding: EdgeInsets.all(5),
  //             child: Row(
  //               children: [
  //                 Container(
  //                     height: 40,
  //                     width: 40,
  //                     child: Center(
  //                         child: Icon(
  //                       Icons.folder,
  //                       color: Colors.yellow[800],
  //                     ))),
  //                 Expanded(
  //                     child: Container(
  //                         padding: EdgeInsets.all(5), child: Text(dir))),
  //                 Container(padding: EdgeInsets.all(5), child: Text('')),
  //                 IconButton(
  //                   icon: FaIcon(
  //                     Icons.delete,
  //                     color: Colors.red,
  //                   ),
  //                   onPressed: () {
  //                     confirmDelete(context, i);
  //                   },
  //                 ),
  //                 Icon(
  //                   Icons.open_in_new_rounded,
  //                   color: Colors.blue,
  //                   size: 35,
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     }
  //   }
  //   return docsWidgets;
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    notifyListeners();
  }
}
