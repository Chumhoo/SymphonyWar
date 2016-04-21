Images IMAGES;
PImage bg;

String figureName[] = {"Violinist", "Tromboner"};
String monsterName[] = {"green", "emb", "shadow"};
    
int figureNum = 2;
int monsterNum = 3;
public PImage[][][] figure = new PImage[figureNum][2][11];       //[class][direction][type]
public PImage[][][] monster = new PImage[monsterNum][2][2];
public PImage[][] bullet = new PImage[3][2];
public PImage[] supply = new PImage[10];

public EffectImg blood, light, knife;

public int N_HEAD = 0, N_BLINK = 1, N_BODY = 2;
public int N_HAND = 3, N_HAND1 = 4, N_HAND2 = 5;
public int N_FOOT = 6, N_FOOT1 = 7, N_FOOT2 = 8;

public int VIOLINIST = 0, TROMBONER = 1;
private class Images
{
  public Images()
  {
    bg = loadImage("DATA/Maps/Map4.jpg");

    for (int i = 0; i < figureNum; i++)
    {
      for (int j = 0; j < 9; j++)
      {
        figure[i][1][j] = loadImage("DATA/Figures/"+ figureName[i] + "/right/" + j + ".png");
        figure[i][0][j] = loadImage("DATA/Figures/"+ figureName[i] + "/left/" + j + ".png");
      }
    }
    for (int i = 0; i < monsterNum; i++)
    {
      for (int j = 0; j < 2; j++)
      {
        monster[i][1][j] = loadImage("DATA/Figures/Monster/"+ monsterName[i] + "/right/" + j + ".png");
        monster[i][0][j] = loadImage("DATA/Figures/Monster/"+ monsterName[i] + "/left/" + j + ".png");
      }
    }

    bullet[0][0] = loadImage("DATA/Objects/tone01.png");
    bullet[1][0] = loadImage("DATA/Objects/tone02.png");
    bullet[2][0] = loadImage("DATA/Objects/tone03.png");
    supply[0] = loadImage("DATA/Objects/aid.png");
    
    blood = new EffectImg(12, "blood", 0, 0);
    light = new EffectImg(10, "light", -140, -130);
    knife = new EffectImg(10, "knife", 50, 0);
  }
}

//*********************************************************************************
//---------------------------------------------------------------------------------


public class EffectImg
{
  int amount;
  PImage img[] = new PImage[50];
  int xCor, yCor;
  
  public EffectImg(int amount1, String tmp, int xC, int yC)
  { 
    xCor = xC;
    yCor = yC;
    amount = amount1;
    for (int i = 0; i < amount; i++)
    {
      img[i] = loadImage("DATA/EFFECTS/" + tmp + "/" + i + ".png");
      if (img[i] == null) break;
    }
  }
}