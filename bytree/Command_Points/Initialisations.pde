void init_fisica_world(){
  Fisica.init(this);
  world = new FWorld();
  world.setEdges();  // paredes ao redor da tela
  world.remove(world.top);
  world.setGravity(0,0);
  world.setGrabbable(false); // objetos do fisica podem ser arrastados pelo mouse por default
  
  FLine top = new FLine(width, 0, 0, 0);
  top.setPosition(0, header);
  world.add(top);
}

void init_fisica_player(int i, FPoly fp, int scale){
  fp.setFill( red(players.get(i).c), green(players.get(i).c), blue(players.get(i).c) );
  fp.setDamping(1.5);
  fp.setFriction(0.9);
  
  float x = 0;
  float y = 0;
  
  assemble_player_shape( fp, scale, players.get(i).shape );
  
  switch(int(playerCount.n)){
    case 2:
      x = currentMap.startingLocations2[i].x;
      y = currentMap.startingLocations2[i].y;
      break;
    case 3:
      x = currentMap.startingLocations3[i].x;
      y = currentMap.startingLocations3[i].y;
      break;
    case 4:
      x = currentMap.startingLocations4[i].x;
      y = currentMap.startingLocations4[i].y;
      break;
  }
  
  fp.setPosition(x, y);
  
  world.add(fp);
}

void assemble_player_shape( FPoly fp, float l, char s ){
  switch( s ){
    case 't': 
    l *= tri_l;
    float k = l * sqrt(3) * (1/6f);
    fp.vertex((l/2f), k );
    fp.vertex(-(l/2f), k);
    fp.vertex(0, -2*k);
    break;
    case 's':
    l *= square_l / 2f;
    fp.vertex(-l, -l);
    fp.vertex(-l, l);
    fp.vertex(l, l);
    fp.vertex(l, -l);
    break;
    case 'p': 
    l *= penta_l;
    k = l / 1.175570505;
    float a = TWO_PI/5f;
    float o = - HALF_PI;
    for(int r = 0; r < 5; r ++){
      fp.vertex( k * cos( (r * a) + o ), k * sin( (r * a) + o ) );
    }
    break;
    case 'h': 
    l *= hex_l;
    k = PI/3f;
    fp.vertex(l, 0);
    fp.vertex(l * cos(k), l * sin(k));
    fp.vertex(l * cos(2*k), l * sin(2*k));
    fp.vertex(-l, 0);
    fp.vertex(l * cos(-2*k), l * sin(-2*k));
    fp.vertex(l * cos(-k), l * sin(-k));
    break;
  }
}
//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//
//|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\
void load_Icons(){
  icons = new PImage[6];
  icons[0] = loadImage("Lock.png");
  icons[1] = loadImage("Bomb.png");
  icons[2] = loadImage("Freeze.png");
  icons[3] = loadImage("CmdPt icon.png");
  icons[4] = loadImage("Speed.png");
  icons[5] = loadImage("Weight.png");
  int iconEdge = 50;
  icons[0].resize(iconEdge, iconEdge);
  icons[1].resize(iconEdge, iconEdge);
  icons[2].resize(iconEdge, iconEdge);
  icons[3].resize(iconEdge, iconEdge);
  icons[4].resize(iconEdge, iconEdge);
  icons[5].resize(iconEdge, iconEdge);
}
void init_MainMenu_UI(){
  moment = new letter('m');
  
  MainMenu = new UISet( 12, 5, 12, 0.95, 0.95 );
  MainMenu.setScheme( #FC9C00,  30); //color(255, 19, 26)
  MainMenu.beginColumn(2, 6);
  MainMenu.addCharSet("Play", 'c', moment, 'f');
  MainMenu.addCharSet("Settings", 'c', moment, 'o');
  MainMenu.addCharSet("Map Editor", 'c', moment, 'e');
  MainMenu.addCharSet("Credits", 'c', moment, 'c');
  MainMenu.addCharSet("Exit", 'c', moment, 'x');
  
  header = 12 + (2/13f)*height;
}

//@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q@Q

void init_Options_UI(){
  playerCount = new number(2);
  selectedPlayer = new number(0);
  assignShape = new letter( players.get(0).shape );
  assignColor = new pigment( players.get(0).c );
  
  Settings = new UISet( 12, 9, 13, 1, 0.8 );
  Settings.setScheme( #FC9C00,  30);
  //Settings.beginColumn(0, 1);
  Settings.addLabel(0, 0, "Player Count:", 'c');
  Settings.addPlusMinus(1, 0, playerCount, true, 1, 2, 4);
  for( int i = 0; i < playerCount.n; i++ ){
    Settings.addNumSet( i, 1, "P"+str(i+1), 'c', selectedPlayer, i);
  }
  Settings.beginRow(0, 2);
  Settings.addCharSet("Triangle", 'c', assignShape, 't');
  Settings.addCharSet("Square", 'c', assignShape, 's');
  Settings.addCharSet("Pentagon", 'c', assignShape, 'p');
  Settings.addCharSet("Hexagon", 'c', assignShape, 'h');
  Settings.endRow();
  Settings.addCharSet(8, 12, "Done", 'c', moment, 'm');
  Settings.V_percent = 9.8;
  Settings.addColorSelector(0, 3, assignColor);
  Settings.V_percent = 0.8;
  Settings.get("colorSelector").setColor( players.get(0).c );
 // Settings.add();
}

void init_game(){
   //cmds = new ArrayList();
   players = new ArrayList();
   players.add( new Player() );
   players.add( new Player() );
   players.get(0).c = #007aff;
   players.get(1).c = #ff9f00;
   players.get(0).fireKey = ' ';
   players.get(1).fireKey = ENTER;
   //players.get(0).receive_Item( new Lock( 'l', 100) );
   //players.get(1).receive_Item( new Bomb( 'b', 100 ) );
   
   //currentMap = new Map( 
}
