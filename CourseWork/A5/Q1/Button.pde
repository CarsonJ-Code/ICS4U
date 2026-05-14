
  class Button
{
  int x; // The x location of the button
  int y; // The y location of the button

  // The size of the button
  int width;
  int height;

  // The color of the button
  color colour;

  String text;

  // The constructor setting all properties
  Button(int xArg, int yArg, int widthArg, int heightArg, color colourArg, String textArg)
  {
    x=xArg;
    y=yArg;
    width = widthArg;
    height = heightArg;
    colour = colourArg;
    text = textArg;
  }

  // The constructor setting only the (x,y) and the text.
  // Default size is 100x50 and default color is Green.
  Button(int xArg, int yArg, String textArg)
  {
    x=xArg;
    y=yArg;
    text = textArg;
    width = 100;
    height = 50;
  }
  color getColour(){
   return(colour); 
  }

  void draw()
  {
    // Draw the button
    fill(colour);
    rect(x, y, width, height);
    fill(0);
    textSize(15);
    text(text, x+5, y+20);
  }
  
  boolean isClicked(int xArg, int yArg)
  {
    if (xArg>=x && xArg <= (x + width) && yArg >= y && yArg <= (y + height))
    {
      return true;
    } else
    {
      return false;
    }
  }
}
 
