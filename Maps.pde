public Maps map;

public class Maps
{
  boolean[][] barrier = new boolean[width][height];
  boolean[][] figureBarrier = new boolean[width][height];

  public Maps()
  {
    clearMap();
    loadMap();
  }

  public void clearMap()
  {
    for (int i = 0; i < width; i++)
      for (int j = 0; j < height; j++)
        barrier[i][j] = false;
  }

  public void loadMap()
  {
    PImage temp = bg;
    temp.loadPixels();
    for (int i = 0; i < width * height; i++)
    {
      if (temp.pixels[i] == #000000) 
      {
        barrier[i % width][i / width] = true;
      }
    }
  }

  public void refreshFigureBarrier()
  {
    figureBarrier = null;
    figureBarrier = new boolean[width][height];
    for (int i = character[HERO].x + character[HERO].OBWIDTH * 3 / 8; i <= character[HERO].x + character[HERO].OBWIDTH * 5/8 && i < width; i++)
      for (int j = character[HERO].y; j <= character[HERO].y + character[HERO].OBHEIGHT && j < height; j++)
      {
        if (i >= 0 && j >= 0) figureBarrier[i][j] = true;
      }
    for (int k = 0; character[k] != null && k < num_of_enemy; k++)
    {
      if (character[k].ALIVE == false) continue;
      for (int i = character[k].x + character[k].OBWIDTH * 3 / 8; i <= character[k].x + character[k].OBWIDTH * 5/8 && i < width; i++)
        for (int j = character[k].y; j <= character[k].y + character[k].OBHEIGHT && j < height; j++)
        {
          if (i >= 0 && j >= 0) figureBarrier[i][j] = true;
        }
    }
  }

  public void show()
  {
    image(bg, 0, 0);
    refreshFigureBarrier();
  }

  public boolean boarder(int x, int y)   //dir: 0 is left, 1 is right, 2 is up, 3 is down
  {
    if (x <= 0 || x >= width || y <= 0 || y >= height) return true;
    else return false;
  }

  //0:left 1:right 2:up 3:down
  public int barrier(int x, int y, int OBWIDTH, int OBHEIGHT, int dir, int value)   
  {
    if (dir == 0)
    {
      if (boarder(x - 1 - value, y)) return 1;
      for (int j = y; j < y + OBHEIGHT && j < height; j++)
      {
        for (int i = x - 1; i >= x - 1 - value && i < width; i--)
          if (barrier[i][j] /* || figureBarrier[i][j] */)
          { 
              return 1;
          }
      }
    } else if (dir == 1)
    {
      if (boarder(x+OBWIDTH + 1 + value, y)) return 0;
      for (int j = y; j <= y + OBHEIGHT && j < height; j++)
      {
        for (int i = x + 1 + OBWIDTH; i <= x + 1 + OBWIDTH + value && i < width; i++)
          if (barrier[i][j] /* || figureBarrier[i][j] */)
          { 
              return 1;
          }
      }
    } else if (dir == 2)
    {
      if (boarder(x, y - 2)) return 1;
      for (int i = x; i <= x + OBWIDTH && i < width; i++)
      {
        for (int j = y; j >= y - 1 && j < height; j--)
          if (barrier[i][j])
          { 
            return 1;
          }
      }
    } else {
      if (boarder(x, y + OBHEIGHT + 2)) return 1;
      for (int i = x; i <= x + OBWIDTH && i < width; i++)
      {
        for (int j = y + 1 + OBHEIGHT; j <= y + 1 + OBHEIGHT + 1 && j < height; j++)
          if (barrier[i][j])
          { 
            return 1;
          }
      }
    }
    return 0;
  }
}