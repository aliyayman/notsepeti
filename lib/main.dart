import 'package:flutter/material.dart';
import 'package:not_sepeti/utils/kategorilerDao.dart';
import 'package:not_sepeti/utils/notlarDao.dart';
import 'package:not_sepeti/models/kategori.dart';
import 'package:not_sepeti/models/notlar.dart';
import 'package:not_sepeti/views/kategoriler.dart';
import 'package:not_sepeti/views/notDetay.dart';


void main() => runApp(const MyApp());

Future<void> getKategori()async{
  KategorilerDao kategorilerDao =KategorilerDao();
  NotlarDao notlarDao =NotlarDao();
  //var gelenmap =  kategorilerDao.getKategoriler();
  var gelenNotlar = notlarDao.getNotlar();


  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    getKategori();
    return MaterialApp(
      title: 'Material App',
      
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        
        body: NotListesi(),
      ),
    );
  }
  
}

class NotListesi extends StatefulWidget {
  @override
  State<NotListesi> createState() => _NotListesiState();
}

class _NotListesiState extends State<NotListesi> {
  KategorilerDao kategorilerDao = KategorilerDao();

  NotlarDao notlarDao = NotlarDao();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override


  @override
  Widget build(BuildContext context) {
    setState(() {
      
    });
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: const Center(child: Text('Not Sepeti'),),actions: [
        PopupMenuButton(itemBuilder: ((context) {
          return [
            PopupMenuItem(child: ListTile(leading: Icon(Icons.category),title: Text("Kategoriler"),onTap:(() =>  _kategorilerSayfasinaGit()))),
          ];
          
        })),
      ],),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'kategoriEkle',
            onPressed: () {
            kategoriEkleDialog(context);
        
      },tooltip: 'Kategeori Ekle',child:  Icon(Icons.add_circle),mini: true,), 
      FloatingActionButton(
        heroTag:'notEkle' ,
        onPressed: () => _detaySayfasinaGit(context),
        tooltip: 'Not Ekle',child: Icon(Icons.add),),
      
        ],
      ),
      body: Notlar(),
      
    );
  }

  void kategoriEkleDialog(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    late String yeniKategoriAdi;
              showDialog(
      barrierDismissible: false,
      context: context, builder: ((context) {
      return SimpleDialog(
        title: Text('Kategori Ekle',style: TextStyle(color: Theme.of(context).primaryColor),),
        children: [
          Form(
            key: formKey,
            child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onSaved: (newValue) {
                yeniKategoriAdi=newValue!;
              },
              validator: (girilenKategoriAdi){
                if(girilenKategoriAdi == null || girilenKategoriAdi.isEmpty){
                  return 'Boş giriş yaptınız';
                }
              },
            
              // ignore: prefer_const_constructors
              decoration: InputDecoration(
              labelText: 'Kategori Adı',
              border: const OutlineInputBorder(
    
              ),
            ),),
          )
          ),
          ButtonBar(
            children: [
               ElevatedButton(onPressed: (() {
                Navigator.pop(context);
              }),style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange
              ), child: const Text('Vazgeç'),),
              ElevatedButton(onPressed: (() {
                if(formKey.currentState!.validate()){
                  formKey.currentState!.save();
                  kategorilerDao.insertKategori(Kategori(yeniKategoriAdi)).then(((kategorID) {
                    if(kategorID>0){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('kategori eklendi:$yeniKategoriAdi'),duration: const Duration(seconds: 2),));
                      Navigator.pop(context);
                    }
                    
                  }));
                  
                }
                
              }),style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange
              ), child: Text('Tamam'),),
            ],
          )
          
        ],
      );
      
    })
    );
  }

  _detaySayfasinaGit(BuildContext context) {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  NotDetay(baslik: 'Yeni Not',)),
  );
  }
  
  _kategorilerSayfasinaGit() {
    Navigator.of(context).push(MaterialPageRoute(builder: ((context) => Kategoriler())));

  }
}
class Notlar extends StatefulWidget {
  const Notlar({super.key});

  @override
  State<Notlar> createState() => _NotlarState();
}

class _NotlarState extends State<Notlar> {

  List<Not>? tumNotlar;
  NotlarDao? notlarDao;
 
  @override
  void initState() {
    super.initState();
    tumNotlar = <Not>[];
    notlarDao = NotlarDao();
    
 

  }
  
  @override
  Widget build(BuildContext context) {
      print(notlarDao!.getNotlar().toString());
      print(tumNotlar!.length);
    
    return FutureBuilder(
      future: notlarDao!.getNotList(),
      builder: ((context,AsyncSnapshot<List<Not>> snapshot) {
        if(snapshot.hasData){
          tumNotlar = snapshot.data;
          return ListView.builder(itemCount: tumNotlar!.length,itemBuilder: (context, index) {
            return ExpansionTile(
              title:Text(tumNotlar![index].notBaslik!) ,
            leading: _oncelikIconuBuild(tumNotlar![index].notOncelik),
          
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,children: [
                        Padding(padding: EdgeInsets.all(2)),
                      
                      Text("Kategori",style: TextStyle(color: Colors.redAccent),),
                      Spacer(),
                      Text(tumNotlar![index].kategoriBaslik!,style: TextStyle(color: Colors.black),),
                    ],),
                         Row(
                      mainAxisAlignment: MainAxisAlignment.start,children: [
                        Padding(padding: EdgeInsets.all(2)),
                      
                      Text("Oluşturma Tarihi",style: TextStyle(color: Colors.redAccent),),
                      Spacer(),
                      Text(notlarDao!.dateFormat(DateTime.parse(tumNotlar![index].notTarih!)),style: TextStyle(color: Colors.black),),
                    ],),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("İçerik: "+tumNotlar![index].notIcerik!),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                               TextButton(child: Text("Sil",style: TextStyle(color: Colors.red),),onPressed: ()=> _notDelete(tumNotlar![index].notId),),
                              TextButton(child: Text("Güncelle"),onPressed: ()=>_detaySayfasinaGuncelle(context, tumNotlar![index]) ,),
                      ],
                      

                    ),
                    
                  ]),
                ),
              ],

            );
            
          },);

        }else{
          return Center(child: CircularProgressIndicator(),);
        }


      
    }));
    
  }

  
  
  _oncelikIconuBuild(int? notOncelik) {
    switch(notOncelik){
      case 0:
      return CircleAvatar(child: Text("Az",style: TextStyle(color: Colors.white),),backgroundColor: Colors.redAccent.shade100,);
      
      break;
          case 1:
      return CircleAvatar(child: Text("Orta",style: TextStyle(color: Colors.white),),backgroundColor: Colors.redAccent.shade400,);
      
      break;
          case 2:
      return CircleAvatar(child: Text("Acil",style: TextStyle(color:Colors.white ),),backgroundColor: Colors.redAccent.shade700,);
      
      break;
    }
  }
  
  _notDelete(int? notId) {
    notlarDao!.deleteNot(notId!).then((silinenID) {
      if( silinenID.toInt() !=0){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Not Silindi")));
        setState(() {
          
        });

      }

    });
  }

    _detaySayfasinaGuncelle(BuildContext context,Not not) {
      setState(() {
        
      });
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  NotDetay(baslik: 'Not Güncelle',duzenlenecekNot:not)),
    
  );
  }
}