// Button class in it's own tab.
class Button
{
  int x;
  int y;
  int width;
  int height;
  color buttonColor;
  String text;

  // x, y, width, height, color, text
  Button(int xArg, int yArg, int widthArg, int heightArg, color colorArg, String textArg)
  {
    x = xArg;
    y = yArg;
    width = widthArg;
    height = heightArg;
    buttonColor = colorArg;
    text = textArg;
  }

  void draw()
  {
    // Drawing the first button
    fill(buttonColor);
    rect(x, y, width, height);
    fill(0);
    text(text, x+10, y + height/2);
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
