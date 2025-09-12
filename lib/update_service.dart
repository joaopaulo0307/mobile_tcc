import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


class UpdateService {
  // URLs do servidor: um arquivo de texto com a versão mais recente e o APK
  static const String versionUrl = 'https://exemplo.com/versao.txt';
  static const String apkUrl = 'https://exemplo.com/app.apk';

  // Verificar se há atualização
  static Future<bool> checkForUpdate() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      final response = await http.get(Uri.parse(versionUrl));
      if (response.statusCode == 200) {
        String latestVersion = response.body.trim();
        // Comparar versões (assumindo que são strings no formato "1.0.0")
        return latestVersion != currentVersion;
      }
    } catch (e) {
      print('Erro ao verificar atualização: $e');
    }
    return false;
  }

  // Baixar e instalar a atualização
  static Future<void> downloadAndInstallUpdate() async {
    // Solicitar permissão de armazenamento
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted) {
        // Baixar o APK
        final response = await http.get(Uri.parse(apkUrl));
        if (response.statusCode == 200) {
          // Obter diretório de downloads
          Directory? directory;
          if (Platform.isAndroid) {
            directory = await getExternalStorageDirectory();
          } else {
            directory = await getApplicationDocumentsDirectory();
          }

          if (directory != null) {
            final file = File('${directory.path}/app_update.apk');
            await file.writeAsBytes(response.bodyBytes);

            // Abrir o arquivo para instalação
            await OpenFilex.open(file.path);
          }
        }
      }
    }
  }
}