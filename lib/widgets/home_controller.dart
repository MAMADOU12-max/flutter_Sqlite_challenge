import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sqlite_app_challenge/modal/databaseClient.dart';
import 'package:sqlite_app_challenge/modal/item.dart';
import 'package:sqlite_app_challenge/widgets/itemDetail.dart';
import 'donnees_vides.dart';


class HomeController extends StatefulWidget {
  HomeController({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {


  String nouvelleListe;
  List<Item> items;

  @override
  void initState() {
     super.initState();
     recuperer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(
              onPressed: (() =>addingOrupdate(null)),
              child: Text(
                'Ajouter',
                style: TextStyle(
                    color: Colors.white
                ),
              )
          )
        ],
        centerTitle: true,
      ),
      body: (items == null || items.length == 0)
          ? new DonneesVides()
          : new ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, i) {
             Item item = items[i];
              return new ListTile(
                  title: new Text(item.nom),
                  trailing: new IconButton(
                      icon: new Icon(Icons.delete),
                      onPressed: () {
                         DatabaseClient().delete(item.id, 'item').then((int)  {
                           print("L'int recuperer est : $int ");
                           recuperer();
                     });
                  }),
                  leading: new IconButton(
                      icon: new Icon(Icons.edit),
                      onPressed: (() =>addingOrupdate(item)),
                  ),
                 onTap: () {
                     Navigator.push(
                         context, MaterialPageRoute(builder: (BuildContext buildContext) {
                             return new ItemDetail(item);
                        }),
                     );
                 },
              );
          }
      ),
    );
  }

  Future<Null> addingOrupdate(Item item) async {
    return showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: new Text('Ajouter une liste de souhaits'),
            content: new TextField(
              decoration: new InputDecoration(
                  labelText: 'Liste',
                  hintText: (item == null) ? "ex: mes prochains jeux vidéos" : item.nom
              ),
              onChanged: (String str) {
                setState(() {
                  nouvelleListe = str;
                });
              },
            ),
            actions: [
              new TextButton(onPressed: (() => Navigator.pop(buildContext)), child: new Text('Annuler', style: TextStyle(color: Colors.red))),
              new TextButton(
                  onPressed: () {
                    // Ajouter le code pour pouvoir ajouter à la base de donnée
                    if(nouvelleListe != null) {
                        if(item == null) {   // we're going to create a new
                            item = new Item();
                            Map<String, dynamic> map =  {'nom': nouvelleListe};
                            item.fromMap(map);
                        } else {  // we update
                             item.nom = nouvelleListe;
                        }
                        DatabaseClient().upsertItem(item).then((i) => recuperer()) ; // update database after add
                        nouvelleListe = null; // after adding
                    }
                    Navigator.pop(buildContext);
                  },
                  child: new Text('Valider')),
            ],
          );
        });
  }

  void recuperer () {
     DatabaseClient().allItem().then((items) {
         setState(() {
            this.items = items;
         });
     });
  }
}
