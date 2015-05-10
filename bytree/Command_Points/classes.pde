
class Player{
  public color c; 
  public char shape;
  float ownage, score, acc;
  int wins;
  Player(){
    c = color(random(255), random(255), random(255));
    char s = ' ';
    switch( int(random(-0.4999, 3.4999))){
      case 0: s = 't'; break;
      case 1: s = 's'; break;
      case 2: s = 'p'; break;
      case 3: s = 'h'; break;
    }
    shape = s;
  }
}

class Editor{
  int W=0,C=0, wait=0;
  float xi, yi, xf, yf; //valores da criacao de paredes 
  char Otype='a'; // moment controla as telas(menus, jogo, editor..), tambem controla as funcoes do mouse dentro do mousePressed(), Otype: tipo de command
  PImage CmdPtIcon, WallsIcon, TilesIcon;
  boolean makingCmds=false, creatingWall=false, makingWalls=false, makingTiles=false, deleting=false, settingType=false, settingSize=false, settingEase=false, settingScoreRate=false;
  float Osize = 58, Oease = 1/90f, OscoreRate = 1/60f;
  
  Editor(){}
  
  void exe(){
    
    background(230);
      
      for(int i=0; i<10; i++){
        if(cmds.get(i).active){
          cmds.get(i).go();
        }
      }
      
      world.step(); 
      world.draw();
      
      
      if(makingCmds){                  //criando commands
        if(wait>0){wait--;}                           //este wait eh para se certificar de que, quando voce seleciona outro tipo de command, 
        float radius = 1.25*sqrt(2)*Osize/2f;         //voce nao acidentalmente coloca um command em baixo daquela janelinha de selecao, entao ele nao deixa criar por [wait] frames.
        if((mouseY > 50+radius)&&(mouseY < height-radius)&&(mouseX > radius)&&(mouseX < width-radius)){
        fill(255);
        ellipse(mouseX, mouseY, 1.25*sqrt(2)*Osize, 1.25*sqrt(2)*Osize);
        ellipse(mouseX, mouseY, sqrt(2)*Osize, sqrt(2)*Osize);
        rect(mouseX, mouseY, Osize, Osize);
        }
        
        textFont(small, 22);            //seletor de tipo
        if(settingType){fill(210);}
        else if(mouseX>135 && mouseX<225 && mouseY>11 && mouseY<39){fill(190);}
        else {fill(150);}
        rect(180, 25, 90, 28);
        fill(255);text("type:  "+Otype, 156, 32);
        if(settingType){
          fill(160);
          rect(180, 123, 90, 168);
          fill(0);
          text("a", 175, 60); text("b", 175, 88); text("c", 175, 116); text("d", 175, 144); text("s", 175, 172); text("w", 174, 199);
          line(135, 67, 225, 67); line(135, 95, 225, 95); line(135, 123, 225, 123); line(135, 151, 225, 151); line(135, 179, 225, 179);
        }
        
        fill(150);                 //slider de tamanho
        rect(300, 25, 130, 28);
        fill(255);text("size:", 241, 32);
        fill(160);rect(317, 25, 86, 16);
        fill(170);rect(map(Osize, 20, 80, 274, 360), 25, 8, 20);
        if(settingSize){
          Osize = map(mouseX, 274, 360, 20, 80);
          Osize = constrain(Osize, 20, 80);
        }
        
        fill(150);                  //slider de facilidade (ease)
        rect(440, 25, 130, 28);
        fill(255);text("ease:", 378, 32);
        fill(160);rect(458, 25, 86, 16);
        fill(170);rect(map(Oease, 1/600f, 1/60f, 415, 501), 25, 8, 20);
        if(settingEase){
          Oease = map(mouseX, 415, 501, 1/600f, 1/60f);
          Oease = constrain(Oease, 1/600f, 1/60f);
        }
        
        if(Otype == 'b' || Otype == 'c' || Otype == 'd'){       //slider de taxa de pontuacao, soh eh ativo nos tipos relevantes
          fill(150);
          rect(562.5, 25, 95, 28);
          fill(255);text("rate:", 520, 32);
          fill(160);rect(580, 25, 50, 16);
          fill(170);rect(map(OscoreRate, 1/180f, 5/60f, 555, 605), 25, 8, 20);
          if(settingScoreRate){
            OscoreRate = map(mouseX, 555, 605, 1/180f, 5/60f );
            OscoreRate = constrain(OscoreRate, 1/180f, 5/60f);
          }
        }
        
      }
      else if(creatingWall){
        strokeWeight(5);  //faz aquela linha preta pra vizualizar a parede que voce esta criando. a criacao em si acontece no mousePressed()
        line(xi, yi, mouseX, mouseY);
        strokeWeight(1);
      }
      
      fill(150);
      rect(width-25, 25, 30, 30);
      rect(width-65, 25, 30, 30);
    
  }
  
}

