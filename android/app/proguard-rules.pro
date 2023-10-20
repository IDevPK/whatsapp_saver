## Flutter wrapper
 -keep class io.flutter.app.** { *; }
 -keep class io.flutter.plugin.** { *; }
 -keep class io.flutter.util.** { *; }
 -keep class io.flutter.view.** { *; }
 -keep class io.flutter.** { *; }
 -keep class io.flutter.plugins.** { *; }
# -keep class com.google.firebase.** { *; } // uncomment this if you are using firebase in the project
 -dontwarn io.flutter.embedding.**
 -keep class com.huawei.hms.flutter.** { *; }
 -repackageclasses
 -ignorewarnings

  -keep class com.huawei.openalliance.ad.** { *; }
  -keep class com.huawei.hms.ads.** { *; }

  -ignorewarnings
  -keepattributes *Annotation*
  -keepattributes Exceptions
  -keepattributes InnerClasses
  -keepattributes Signature
  -keep class com.hianalytics.android.**{*;}
  -keep class com.huawei.updatesdk.**{*;}
  -keep class com.huawei.hms.**{*;}

   -keep class com.huawei.hms.flutter.** { *; }
  -repackageclasses