

class Not {
   int? notId;
   int? kategoriID;
   String? kategoriBaslik;
   String? notBaslik;
   String? notIcerik;
   String? notTarih;
   int? notOncelik;

  Not(this.kategoriID,this.notBaslik,this.notIcerik,this.notTarih,this.notOncelik);
  Not.withID(this.notId,this.kategoriID,this.notBaslik,this.notIcerik,this.notTarih,this.notOncelik);

  Map<String,dynamic> toMap(){
    var map =Map<String, dynamic>();
    map['notID'] =notId;
    map['kategoriID'] =kategoriID;
    map['notBaslik'] =notBaslik;
    map['notIcerik'] =notIcerik;
    map['notTarih'] =notTarih;
    map['notOncelik'] =notOncelik;
    return map;
  }

  Not.fromMap(Map<dynamic,dynamic> map){
    this.notId = map['notID'];
    this.kategoriID = map['kategoriID'];
    this.kategoriBaslik = map['kategoriBaslik'];
    this.notBaslik = map['notBaslik'];
    this.notIcerik = map['notIcerik'];
    this.notTarih = map['notTarih'];
    this.notOncelik = map['notOncelik'];
  }
}
