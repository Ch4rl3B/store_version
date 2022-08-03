import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:store_version/store_version.dart';
import 'package:store_version/version_status.dart';

import 'main_test.mocks.dart';

@GenerateMocks([StoreVersion, BuildContext])
void main() {
  late MockStoreVersion storeVersion;
  late MockBuildContext context;

  setUp(() {
    storeVersion = MockStoreVersion();
    context = MockBuildContext();

    when(storeVersion.showUpdateDialog(
      context: anyNamed('context'),
      versionStatus: anyNamed('versionStatus'),
      dialogTitle: anyNamed('dialogTitle'),
      dialogText: anyNamed('dialogText'),
      updateButtonText: anyNamed('updateButtonText'),
      allowDismissal: anyNamed('allowDismissal'),
      dismissButtonText: anyNamed('dismissButtonText'),
      dismissAction: anyNamed('dismissAction'),
    )).thenAnswer((_) => Future.value());
  });

  test('basic version show dialog when can update', () async {
    final versionStatus = VersionStatus(
        localVersion: '1.0.0',
        storeVersion: '1.0.1',
        appStoreLink: 'http://somelink.de');

    when(storeVersion.getVersionStatus())
        .thenAnswer((realInvocation) => Future.value(versionStatus));

    //When
    await advancedStatusCheck(storeVersion, context);

    //Then
    verify(storeVersion.showUpdateDialog(
      context: context,
      versionStatus: versionStatus,
      dialogTitle: 'Custom Title',
      dialogText: 'Custom Text',
    ));
  });

  test('basic version do not show dialog when can not update', () async {
    final versionStatus = VersionStatus(
        localVersion: '1.0.1',
        storeVersion: '1.0.1',
        appStoreLink: 'http://somelink.de');

    when(storeVersion.getVersionStatus())
        .thenAnswer((realInvocation) => Future.value(versionStatus));

    //When
    await advancedStatusCheck(storeVersion, context);

    //Then
    verifyNever(storeVersion.showUpdateDialog(
      context: context,
      dialogTitle: 'Custom Title',
      dialogText: 'Custom Text',
    ));
  });
}
