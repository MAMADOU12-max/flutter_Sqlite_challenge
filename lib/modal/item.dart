class Item {
   int id;                                    // we need id for adding it in the database
   String nom;

   Item();                                    // default constructor is empty by default

   // recuperer les elements depuis map
   void fromMap(Map<String, dynamic> map) {   // we recup Map that take a string like key and value dynamic
      this.id = map['id'];
      this.nom = map['nom'];
   }

   // function pour les envoyer à notre map
   Map<String, dynamic> toMap() {
      Map<String, dynamic> map = {
          'nom': this.nom,
      };
      if(id != null) {              // if id exist
           map['id'] = this.id;
      }
      return map;
   }
}