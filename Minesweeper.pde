import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
   
    // make the manager
    Interactive.make( this );
   
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int r=0; r<NUM_ROWS; r++){
      for (int c=0; c<NUM_COLS; c++){
        buttons[r][c] = new MSButton(r, c);
      }
    }
   
   for (int i=0; i<70; i++){
    setMines();
   }

}
public void setMines()
{
     int row = (int)(Math.random()*NUM_ROWS);
     int col = (int)(Math.random()*NUM_COLS);
     if (!mines.contains(buttons[row][col])){
       mines.add(buttons[row][col]);
     }

}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    for (int r=0; r<NUM_ROWS; r++){
      for (int c=0; c<NUM_COLS; c++){
        if (!mines.contains(buttons[r][c]) && !buttons[r][c].clicked) 
          return false;
      }
    }
    return true;
}
public void displayLosingMessage()
{
    buttons[10][6].setLabel("Y");
    buttons[10][7].setLabel("O");
    buttons[10][8].setLabel("U");
    buttons[10][9].setLabel(" ");
    buttons[10][10].setLabel("L");
    buttons[10][11].setLabel("O");
    buttons[10][12].setLabel("S");
    buttons[10][13].setLabel("E");
    for (int i=0; i<mines.size(); i++){
      if (mines.get(i).flagged)
        mines.get(i).flagged = false;
      mines.get(i).clicked = true;
    }
}
public void displayWinningMessage()
{
    buttons[10][6].setLabel("Y");
    buttons[10][7].setLabel("O");
    buttons[10][8].setLabel("U");
    buttons[10][9].setLabel(" ");
    buttons[10][10].setLabel("W");
    buttons[10][11].setLabel("I");
    buttons[10][12].setLabel("N");
}
public boolean isValid(int r, int c)
{  
    return r>=0 && r<NUM_ROWS && c>=0 && c<NUM_COLS;
}
public int countMines(int row, int col)
{
    int numMines = 0;
   for (int r=row-1; r<=row+1; r++){
     for (int c=col-1; c<=col+1; c++){
       if (isValid(r, c)){
         if (mines.contains(buttons[r][c]) && !(r==row && c==col))
          numMines++;
       }
     }
   }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
   
    public MSButton ( int row, int col )
    {
         width = 400/NUM_COLS;
         height = 400/NUM_ROWS;
        myRow = row;
        myCol = col;
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed ()
    {
        clicked = true;
        if (mouseButton == RIGHT){
          flagged = !flagged;
          if (!flagged)
            clicked = false;
        }
        else if (mines.contains(this)){
          displayLosingMessage();
        }
        else if (countMines(myRow, myCol)>0){
          setLabel(countMines(myRow, myCol));
        }
        else {
          for (int r=myRow-1; r<=myRow+1; r++){
            for (int c=myCol-1; c<=myCol+1; c++){
              if (isValid(r, c) && !buttons[r][c].clicked)
                buttons[r][c].mousePressed();
              }
          }
        }
         
    }
    public void draw ()
    {    
        if (flagged)
            fill(0);
         else if( clicked && mines.contains(this) )
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
