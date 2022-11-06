
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

class databaseHelper{
  
  static final String databaseName="notlar.db";

  static Future<Database> getDatabase() async{

    String databasePath = join(await getDatabasesPath(),databaseName);

    if(await databaseExists(databasePath)){
      print("veri tabanı zaten var,kopyalamaya gerek yok");

    }else{
      ByteData data = await rootBundle.load("assets/$databaseName");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes,data.lengthInBytes);
      await File(databasePath).writeAsBytes(bytes,flush: true);
      print("Veritabani kopyalandı.");
    }

      return openDatabase(databasePath);

  }

}