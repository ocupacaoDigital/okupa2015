import fisica.util.nonconvex.*;
import fisica.*;
FWorld world; // variavel 'mundo' do fisica.

boolean up, down, left, right, w, a, s, d;

CommandPt[] cmds;
FBox[] players;
FBox [] wall;

int W=0,C=0, wait=0;

letter moment='m';
PFont big, small;

boolean conquer=true, timer=false;

void setup(){
  size(700, 650);
  frameRate(60);
  rectMode(CENTER);
  colorMode(RGB);
  big = loadFont("AgencyFB-Bold-40.vlw");
  small = loadFont("AgencyFB-Bold-30.vlw");
  CmdPtIcon = loadImage("CmdPt icon.png");
  WallsIcon= loadImage("Walls icon.png");
  TilesIcon= loadImage("Tiles icon.png");
  imageMode(CENTER);
  
  cmds = new CommandPt[100];
  for(int i=0; i<100; i++){
    cmds[i] = new CommandPt();
  }
  
  Fisica.init(this);
  world = new FWorld();
  world.setEdges();  // paredes ao redor da tela
  world.remove(world.top);
  world.setGravity(0,0);
  world.setGrabbable(false); // objetos do fisica podem ser arrastados pelo mouse por default
  
  FLine top = new FLine(width, 0, 0, 0);
  top.setPosition(0, 50);
  world.add(top);
  
  p1 = new FBox(20, 20);
  p1.setPosition(width/5f, height/2f);
  p1.setAllowSleeping(false);
  R1=random(0,255); G1=random(0,255); B1=random(0,255);
  p1.setFill(R1, G1, B1);
  //p1.setDamping();  //"resistencia do ar"
  p1.setFriction(0.9);
  world.add(p1);
  
  p2 = new FBox(20, 20);
  p2.setPosition((4/5f)*width, (height/2f));
  p2.setAllowSleeping(false);
  R2=random(0,255); G2=random(0,255); B2=random(0,255);
  p2.setFill(R2, G2, B2);
  p2.setDamping(1.5);
  p2.setFriction(0.9);
  world.add(p2);
  
  wall = new FBox[35];
}
void draw(){
  //println(frameRate);
  switch( moment ){
    case 'm':
    
      break;
    case 'f':
    
      break;
    case 'g':
    
      break;
    case 'e':
    
      break;
    case 'o':
    
      break;
    case 'c':
    
      break;
  }

  else if(moment == 'f'){ //moment pre-jogo
    scoreBar=(3/5f)*width;
    Acmds=0;
    for(int i=0; i<10; i++){
      if(cmds[i].type() == 'a'){
        Acmds++;
      }
    }
   moment = 'g'; 
  }
  else if(moment == 'g'){ //game
    background(230);
    fill(130);
    rect(width/2f,25,width, 50);

    if(conquer){      //conquer eh o modo de jogo onde se tem que capturar todos os commands tipo "A"
      fill(R1, G1, B1);
      rect( (width/5f)+(p1Ownage/2f), 25, p1Ownage, 30);
      fill(255);
      rect((width/5f)+p1Ownage+((scoreBar-p1Ownage-p2Ownage)/2f), 25, scoreBar-p1Ownage-p2Ownage, 30);
      fill(R2, G2, B2);
      rect( (width*(4/5f))-(p2Ownage/2f), 25, p2Ownage, 30);
      
      fill(R1, G1, B1);
      text(p1Wins, 20, 40);
      fill(R2, G2, B2);
      text(p2Wins, width-20-textWidth("0"), 40);
      if(p1Ownage == scoreBar){
        p1Wins++;
        for(int i=0; i<10; i++){
          if(cmds[i].active){
            cmds[i].setOwner(0);
          }
          p1.setWidth(18);
          p1.setHeight(18);
          p2.setWidth(18);
          p2.setHeight(18);
        }
        p1.setPosition(width/5f, height/2f);
        p2.setPosition((4/5f)*width, (height/2f));
      }
      else if(p2Ownage == scoreBar){
        p2Wins++;
        for(int i=0; i<10; i++){
          if(cmds[i].active){
            cmds[i].setOwner(0);
          }
          p1.setWidth(18);
          p1.setHeight(18);
          p2.setWidth(18);
          p2.setHeight(18);
        }
        p1.setPosition(width/5f, height/2f);
        p2.setPosition((4/5f)*width, (height/2f));
      }
      p1Ownage=0;p2Ownage=0;
      for(int i=0; i<10; i++){
        if(cmds[i].type() == 'a'){
          if(cmds[i].owner() < 0){
            p1Ownage += map(cmds[i].owner(), 0, -50, 0, scoreBar/Acmds);
          }
          else if(cmds[i].owner() > 0){
            p2Ownage += map(cmds[i].owner(), 0, 50, 0, scoreBar/Acmds);
          }
        }
      }
      
    }
    
    
    p1.addForce(wasdControls(p1acc).x, wasdControls(p1acc).y);  //effetuando os controles
    p2.addForce(arrowControls(p2acc).x, arrowControls(p2acc).y);
    
    //p1.setVelocity(wasdControls(100).x, wasdControls(100).y);  //controle sem inercia
    //p2.setVelocity(arrowControls(100).x, arrowControls(100).y);

    for(int i=0; i<10; i++){  //rodando os commands
      if(cmds[i].active){
        cmds[i].go();
      }
    }
    world.step(); //rodando o fisica
    world.draw();
    
  }
  else if(moment == 'e'){ 
    
    background(230);
    
    for(int i=0; i<10; i++){
      if(cmds[i].active){
        cmds[i].go();
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
  else if(moment == 'o'){ //isso fica na aba UI
    Options();
  }
  else if(moment == 'c'){
    background(130);
    text("Created by J.F.", width/2f - textWidth("Created by J.F")/2f, height/5f);
    text("With Processing", width/2f - textWidth("With Processing")/2f, height*(2/5f));
    text("***", width/2f - textWidth("***")/2f, height*(2.8/5f));
    text("introscopia.tumblr.com", width/2f - textWidth("introscopia.tumblr.com")/2f, height*(2/3f));
    text("Processing.org", width/2f - textWidth("Processing.org")/2f, height*(4/5f));
  }
}
  
