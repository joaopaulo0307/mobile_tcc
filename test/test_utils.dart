// test/test_utils.dart
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';

/// Mock global para todas as imagens
void registerMockImages() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final fakeImage = Uint8List.fromList([0, 0, 0, 0]);

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler('flutter/assets', (message) async {
    return fakeImage.buffer.asByteData();
  });
}
