import 'package:flutter/cupertino.dart';

class Article {
   int id;
   String nom;
   int item ;   // item ou il appartient
   var prix ;  // var because the user can put an int or a double (more sur for avoid crash)
   String magasin;
   String image;

   Article();

   void fromMap(Map<String, dynamic> map) {
       this.id = map['id'];
       this.nom = map['nom'];
       this.item = map['item'];
       this.prix = map['prix'];
       this.magasin = map['magasin'];
       this.image = map['image'];
   }

   Map<String, dynamic> toMap() {
        Map<String, dynamic> map = {
             'nom': this.nom,
             'item': this.item,
             'magasin': this.magasin,
             'prix': this.prix,
             'image': this.image
        };
        if(id != null) {
             map['id'] = this.id;
        }
        return map;
   }
}