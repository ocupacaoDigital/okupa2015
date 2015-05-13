void Init_Fisica(){
  
  Fisica.init(this);
  world = new FWorld();
  world.setEdges();  // paredes ao redor da tela
  world.remove(world.top);
  world.setGravity(0,0);
  world.setGrabbable(false); // objetos do fisica podem ser arrastados pelo mouse por default
  
  FLine top = new FLine(width, 0, 0, 0);
  top.setPosition(0, 50);
  world.add(top);
  
  p = new FPoly[int(playerCount.n)];
  for( int i = 0; i < playerCount.n; i++ ){
    p[i] = new Fpoly();
    p[i].setFill( players.get(i).c );
    p[i].setDamping(1.5);
    p[i].setFriction(0.9);
    
    float x = currentMap.startingLocations.get(i).x;
    float y = currentMap.startingLocations.get(i).y;
    float l = 0;
    switch( players.get(i).shape ){
      case 't': 
      l = tri_l;
      float k = l * sqrt(3) * (1/6f);
      p[i].vertex(x + (l/2f), y + k );
      p[i].vertex(x - (l/2f), y + k);
      p[i].vertex(x, y - 2*k);
      break;
      case 's':
      l = square_l / 2f;
      p[i].vertex(x - l, y - l);
      p[i].vertex(x - l, y + l);
      p[i].vertex(x + l, y + l);
      p[i].vertex(x + l, y - l);
      break;
      case 'p': 
      l = penta_l;
      float k = l / 1.175570505;
      float a = TWO_PI/5f;
      float o = - HALF_PI;
      for(int i = 0; i < 5; i ++){
        p[i].vertex( x + k * cos( (i * a) + o ), y + k * sin( (i * a) + o ) );
      }
      break;
      case 'h': 
      l = hex_l;
      float k = PI/3f;
      p[i].vertex(x + l, y);
      p[i].vertex(x + l * cos(k), y + l * sin(k));
      p[i].vertex(x + l * cos(2*k), y + l * sin(2*k));
      p[i].vertex(x - l, y);
      p[i].vertex(x + l * cos(-2*k), y + l * sin(-2*k));
      p[i].vertex(x + l * cos(-k), y + l * sin(-k));
      break;
    }
    
    world.add(p[i]);
  }
  
  wall = new FBox[50];
}
//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//
//|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\

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
   cmds = new ArrayList();
   players = new ArrayList();
   players.add( new Player() );
   players.add( new Player() );
}
