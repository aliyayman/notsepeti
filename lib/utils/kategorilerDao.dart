import 'package:not_sepeti/models/kategori.dart';
import 'package:not_sepeti/utils/database_helper.dart';

class KategorilerDao{



Future<List<Map<String,dynamic >>> getKategoriler()async{
   var db = await databaseHelper.getDatabase();
   var sonuc = await db.query("kategori");
   print(sonuc);
   return sonuc;   
}

Future<List<Kategori>> kategoriListesiniGetir()async{
  var kategorileriIcerenMapListesi = await getKategoriler(); 
  
   var kategoriListesi = <Kategori>[];
   for (Map map in kategorileriIcerenMapListesi){
    kategoriListesi.add(Kategori.fromMap(map));
   }
   print(kategoriListesi);
   return kategoriListesi;



}

Future<int> insertKategori(Kategori kategori)async{
   var db = await databaseHelper.getDatabase();
   var result =db.insert("kategori",kategori.toMap());
    print(result);
   return result;
}

Future<int> updateKategori(Kategori kategori)async{
   var db = await databaseHelper.getDatabase();
   var result =db.update("kategori",kategori.toMap(),where: 'kategoriID = ?',whereArgs: [kategori.kategoriID]);
    print(result);
   return result;
}

Future<int> deleteKategori(int kategoriID)async{
   var db = await databaseHelper.getDatabase();
   var result =db.delete("kategori",where: 'kategoriID = ?',whereArgs: [kategoriID]);
    print(result);
   return result;
}


}