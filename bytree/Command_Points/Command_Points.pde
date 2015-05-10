import fisica.util.nonconvex.*;
import fisica.*;
FWorld world; // variavel 'mundo' do fisica.

boolean up, down, left, right, w, a, s, d;
float Acmds, scoreBar;

UISet MainMenu, PlayerOptions;

Editor mapEditor;

ArrayList<CommandPt> cmds;

ArrayList<Player> players;

FBox[] p;
FBox p1, p2;
FBox [] wall;

int W=0,C=0, wait=0;

letter moment;
PFont big, small;

boolean conquer=true, timer=false;

boolean sketchFullScreen(){
 return true; 
}

void setup(){
  size(displayWidth, displayHeight);
  /*
  big = loadFont("AgencyFB-Bold-40.vlw");
  small = loadFont("AgencyFB-Bold-30.vlw");
  CmdPtIcon = loadImage("CmdPt icon.png");
  WallsIcon= loadImage("Walls icon.png");
  TilesIcon= loadImage("Tiles icon.png");
  */
  imageMode(CENTER);
  frameRate(60);
  //rectMode(CENTER);
  colorMode(RGB);
  textsize = 16;
  textSize(textsize);
  
  Init_Fisica();
  init_game();
  init_MainMenu_UI();
  init_Options_UI();
  init_sides( 30 );
  

}
void draw(){
  //println(frameRate);
  background(255);
  switch( moment.l ){ //|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\
    case 'm'://MAIN MENU|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//
    
      MainMenu.exe();
      
      break; //|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//
    case 'f'://PRE-GAME/|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\
    
      scoreBar=(3/5f)*width;
      Acmds=0;
      for(int i=0; i<10; i++){
        if(cmds.get(i).type() == 'a'){
          Acmds++;
        }
      }
     moment.l = 'g'; 
     

      break; //|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//
    case 'g'://GAME\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\
      /*
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
      */
      break; //|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//
    case 'e'://EDITOR|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\
      
      mapEditor.exe();
      
      break; //|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//
    case 'o'://|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\
    
      Options();
      
      break; //|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//
    case 'c'://|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\
    
      background(130);
      text("Created by J.F.", width/2f - textWidth("Created by J.F")/2f, height/5f);
      text("With Processing", width/2f - textWidth("With Processing")/2f, height*(2/5f));
      text("***", width/2f - textWidth("***")/2f, height*(2.8/5f));
      text("introscopia.tumblr.com", width/2f - textWidth("introscopia.tumblr.com")/2f, height*(2/3f));
      text("Processing.org", width/2f - textWidth("Processing.org")/2f, height*(4/5f));
      
      break;//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//
    case 'x'://EXIT\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\
    
      exit();
      
      break;
    default:
      moment.l = 'm';
      break;
  }

}
  
