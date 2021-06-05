import 'dart:io';
import 'package:sqlite_app_challenge/modal/article.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_app_challenge/modal/databaseClient.dart';
import 'package:image_picker/image_picker.dart';

class AjoutArticle extends StatefulWidget {
  int id;

 AjoutArticle(this.id);

  @override
  _AjoutArticleState createState() => _AjoutArticleState();
}

class _AjoutArticleState extends State<AjoutArticle> {

  String image;
  String nom;
  String magasin;
  String prix;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
       appBar: AppBar(
          title: new Text('Ajouter un nouveau article'),
          actions: [
             new TextButton(
                 onPressed: ajouter,
                 child: Text(
                    'Valider',
                     style: TextStyle(
                        color: Colors.white,
                     ),
                 )
             )
          ],
       ),
       body: new SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
             children: [
                 Text(
                       'Article à ajouter',
                       textScaleFactor: 1.4,
                       style: TextStyle(
                           color: Colors.red,
                           fontStyle: FontStyle.italic
                       ),
                  ),
                  Card(
                     elevation: 10.0,
                     child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           (image == null) ? Image.asset('images/avatar.jpeg') : Image.file(new File (image)),  // must import dart io for use File
                           Row(
                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               children: [
                                   IconButton(
                                     icon: Icon(
                                       Icons.camera_enhance),
                                     onPressed: (() =>getImage(ImageSource.camera)),
                                   ),
                                   IconButton(
                                     icon: Icon(Icons.photo_library),
                                     onPressed: (() => getImage(ImageSource.gallery)),
                                   ),
                               ]
                           ),
                          textField(TypeTextField.nom, 'Nom de l\'article'),
                          textField(TypeTextField.prix, 'prix'),
                          textField(TypeTextField.magasin, 'magasin'),
                        ],
                     ),
                  )
             ],
          ),
       ),
    );
  }

  TextField textField(TypeTextField type, String label) {
     return new TextField(
        decoration: InputDecoration(labelText: label),
        onChanged: (String string) {
           switch(type) {
             case TypeTextField.nom:
                nom = string;
                break;
             case TypeTextField.prix:
                prix = string;
                break;
             case TypeTextField.magasin:
               magasin = string;
               break;
           }
        },
     );
  }

  void ajouter() {
      if(nom != null) {
         Map<String, dynamic> map = { 'nom': nom, 'item': widget.id } ;

         if(magasin != null) {
            map['magasin'] = magasin;
         }
         if(prix != null) {
           map['prix'] = prix;
         }
         if(image != null) {
           map['image'] = image;
         }

         Article article = new Article();
         article.fromMap(map);
         DatabaseClient().upsertArticle(article).then((value) => {
           // re-initialise all
            image = null ,
             nom = null,
             magasin = null,
             prix = null,
            Navigator.pop(context),

         });
     }
  }

  Future getImage(ImageSource source) async {
    PickedFile nouvelleImage = await ImagePicker().getImage(source: source);
    setState(() {
       image = nouvelleImage.path;
    });
  }
}

enum TypeTextField{
    nom, prix, magasin
}