import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'article.dart';
import 'item.dart';

class DatabaseClient {
  Database _database;  // _ => that means is private, we can pass for the fonction like getter on symfony

  Future<Database> get database async {   // for get private value
    // verify if database exist
    if(_database != null) {
      return _database;
    } else {
      // Créez cette database
      _database = await create();
      return _database;
    }
  }

  // function create database
  Future create() async {
    Directory directory = await getApplicationDocumentsDirectory(); // recup document    // must import dart io and path
    // transform it to string
    String databasa_directory = join(directory.path, 'database.db');
    var bdd = await openDatabase(databasa_directory, version: 1, onCreate: _onCreate);
    return bdd;
  }

  // we do our request to create all table here
  Future _onCreate(Database db, int version) async {
    // create table item with id and nom
    await db.execute('''
            CREATE TABLE item (                         
            id INTEGER PRIMARY KEY, 
            nom TEXT NOT NULL)
        ''');

    // create table article
    print('db is here');
    await db.execute(
       ''' 
       CREATE TABLE article (
           id INTEGER PRIMARY KEY,
           nom TEXT NOT NULL,
           item integer,
           prix TEXT,
           magasin TEXT,
           image TEXT
       )
       '''
    );
  }

  /*  ******************************** ECRITURE DES DONNEES ************************************** */

  Future<Item> ajoutItem (Item item) async {
      //verify if db is ready create by calling function database
      Database maDatabase = await database;
      // this goes give us an int, that going to affect to item.id
      item.id = await maDatabase.insert('item', item.toMap());   // insert item.toMap() (give us an string nom) in table item
      return item;
  }

  Future<int> delete(int id, String table) async {
      Database maDatabase = await database;
      // for delete article's list also
      await maDatabase.delete('article', where: 'item', whereArgs: [id]);
      // (where: 'id = ?') => look side where we have id and (whereArgs: [id]) => where id = id then we delete in the table
      return await maDatabase.delete(table, where: 'id = ?', whereArgs: [id] );
  }

  Future<int> updateItem(Item item) async{
      Database maDatabase = await database;
      return await maDatabase.update('item', item.toMap(), where:  'id = ?', whereArgs: [item.id]);
  }

  // update or insert depends item
  Future<Item> upsertItem(Item item) async {
      Database maDatabase = await database;
      if (item.id == null) {
        item.id = await maDatabase.insert('item', item.toMap());
      } else {
         await maDatabase.update('item', item.toMap(), where:  'id = ?', whereArgs: [item.id]);
      }
      return item;
  }

  Future<Article> upsertArticle(Article article) async{
       Database maDatabase = await database;
       (article.id == null) ?
       article.id == await maDatabase.insert('article', article.toMap()) :
       await maDatabase.update('article', article.toMap(), where: 'id = ?', whereArgs: [article.id]);

       return article;
  }
  /*  ******************************** LECTURE DES DONNEES ************************************** */

  Future<List<Item>> allItem() async {
      Database maDatabase = await database;
      //  select all we have in the table item
      List<Map<String, dynamic>> resultat = await maDatabase.rawQuery('SELECT * FROM item');
      List<Item> items = []; // empty list

      resultat.forEach((map) {          // the list contain map
          Item item = new Item();  // create item each time
          item.fromMap(map);
          items.add(item);   // add the item in the list items
      });
      return items;  // return items;
  }

  Future<List<Article>> allArticles(int item) async { // item because we get article from a item specific
      Database maDatabase = await database;
      List<Map<String, dynamic>> resultat = await maDatabase.query('article', where: 'item = ?', whereArgs:  [item]); //get articles on a item
      List<Article> articles = [];
      resultat.forEach((map) {
          Article article = new Article();
          article.fromMap(map);
          articles.add(article);
      });
      return articles;
  }

}