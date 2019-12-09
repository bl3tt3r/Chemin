//************************************************variables des noeuds
ArrayList<ArrayList<noeud>> lignes = new ArrayList<ArrayList<noeud>>();
ArrayList<noeud> temp= new ArrayList<noeud>();
ArrayList<noeud> trajetFinal= new ArrayList<noeud>();
int tempCPT=0;
int taille = 20 ;
noeud fini ;

//************************************************variables du jeu
boolean jeuPossible=true;
String codeErreur = "";
int evenementSouris = 0;

boolean jeuStart = false;
boolean jeuFini = false;

boolean tuto = true;

boolean wall=false;

void setup() {

  size(600, 600);
  //fullScreen();

  //************************************************varification de la taille de la fenetre
  if (width%taille!=0) {
    codeErreur+="- la largeur de la fenetre doit etre un multiple de la variable taille "+"\n";
    jeuPossible=false;
  }
  if (height%taille!=0) {
    codeErreur+="- la hauteur de la fenetre doit etre un multiple de la variable taille"+"\n";
    jeuPossible=false;
  }
  if (!jeuPossible) {
    codeErreur+="- "+width+" ou "+height+" n'est pas un multiple de "+taille;
  } else {//************************************************implementation des elements de type noeud dans le tableau lignes

    for (int l=0; l<height; l+=taille) {
      lignes.add(new ArrayList<noeud>());
      for (int c=0; c<width; c+=taille) {
        lignes.get(tempCPT).add(new noeud(c, l, taille));
      }
      tempCPT++;
      //println(lignes);
    }
  }
}

void draw() {
  if (!tuto) {
    background(51);
    if (jeuPossible) { //************************************************boucle principal du jeu

      if (wall && mouseX>0 && mouseX<width && mouseY>0 && mouseY<height) {
        changeBlock(mouseX, mouseY, false, false, true);
      }


      //************************************************affichage

      for (ArrayList<noeud> ligne : lignes) {
        for (noeud element : ligne) {
          element.affiche();
        }
      }

      //************************************************l'algo

      if (jeuStart) {

        for (int l=0; l<lignes.size(); l++) {
          for (int e=0; e<lignes.get(l).size(); e++) {

            if (!lignes.get(l).get(e).getActivable()) {

              if (l-1>=0) {
                if (lignes.get(l-1).get(e).isEnd()) {
                  jeuStart=false;
                  fini=lignes.get(l-1).get(e);
                  jeuFini=true;
                }
                if (lignes.get(l-1).get(e).getActivable() && lignes.get(l-1).get(e).isNotWall()) {
                  temp.add(lignes.get(l-1).get(e));
                  lignes.get(l-1).get(e).newPreced(lignes.get(l).get(e));
                }
              }

              if ( l+1<lignes.size()) {
                if (lignes.get(l+1).get(e).isEnd()) {
                  jeuStart=false;
                  fini=lignes.get(l+1).get(e);
                  jeuFini=true;
                }
                if (lignes.get(l+1).get(e).getActivable() && lignes.get(l+1).get(e).isNotWall()) {
                  temp.add(lignes.get(l+1).get(e));
                  lignes.get(l+1).get(e).newPreced(lignes.get(l).get(e));
                }
              }

              if (e-1>=0 ) {
                if (lignes.get(l).get(e-1).isEnd()) {
                  jeuStart=false;
                  fini=lignes.get(l).get(e-1);
                  jeuFini=true;
                }
                if (lignes.get(l).get(e-1).getActivable() && lignes.get(l).get(e-1).isNotWall()) {
                  temp.add(lignes.get(l).get(e-1));
                  lignes.get(l).get(e-1).newPreced(lignes.get(l).get(e));
                }
              }

              if (e+1<lignes.get(l).size()) {
                if (lignes.get(l).get(e+1).isEnd()) {
                  jeuStart=false;
                  fini=lignes.get(l).get(e+1);
                  jeuFini=true;
                }
                if (lignes.get(l).get(e+1).getActivable() && lignes.get(l).get(e+1).isNotWall()) {
                  temp.add(lignes.get(l).get(e+1));
                  lignes.get(l).get(e+1).newPreced(lignes.get(l).get(e));
                }
              }
            }
          }
        }

        //************************************************vague de propagation de l'algo

        for (noeud ne : temp) {
          ne.setCouleur(color(#A468F5)); //vague
          ne.setActivable(false);
        }
      } else if (jeuFini) {

        //************************************************affichage du trajet final via les predecesseurs de chaques elements

        while (fini.getPreced().isNotStart()) {
          trajetFinal.add(fini.getPreced());
          fini = fini.getPreced();
        }

        for (noeud ne : trajetFinal) {
          ne.setCouleur(color(#9AFC7D)); //trajet final
        }
      }
    } else { //************************************************affichage des messages d'erreurs si il y en a
      text(codeErreur, 20, 20);
    }
  } else {
    afficheTuto();
  }
}

//************************************************scan des evenements souris

void mousePressed() {
  if (!tuto) {
    if (mouseButton == LEFT) {
      if (evenementSouris==0) {
        changeBlock(mouseX, mouseY, true, false, false);
      } else if (evenementSouris==1) {
        changeBlock(mouseX, mouseY, false, true, false);
      } else {
        wall=true;
      }
    }
    evenementSouris++;
    if (mouseButton == RIGHT) {
      changeBlock(mouseX, mouseY, false, false, false);
    }
  }
}

void mouseReleased() {
  wall=false;
}

//************************************************fonction de changement de type de block

void changeBlock(int x, int y, boolean debut, boolean fin, boolean wall) {
  if (!jeuFini) {
    int ligne = y/taille ;
    int element = x/taille ;
    if (!lignes.get(ligne).get(element).isNotStart()) {
      evenementSouris--;
    } 
    lignes.get(ligne).get(element).setType(debut, fin, wall);
  }
}

//************************************************fonction de lancement du jeu via la touche ENTER

void keyPressed() {

  if (keyCode==10 && !jeuStart && tuto) {
    tuto=false;
  }

  if (keyCode==10 && !jeuStart && evenementSouris>1 && !jeuFini && !tuto) {
    jeuStart=true;
    println("L'algorithme commence . . .");
  }
}


void afficheTuto() {
  background(51);
  text(" - Clic gauche pour placer le START, le END puis les mures \n - Clic doit pour supprimer des mures \n - Touche ENTER pour lancer la simulation \n \n \n Touche ENTER pour SKIP =====>", 20, 20);
}
