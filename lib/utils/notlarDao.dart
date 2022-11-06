import 'package:not_sepeti/models/notlar.dart';
import 'package:not_sepeti/utils/database_helper.dart';

class NotlarDao{


  Future<List<Map<String,dynamic >>> getNotlar()async{
   var db = await databaseHelper.getDatabase();
   var sonuc = await db.rawQuery('select * from "not" inner join kategori on kategori.kategoriID = "not".kategoriID; order by notID Desc;');
   return sonuc;
}

Future<List<Not>> getNotList()async{
   var notlarMapListesi = await getNotlar();
   var notListesi = <Not>[];
   for (Map map in notlarMapListesi){
    notListesi.add(Not.fromMap(map));
   }
   return notListesi;


}

Future<int> insertNot(Not not)async{
   var db = await databaseHelper.getDatabase();
   var result =db.insert("not",not.toMap());
    print(result);
   return result;
}

Future<int> updateNot(Not not)async{
   var db = await databaseHelper.getDatabase();
   var result =db.update("not",not.toMap(),where: 'notID = ?',whereArgs: [not.notId]);
    print(result);
   return result;
}

Future<int> deleteNot(int notID)async{
   var db = await databaseHelper.getDatabase();
   var result =db.delete("not",where: 'notID = ?',whereArgs: [notID]);
    print(result);
   return result;
}
String dateFormat(DateTime tm){

    DateTime today = new DateTime.now();
    Duration oneDay = new Duration(days: 1);
    Duration twoDay = new Duration(days: 2);
    Duration oneWeek = new Duration(days: 7);
    String? month;
    switch (tm.month) {
      case 1:
        month = "Ocak";
        break;
      case 2:
        month = "Şubat";
        break;
      case 3:
        month = "Mart";
        break;
      case 4:
        month = "Nisan";
        break;
      case 5:
        month = "Mayıs";
        break;
      case 6:
        month = "Haziran";
        break;
      case 7:
        month = "Temmuz";
        break;
      case 8:
        month = "Ağustos";
        break;
      case 9:
        month = "Eylük";
        break;
      case 10:
        month = "Ekim";
        break;
      case 11:
        month = "Kasım";
        break;
      case 12:
        month = "Aralık";
        break;
    }

    Duration difference = today.difference(tm);

    if (difference.compareTo(oneDay) < 1) {
      return "Bugün";
    } else if (difference.compareTo(twoDay) < 1) {
      return "Dün";
    } else if (difference.compareTo(oneWeek) < 1) {
      switch (tm.weekday) {
        case 1:
          return "Pazartesi";
        case 2:
          return "Salı";
        case 3:
          return "Çarşamba";
        case 4:
          return "Perşembe";
        case 5:
          return "Cuma";
        case 6:
          return "Cumartesi";
        case 7:
          return "Pazar";
      }
    } else if (tm.year == today.year) {
      return '${tm.day} $month';
    } else {
      return '${tm.day} $month ${tm.year}';
    }
    return "";


  }

}