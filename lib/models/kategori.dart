class Kategori {
  int? kategoriID;
  String? kategoriBaslik;


 

 Kategori(this.kategoriBaslik);
  
  Kategori.withID(this.kategoriID, this.kategoriBaslik);

  Map<String,dynamic> toMap(){
    var map =Map<String,dynamic>();
    map['kategoriID'] = kategoriID;
    map['kategoriBaslik'] = kategoriBaslik;
    return map;
  }

  Kategori.fromMap(Map<dynamic,dynamic> map){
    this.kategoriID = map['kategoriID'];
    this.kategoriBaslik = map['kategoriBaslik'];
  }

  String toString(){
    return 'Kategeroi{kategoriID:$kategoriID,kategoriBaslik:$kategoriBaslik}';
  }
  
}