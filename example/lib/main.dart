import 'package:flutter/material.dart';
import 'package:store_version/store_version.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    // Instantiate NewVersion manager object (Using GCP Console app as example)
    final newVersion = StoreVersion(
      iOSId: 'com.google.Vespa',
      androidId: 'com.google.android.apps.cloudconsole',
    );

    // You can let the plugin handle fetching the status and showing a dialog,
    // or you can fetch the status and display your own dialog, or no dialog.
    const simpleBehavior = true;

    if (simpleBehavior) {
      basicStatusCheck(newVersion, context);
    } else {
      advancedStatusCheck(newVersion, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Example App"),
      ),
    );
  }
}

Future<void> basicStatusCheck(StoreVersion newVersion, BuildContext context) async {
  await newVersion.showAlertIfNecessary(context: context);
}

Future<void> advancedStatusCheck(StoreVersion newVersion, BuildContext context) async {
  final status = await newVersion.getVersionStatus();
  if (status != null) {
    debugPrint(status.releaseNotes);
    debugPrint(status.appStoreLink);
    debugPrint(status.localVersion);
    debugPrint(status.storeVersion);
    debugPrint(status.canUpdate.toString());
    if(status.canUpdate) {
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'Custom Title',
        dialogText: 'Custom Text',
      );
    }
  }
}
