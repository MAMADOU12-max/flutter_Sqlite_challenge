import 'package:flutter/material.dart';
import 'package:sqlite_app_challenge/modal/item.dart';
import 'package:sqlite_app_challenge/modal/article.dart';
import 'package:sqlite_app_challenge/widgets/ajout_article.dart';
import 'donnees_vides.dart';
import 'package:sqlite_app_challenge/modal/databaseClient.dart';
import 'dart:io';

class ItemDetail extends StatefulWidget {
    Item item;
    ItemDetail(this.item)  ;

    @override
    _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {

    List<Article> articles;

    @override
    void initState() {
       super.initState();
       DatabaseClient().allArticles(widget.item.id).then((liste) {
           setState(() {
              articles = liste;
           });
       });
    }

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
             appBar: AppBar(
                 title: new Text(widget.item.nom),
                 actions: [
                      new TextButton(
                          onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                  return new AjoutArticle(widget.item.id);
                              })).then((value) => {
                                DatabaseClient().allArticles(widget.item.id).then((liste) {  // actualise after add directly
                                  print('On est de retour');
                                    setState(() {
                                    articles = liste;
                                    });
                                }),
                              });
                          },
                          child: Text(
                              'Ajouter',
                               style: TextStyle(
                                    color: Colors.white
                               ),
                          )
                      ),
                 ],
             ),
            body: (articles == null || articles.length == 0)
            ? new DonneesVides()
            : new GridView.builder(
                itemCount: articles.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemBuilder: (context, i) {
                    Article article = articles[i];
                    return new Card(
                      child: Column(
                         children: [
                            Text(article.nom),
                           (article.image == null)
                           ? new Image.asset('images/avatar.jpeg')
                           : Image.file(new File(article.image)),
                           Text((article.prix == null) ? 'Aucun prix renseigné': "Prix: ${article.prix}"),
                           Text((article.magasin == null) ? 'Aucun magasin renseigné': "Magasin: ${article.magasin}"),
                         ],
                      ),
                    );
                }
            ),
        );
    }
}

