Effect effects[] = new Effect[1000];
int MAX_NUM_OF_EFFECTS = 1000;

public class Animation
{
  public void newEffect(EffectImg effectImg, int x1, int y1, boolean CYCLE, boolean follow, int soldierNum)
  {
    int i = 0;
    while (effects[i] != null) i++;
    effects[i] = new Effect(effectImg, i, x1, y1, CYCLE, follow, soldierNum);
  }

  public void Loop()
  {
    for (int i = 0; i < MAX_NUM_OF_EFFECTS; i++)
    {
      if (effects[i] == null) continue;
      effects[i].show();
    }
  }
}

public class Effect
{
  private int x, y;
  private float count;
  private int num;
  private boolean CYCLE;
  PImage frame[] = new PImage[50];
  private int amount;
  private boolean FOLLOW;
  int soldierNum;
  EffectImg images;

  public Effect(EffectImg effectImg, int num1, int x1, int y1, boolean cycle, boolean follow, int Soldiernum)
  {
    images = effectImg;
    num = num1;
    x = x1;
    y = y1;
    count = 0;
    CYCLE = cycle;
    soldierNum = Soldiernum;
    FOLLOW = follow;
  }

  public void show()
  {
    if (FOLLOW)
    {
      x = character[soldierNum].x;
      y = character[soldierNum].y;
    }
    if (count < images.amount) 
    {
      image(images.img[(int)count], x + images.xCor, y + images.yCor);
      count += 0.3;
    } else
    {
      if (CYCLE) count = 0; 
      else effects[num] = null;
    }
  }
}