class CommandPt {
  float x, y, size, ease, owner, scoreRate;
  char type;
  boolean active;
  CommandPt(){
    active = false;
  }
  CommandPt(char type_, float x_, float y_, float size_, float ease_, float scoreRate_){
  x=x_;
  y=y_;
  size=size_;
  ease=ease_;                 //1/90f;
  owner=0;
  type = type_;
  scoreRate = scoreRate_;    //1/60f;
  active = true;
  /*
  types:
  a: standard
  b: dynamic, adds score
  c: subtracts from adversary
  d: robber
  s: speed bonus
  w: weight bonus
  */
}
  char type(){return type;}
  boolean active(){return active;}
  float owner(){return owner;}
  void setOwner(float owner_){owner=owner_;}
  void go(){
    if(owner<0){
      float theta = map(owner, -50.01, 0, 3*HALF_PI, -HALF_PI);
      fill(255);
      arc(x, y, 1.25*sqrt(2)*size, 1.25*sqrt(2)*size, theta, 3*HALF_PI, PIE);
      //fill(R1, G1, B1);
      arc(x, y, 1.25*sqrt(2)*size, 1.25*sqrt(2)*size, -HALF_PI, theta, PIE);
    }
    else if(owner>=0){
      float theta = map(owner, 0, 50.01, 3*HALF_PI, -HALF_PI);
      //fill(R2, G2, B2);
      arc(x, y, 1.25*sqrt(2)*size, 1.25*sqrt(2)*size, theta, 3*HALF_PI, PIE);
      fill(255);
      arc(x, y, 1.25*sqrt(2)*size, 1.25*sqrt(2)*size, -HALF_PI, theta, PIE);
    }
 
    fill(255);
    ellipse(x, y, sqrt(2)*size, sqrt(2)*size);
    
    boolean isp1=false, isp2=false;
    if((p1.getX()>(x-(size/2f)))&&(p1.getX()<(x+(size/2f)))&&(p1.getY()>(y-(size/2f)))&&(p1.getY()<(y+(size/2f)))){
      isp1 = true;
    }
    if((p2.getX()>(x-(size/2f)))&&(p2.getX()<(x+(size/2f)))&&(p2.getY()>(y-(size/2f)))&&(p2.getY()<(y+(size/2f)))){
      isp2 = true;
    }
    
    strokeWeight(2);
    if( isp1 && isp2 ){
      //stroke((R1+R2)/2f, (G1+G2)/2f, (B1+B2)/2f); 
      owner += (p2.getWidth()*ease)-(p1.getWidth()*ease);
    }
    else if(isp1){
      owner-=p1.getWidth()*ease;
      owner=constrain(owner, -50, 50);
      //stroke(R1, G1, B1);
    }
    else if(isp2){
      owner+=p2.getWidth()*ease;
      owner=constrain(owner, -50, 50);
      //stroke( R2, G2, B2);
    }
    rect(x, y, size, size);
    stroke(0);
    strokeWeight(1);
    
    if(type=='b'){
      if(owner < 0){
        //p1Score += map(owner, 0, -50, 0, 1)*scoreRate;
      }
      else if (owner > 0){
        //p2Score += map(owner, 0, 50, 0, 1)*scoreRate;
      }
    }
    else if(type=='c'){
      if(owner < 0){
        //p2Score -= map(owner, 0, -50, 0, 1)*scoreRate;
      }
      else if (owner > 0){
        //p1Score -= map(owner, 0, 50, 0, 1)*scoreRate;
      }
    }
    else if(type=='d'){
      if(owner < 0){
        //p1Score += map(owner, 0, -50, 0, 1)*scoreRate*0.5;
        //p2Score -= map(owner, 0, -50, 0, 1)*scoreRate*0.5;
      }
      else if (owner > 0){
        //p2Score += map(owner, 0, 50, 0, 1)*scoreRate*0.5;
        //p1Score -= map(owner, 0, 50, 0, 1)*scoreRate*0.5;
      }
    }
    else if(type=='s'){
      if(owner < 0){
        //p1acc = map(owner, 0, -50, 600, 750);
        //p2acc = map(owner, 0, 50, 600, 750);
      }
      else if (owner > 0){
        //p2acc = map(owner, 0, 50, 600, 750);
        //p1acc = map(owner, 0, -50, 600, 750);
      }
    }
    else if(type=='w'){
      if(isp1 || isp2){
        if(owner == -50){
         // p1.setWidth(25);
         // p1.setHeight(25);
         // p2.setWidth(20);
         // p2.setHeight(20);
        }
        else if(owner == 50){
          p1.setWidth(20);
          p1.setHeight(20);
          p2.setWidth(25);
          p2.setHeight(25);
        }
        /*
        if(owner < 0){
          p1.setWidth(map(owner, 0, -50, 18, 25));
          p1.setHeight(map(owner, 0, -50, 18, 25));
        }
        else if (owner > 0){
          p2.setWidth(map(owner, 0, 50, 18, 25));
          p2.setHeight(map(owner, 0, 50, 18, 25));
        }
        */
      }
    }
  }
}

boolean is(int i, float x, float y, float size){ //detecta a presenca do FBox dentro de uma regiao quadrada com centro x,y e lado size.
  boolean is = false;
  if (i == 1){
    if((p1.getX()>(x-(size/2f)))&&(p1.getX()<(x+(size/2f)))&&(p1.getY()>(y-(size/2f)))&&(p1.getY()<(y+(size/2f)))){
      is = true;
    }
  }
  else if (i == 2){
    if((p2.getX()>(x-(size/2f)))&&(p2.getX()<(x+(size/2f)))&&(p2.getY()>(y-(size/2f)))&&(p2.getY()<(y+(size/2f)))){
      is = true;
    }
  }
  return is;
}
