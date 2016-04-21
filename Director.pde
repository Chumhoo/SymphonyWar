BufferedReader reader = null;
String line;
int num_of_enemy;
boolean RUNNING = false;
Animation anime;

public class Director
{
  private boolean RESTART = false;
  private int refreshCount;
  private boolean WIN = false;
  public Director()
  {
    IMAGES = new Images();
    map = new Maps();
    hurtManager = new HurtManager();
    anime = new Animation();
  }

  public void play()
  {
    if (!RUNNING) 
    {
      director.performScript();
      RUNNING = true;

      num_of_enemy = 20;
      for (int i = 1; i <= 5; i++)
        character[i] = new Soldier(i, true, monsterName[i%3], monster[i%3], 1000 + int(random(200)), 1, 1, false, 2);
      for (int i = 6; i <= num_of_enemy; i++)
        character[i] = new Soldier(i, true, figureName[i%2], figure[i%2], 800 + int(random(300)), 1, 1, true, 2);
    }

    tint(255, 150);   //make the shadow
    map.show();
    tint(255, 255);

    for (int i = 0; i <= num_of_enemy; i++) 
    {
      if (character[i].ALIVE) character[i].show();
    }
   
    hurtManager.hurtLoop();
    hurtManager.supplyLoop();

    keyboard.control();
    
    anime.Loop();

    loseOrWin();
    
    //for (int i = 0; i <= num_of_enemy; i++)
    //{
    //println("character[" + i + "] team:" + character[i].team + " " + character[i].ALIVE + "  Hero blood: " + character[0].blood);
    //if ((character[0].harmfulAttack + character[0].harmlessAttack)!= 0) println("  Accurate: " + 100.0 * character[0].harmfulAttack / (character[0].harmfulAttack + character[0].harmlessAttack));
    //}

    //stroke(0);            //TESTER : show the figure barrier
    //for (int i = 0; i < width; i++)
    // for (int j = 0; j < height; j++)
    //   if (map.figureBarrier[i][j] == true) point(i, j);

    //stroke(255, 0, 0);            //TESTER : show the MAP barrier
    //for (int i = 0; i < width; i++)
    //  for (int j = 0; j < height; j++)
    //    if (map.barrier[i][j] == true) point(i, j);

  }


  public void loseOrWin()
  {
    if (!RESTART) 
    {
      if (character[HERO].blood <= 0) 
      {
        fill(255, 0, 0);
        WIN = false;
        RESTART = true;
        refreshCount = 25;
        return;
      }
      for (int i = 0; i <= num_of_enemy; i++)
      {
        if ((character[i].team != character[HERO].team) && character[i].ALIVE) return;
      }
      fill(0, 255, 0);
      WIN = true;
      RESTART = true;
      refreshCount = 25;
    }
    if (RESTART)
    {
      refreshCount--;
      if (refreshCount >= 0) tint(refreshCount * 10, 255);
      else tint(-refreshCount * 10, 255);
      if (refreshCount < -25) 
      {
        RUNNING = false;
        RESTART = false;
      }
      map.show();
      textFont(F, 150);
      if (WIN) 
      {
        fill(0, 255, 0);
        text("You Win!", 50, 210);
      } else 
      {
        fill(255, 0, 0);
        text("You Lose!", 50, 210);
      }
    }
  }

  public String read()
  {
    String temp;
    try {
      temp = reader.readLine();
      println(temp);
    } 
    catch (IOException e) {
      e.printStackTrace();
      temp = null;
    }
    return temp;
  }

  public void performScript()
  {
    String[] words;

    reader = createReader("Scripts/script.txt");
    while (true)
    {
      line = read();
      if (line == null) {
        reader = createReader("Scripts/script.txt");
        println("return to the beginning of the script...");
      }

      if (line.equals("HERO"))
      {
        while (true)
        {
          line = read();
          if (line.equals("END")) break;
          words = split(line, " ");

          if (words[0].equals("SPEED")) character[HERO].SPEED = int(words[1]);
          else if (words[0].equals("BLOOD"))
          {
            character[HERO].blood = int(words[1]);
            character[HERO].bloodAmount = int(words[1]);
          } else if (words[0].equals("POSI"))
          {
            character[HERO] = new Soldier(HERO, false, "Tromboner", figure[TROMBONER], int(words[1]), int(words[2]), 3, true, 1);
          }
        }
      } 
      else if (line.equals("ENEMY"))
      {
        while (true)
        {
          line = read();
          if (line.equals("END")) break;
          words = split(line, " ");
          if (words[0].equals("NUM"))
          {
            num_of_enemy = int(words[1]);
            for (int i = 1; i <= num_of_enemy; i++)
            {
              line = read();
              words = split(line, " ");
              if (words[0].equals("POSI"))
              {
                if (words[1].equals("RANDOM")) character[i] = new Soldier(i, true, "Violinist", figure[VIOLINIST], int(random(500)), 100, 2, true, 2);
                else character[i] = new Soldier(i, true, "Violinist", figure[VIOLINIST], int(words[1]), int(words[2]), 2, true, 2);
              }
            }
          }
        }
      } 
      else if (line.equals("BEGIN")) 
      {
        return;
      }
    }
  }
}