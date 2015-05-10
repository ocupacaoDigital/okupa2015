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
  
  p1 = new FBox(20, 20);
  p1.setPosition(width/5f, height/2f);
  p1.setAllowSleeping(false);
  //R1=random(0,255); G1=random(0,255); B1=random(0,255);
  //p1.setFill(R1, G1, B1);
  //p1.setDamping();  //"resistencia do ar"
  p1.setFriction(0.9);
  world.add(p1);
  
  p2 = new FBox(20, 20);
  p2.setPosition((4/5f)*width, (height/2f));
  p2.setAllowSleeping(false);
  //R2=random(0,255); G2=random(0,255); B2=random(0,255);
  //p2.setFill(R2, G2, B2);
  p2.setDamping(1.5);
  p2.setFriction(0.9);
  world.add(p2);
  
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
  MainMenu.addCharSet("Player Options", 'c', moment, 'o');
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
  
  PlayerOptions = new UISet( 12, 9, 13, 1, 0.8 );
  PlayerOptions.setScheme( #FC9C00,  30);
  //PlayerOptions.beginColumn(0, 1);
  PlayerOptions.addLabel(0, 0, "Player Count:", 'c');
  PlayerOptions.addPlusMinus(1, 0, playerCount, true, 1, 2, 4);
  for( int i = 0; i < playerCount.n; i++ ){
    PlayerOptions.addNumSet( i, 1, "P"+str(i+1), 'c', selectedPlayer, i);
  }
  PlayerOptions.beginRow(1, 2);
  PlayerOptions.addCharSet("Triangle", 'c', assignShape, 't');
  PlayerOptions.addCharSet("Square", 'c', assignShape, 's');
  PlayerOptions.addCharSet("Pentagon", 'c', assignShape, 'p');
  PlayerOptions.addCharSet("Hexagon", 'c', assignShape, 'h');
  PlayerOptions.endRow();
  PlayerOptions.addCharSet(8, 12, "Done", 'c', moment, 'm');
  PlayerOptions.V_percent = 10.8;
  PlayerOptions.addColorSelector(0, 2, assignColor);
  PlayerOptions.V_percent = 0.8;
  PlayerOptions.get("colorSelector").setColor( players.get(0).c );
 // PlayerOptions.add();
}

void init_game(){
   cmds = new ArrayList();
   players = new ArrayList();
   players.add( new Player() );
   players.add( new Player() );
}
