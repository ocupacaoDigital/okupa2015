import fisica.util.nonconvex.*;
import fisica.*;
FWorld world; // variavel 'mundo' do fisica.

boolean up, down, left, right, w, a, s, d;

float header;
PImage[] icons;

UISet MainMenu, Settings;

Editor mapEditor;

Map currentMap;

Header theHeader;

ArrayList<Player> players;

FPoly[] p;
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
  strokeCap(SQUARE);
  
  init_game();
  init_MainMenu_UI();
  init_Options_UI();
  init_sides( 30 );
  init_fisica_world();
  thread("load_Icons");
  mapEditor = new Editor();
}
void draw(){
  println(frameRate);
  background(255);
  switch( moment.l ){ //|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\
    case 'm'://MAIN MENU|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//
    
      MainMenu.exe();
      
      break; //|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//
    case 'f'://PRE-GAME/|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\
    
      p = new FPoly[int(playerCount.n)];
      for( int i = 0; i < playerCount.n; i++ ){
        p[i] = new FPoly();
        init_fisica_player(i, p[i], 1);
      }
      wall = new FBox[50];
      
      currentMap.initWalls();
      
      theHeader = new Header();
      
      /*
      scoreBar=(3/5f)*width;
      Acmds=0;
      for(int i=0; i<10; i++){
        if(cmds.get(i).type() == 'a'){
          Acmds++;
        }
      }
      */
     moment.l = 'g'; 
     

      break; //|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//
    case 'g'://GAME\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\
      
      currentMap.exe();
      
      for(int i = 0; i < players.size(); i++){
        players.get(i).exe(i);
      }
      
      if( players.get(0).frozen == 0 ){
        PVector wasd = wasdControls(players.get(0).acc);
        p[0].addForce(wasd.x, wasd.y);
      }
      if( players.get(1).frozen == 0 ){
        PVector arrows = arrowControls(players.get(1).acc);   
        p[1].addForce(arrows.x, arrows.y);
      }
      
      world.step();
      world.draw();
      
      theHeader.exe();
      
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
  
