number playerCount, selectedPlayer;
letter assignShape;
pigment assignColor;

void Options(){
  
  fill(assignColor.p);
  float x = 300, y = 375;
  switch( assignShape.l ){
    case 't': triangle( x, y, tri_l ); break;
    case 's': square( x, y, square_l); break;
    case 'p': pentagon(x, y, penta_l); break;
    case 'h': hexagon( x, y, hex_l); break;
  }
  
  float pplayerCount = playerCount.n;
  float pselectedPlayer = selectedPlayer.n;
  
  Settings.exe();
  
  if(pplayerCount != playerCount.n){
    for( int i = 0; i < pplayerCount; i++ ){
      Settings.remove( "P"+str(i+1) );
    } 
    for( int i = 0; i < playerCount.n; i++ ){
      Settings.addNumSet( i, 1, "P"+str(i+1), 'c', selectedPlayer, i);
    }
    if(pplayerCount < playerCount.n){
      players.add( new Player() );
      selectedPlayer.n = players.size()-1;
    }
    else players.remove(players.size()-1);
  }
  if(pselectedPlayer != selectedPlayer.n){
    Settings.get("colorSelector").setColor( players.get(int(selectedPlayer.n)).c );
    assignShape.l =  players.get(int(selectedPlayer.n)).shape;
  }
  else{
    players.get(int(selectedPlayer.n)).shape = assignShape.l;
    players.get(int(selectedPlayer.n)).c = assignColor.p;
  }
}
