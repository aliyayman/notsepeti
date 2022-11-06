
import 'package:flutter/material.dart';
import 'package:not_sepeti/models/kategori.dart';
import 'package:not_sepeti/models/notlar.dart';
import 'package:not_sepeti/utils/kategorilerDao.dart';
import 'package:not_sepeti/utils/notlarDao.dart';

class NotDetay extends StatefulWidget {
  String baslik;
  Not? duzenlenecekNot;

  NotDetay({required this.baslik, this.duzenlenecekNot});

  @override
  State<NotDetay> createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  var formKey = GlobalKey<FormState>();
  late List<Kategori> tumKategoriler;
  late KategorilerDao kategorilerDao;
  late NotlarDao notlarDao;
  int kategoriID=1;
  static var _oncelik =["Düşük","Orta","Yüksek"];
  int secilenoncelik = 0;
  String? notBaslik,notIcerik;

  @override
  void initState() {
    super.initState();
    tumKategoriler=<Kategori>[];
    kategorilerDao =KategorilerDao();
    notlarDao = NotlarDao();
    kategorilerDao.getKategoriler().then((kategoriIcerenMapListesi){
      for(Map okunanMap in kategoriIcerenMapListesi){
        tumKategoriler.add(Kategori.fromMap(okunanMap));
        setState(() {
          
        });
      }

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.baslik),
        

      ),
      body: tumKategoriler.length <=0 ? Center(
        child: const CircularProgressIndicator(),
      ) : Container(
        child:Form(
          key: formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text("Kategori:",style: TextStyle(fontSize: 24),),
                  ),
                  Container(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(items: buildKategoriItem(),value: widget.duzenlenecekNot != null ? widget.duzenlenecekNot!.kategoriID : kategoriID,onChanged: (value) {
                  setState(() {
                    kategoriID=value!;
                  });
                },)
                ),
                padding: EdgeInsets.symmetric(vertical: 2,horizontal: 20),
                margin: EdgeInsets.all(12),
                 decoration: BoxDecoration(
                 border: Border.all(color: Colors.redAccent,width: 2),
                 borderRadius: BorderRadius.all(Radius.circular(10))
              )
              ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: widget.duzenlenecekNot!= null ? widget.duzenlenecekNot!.notBaslik : "",
                  validator: (text){
                    if(text!.isEmpty){
                      return 'başlık boş olamaz';

                    }
                  },
                  onSaved: ((newValue) {
                    notBaslik=newValue;
                  }),
                  decoration: InputDecoration(
                    hintText: "Not başlığını giriniz",
                    labelText: "Başlık",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),

                  ),
                ),
              ),
                  Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: widget.duzenlenecekNot!= null ? widget.duzenlenecekNot!.notIcerik : "",
                  onSaved: (newValue) {
                    notIcerik=newValue;
                  },
                  maxLines:4 ,
                  decoration: InputDecoration(
                    hintText: "Not içeriğini giriniz",
                  
                    
                    labelText: "İçerik",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12),),
                
                    
                    ),

                  ),
                ),
                  ),
                       Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text("Öncelik:",style: TextStyle(fontSize: 24),),
                  ),
                  Container(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    items: buildOncelikItem(),
                    

                 value: widget.duzenlenecekNot != null ? widget.duzenlenecekNot!.notOncelik : secilenoncelik,onChanged: (value) {
                  setState(() {
                    secilenoncelik=value!;
                  });
                },)
                ),
                padding: EdgeInsets.symmetric(vertical: 2,horizontal: 20),
                margin: EdgeInsets.all(12),
                 decoration: BoxDecoration(
                 border: Border.all(color: Colors.redAccent,width: 2),
                 borderRadius: BorderRadius.all(Radius.circular(10))
              )
              ),
                ],
              ),

              ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                                children: [
                  ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),onPressed: (){
                    Navigator.pop(context);

                  }, child: Text("Vazgeç",style: TextStyle(fontSize: 24),)),
                         ElevatedButton(onPressed: (){
                          if(formKey.currentState!.validate()){
                            formKey.currentState!.save();
                            var suan = DateTime.now();
                            if(widget.duzenlenecekNot ==null){
                            notlarDao.insertNot(Not(kategoriID, notBaslik!, notIcerik!,suan.toString(), secilenoncelik)).then((value) => {
                              
                              if(value !=0){
                                Navigator.pop(context),
                                setState(() {
                                  
                                }),
                              }
                            });

                            }else{
                              notlarDao.updateNot(Not.withID(widget.duzenlenecekNot!.notId,kategoriID, notBaslik!, notIcerik!,suan.toString(),secilenoncelik)).then((value) {
                                        
                              if(value !=0){
                                
                                setState(() {
                                  
                                });
                                Navigator.pop(context);
                              }
                              });
                            }
                    
                            
                          }

                  }, child: Text("Tamam",style: TextStyle(fontSize: 24),)),
                ],
              )
              
  
            ],
          ) ,
        ) ,
      )
    );
  }
  
  
  List<DropdownMenuItem<int>>  buildKategoriItem() {

    return tumKategoriler.map((kategori) => DropdownMenuItem<int>(value: kategori.kategoriID,child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(kategori.kategoriBaslik!,style:TextStyle(fontSize: 24) ,),
    ))).toList();

  }

    List<DropdownMenuItem<int>>  buildOncelikItem() {
    return _oncelik.map((oncelik) => DropdownMenuItem<int>(value: _oncelik.indexOf(oncelik),child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(oncelik,style:TextStyle(fontSize: 24) ,),
    ))).toList();

  }
}

