import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_saver/module/dataModule.dart';
import './screens/index.dart';

//Starting point
//This is WhatsappSaver branch
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(ChangeNotifierProvider(
      create: (context) => DataModule(), child: WhatsAppSaver()));
}

class WhatsAppSaver extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final dataModule = Provider.of<DataModule>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whats App Saver',
      theme: ThemeData(
        brightness: Brightness.dark,
        highlightColor: Colors.yellow,
        primarySwatch: Colors.teal,
      ),
      home: FutureBuilder(
        future: dataModule.storagePermissionChecker,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == 1) {
              dataModule.permissionsForInitServices = true;
              // dataModule.initServices();
              // dataModule.createListOfImages().then((value) => dataModule.isImageLoading = false);
              // dataModule.createThumbs().then((value) => dataModule.isVideoThumbLoading=false);
              // dataModule.createListOfDocuments();
              return Index();
            } else {
              return Scaffold(
                body: Center(
                  child: InkWell(
                    splashColor: Colors.black,
                    onTap: () {
                      dataModule.inStatePermissionRequest();
                    },
                    child: Card(
                      elevation: 10,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            color: Colors.blue),
                        padding: EdgeInsets.all(25),
                        child: Text(
                          'Grant Storage Permissions',
                          style: GoogleFonts.timmana(
                              fontSize: 25,
                              textStyle: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          } else {
            return Scaffold(
                appBar: AppBar(),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      Text(
                        'Gathering Information....',
                        style: GoogleFonts.timmana(fontSize: 20),
                      )
                    ],
                  ),
                ));
          }
        },
      ),
    );
  }
}
