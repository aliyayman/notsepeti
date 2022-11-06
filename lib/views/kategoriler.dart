import 'package:flutter/material.dart';
import 'package:not_sepeti/models/kategori.dart';
import 'package:not_sepeti/utils/kategorilerDao.dart';

class Kategoriler extends StatefulWidget {
  const Kategoriler({super.key});

  @override
  State<Kategoriler> createState() => _KategorilerState();
}

class _KategorilerState extends State<Kategoriler> {
  List<Kategori>? tumKategoriler;
  KategorilerDao? kategorilerDao;
  @override
  void initState() {
    super.initState();
    kategorilerDao=KategorilerDao();
  }
  @override
  Widget build(BuildContext context) {
    if(tumKategoriler == null){
      tumKategoriler= <Kategori>[];
      kategoriListesiniGuncelle();
    }
    print(tumKategoriler!.length);
    return Scaffold(
      appBar: AppBar(title: Text("Kategoriler")),
      body: ListView.builder(itemCount: tumKategoriler!.length,itemBuilder: ((context, index) {
        return ListTile(
          onTap: (() => _kategoriGuncelle(tumKategoriler![index])),
          title: Text(tumKategoriler![index].kategoriBaslik!),
          trailing: InkWell(child: Icon(Icons.delete),onTap:(() =>  _kategoriSil(tumKategoriler![index].kategoriID))),
          leading: Icon(Icons.category),
        );
      })),
    );
  }
  
  void kategoriListesiniGuncelle() {
    kategorilerDao!.kategoriListesiniGetir().then((kategoriIcerenList) {
      setState(() {
        tumKategoriler=kategoriIcerenList;
      });

    });
    
  }
  
  _kategoriSil(int? kategoriID) {
  showDialog(context: context, barrierDismissible: false,builder: ((context) {
    return AlertDialog(
      title: Text("Kategori Sil"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
            Text("Kategoriyi sildiğinizde tüm notlarda silincektir.Emin misiniz?"),
            ButtonBar(
              children: [
                TextButton(onPressed: (() {
                  Navigator.pop(context);
                  
                }), child: Text("Vazgeç")),
                    TextButton(onPressed: (() {
                      kategorilerDao!.deleteKategori(kategoriID!).then((value) {
                        if(value!=0){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Kategori Silindi")));
                          setState(() {
                            kategoriListesiniGuncelle();
                            Navigator.pop(context);
                          });
                        }
                        
                      });
                  
                }), child: Text("Sil")),
              ],
            )
        ],
      

      ),
    );
    
  }

  )
  );
  }
  
  _kategoriGuncelle(Kategori guncellenecekKategori) {
    kategoriGuncelleDialog(context,guncellenecekKategori);

  }

    void kategoriGuncelleDialog(BuildContext context,Kategori guncellenecekKategori) {
    var formKey = GlobalKey<FormState>();
    late String guncellenecekKategoriAdi;
              showDialog(
      barrierDismissible: false,
      context: context, builder: ((context) {
      return SimpleDialog(
        title: Text('Kategori Guncelle',style: TextStyle(color: Theme.of(context).primaryColor),),
        children: [
          Form(
            key: formKey,
            child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue:guncellenecekKategori.kategoriBaslik ,
              onSaved: (newValue) {
                guncellenecekKategoriAdi=newValue!;
              },
              validator: (girilenKategoriAdi){
                if(girilenKategoriAdi == null || girilenKategoriAdi.isEmpty){
                  return 'Boş giriş yaptınız';
                }
              },
            
         
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
              

                  kategorilerDao!.updateKategori(Kategori.withID(guncellenecekKategori.kategoriID, guncellenecekKategoriAdi)).then((katID){
                    if(katID !=0){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('kategori güncellendi:$guncellenecekKategoriAdi'),duration: const Duration(seconds: 2),));
                       Navigator.pop(context);
                    }

                  });
                  kategoriListesiniGuncelle();
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
  


  
  
}