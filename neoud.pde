//************************************************class noeud

class noeud {

  //************************************************variables

  int x;
  int y;
  int taille;
  boolean activable=true;
  color couleur = color(#29C4FF);

  boolean depart = false;
  boolean fin = false;
  boolean wall = false;
  
  ArrayList<noeud> precedent  = new ArrayList<noeud>();

  //************************************************constructeur

  noeud( int x, int y, int taille) {
    this.x=x;
    this.y=y;
    this.taille=taille;
  }

  //************************************************affichage

  void affiche() {

    stroke(0);

    if (depart) {
      fill(0, 200, 0);
    } else if (fin) {
      fill(200, 20, 0);
    } else if (wall) {
      fill(0);
    } else {
      fill(couleur);
    }

    rect(x, y, taille, taille);
  }  

  //************************************************setter type

  void setType(boolean debut, boolean fin, boolean wall) {
    if (!this.depart && !this.fin) {
      this.depart=debut;
      this.wall=wall;
      this.fin=fin;
      activable=!debut;
    }
  }
  
   //************************************************setter and getter precedent
   
   void newPreced(noeud in){
     precedent.add(in);
   }
   
   noeud getPreced(){
    return  precedent.get(0);
   }

  //************************************************setter couleur

  void setCouleur(color in) {
    couleur=in;
  }
  
  //************************************************getter wall
  boolean isNotWall() {
    return !wall;
  }
  
    //************************************************getter fin
  boolean isEnd() {
    return fin;
  }
  
      //************************************************getter start
  boolean isNotStart() {
    return !depart;
  }

  //************************************************getter de position et taille

  PVector getPosition() {
    return(new PVector(this.x, this.y));
  }

  int getTaille() {
    return this.taille;
  }

  //************************************************getter et setter de boolean activable

  boolean getActivable() {
    return this.activable;
  }

  void setActivable(boolean in) {
    this.activable=in;
  }
}
