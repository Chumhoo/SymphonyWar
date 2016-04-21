HurtManager hurtManager;
public class HurtManager
{
  int num_of_hurt = 0;         //num_of_hurt[1] is static hurt, [2] is moving hurt
  int MAX_NUM_OF_HURT = 100, MAX_NUM_OF_SUPPLY = 100;
  int speedOfBullet = 7;
  int bulletPosiCorrect[] = {-20};
  Hurt hurt[] = new Hurt[MAX_NUM_OF_HURT];
  Supply supplies[] = new Supply[MAX_NUM_OF_SUPPLY];

  int closeHurtWidth = 10;
  int closeHurtHeight = 40;

  public class Hurt
  {
    int team;
    boolean SWITCH;
    int DIRECTION;
    int x, y, type, count = 5, harm;
    int number;
    public Hurt(int num, int TEAM, int X, int Y, int TYPE, int direction)
    {
      number = num;
      team = TEAM;
      SWITCH = true;
      x = X;
      y = Y + bulletPosiCorrect[0];
      type = TYPE;
      if (type == 0) harm = -50;
      else harm = -20;
      DIRECTION = direction;
    }
  }

  public class Supply
  {
    int x, y, type, value;
    boolean SWITCH;
    public Supply(int X, int Y, int Type, int Value)
    {
      x = X;
      y = Y;
      SWITCH = true;
      type = Type;
      value = Value;
    }
  }

  public void newHurt(int Num, int team, int x, int y, int type, int OBWIDTH, int DIRECTION)
  {
    int i;
    for (i = 0; i < MAX_NUM_OF_HURT; i++) if (hurt[i]==null || (hurt[i]!=null && !hurt[i].SWITCH)) break;
    if (i < MAX_NUM_OF_HURT) hurt[i] = new Hurt(Num, team, x + OBWIDTH * DIRECTION, y, type, DIRECTION);
  }

  public void newSupply(int x, int y, int type, int value)
  {
    int i;
    for (i = 0; i < MAX_NUM_OF_HURT; i++) if (supplies[i]==null || (supplies[i]!=null && !supplies[i].SWITCH)) break;
    if (i < MAX_NUM_OF_HURT) supplies[i] = new Supply(x, y, type, value);
  }

  public void hurtLoop()
  {
    for (int i = 0; i < MAX_NUM_OF_HURT; i++)
    {
      if ((hurt[i] != null) && hurt[i].SWITCH)
      {
        if (hurt[i].type == 0)                // Close range attack
        {
          if (--hurt[i].count <= 0) 
          {
            hurt[i].SWITCH = false;
            character[hurt[i].number].harmlessAttack++;
            character[hurt[i].number].recentHarmless++;
          }
        } else if (hurt[i].type == 1)         // Wide range attack
        {
          image(bullet[0][0], hurt[i].x, hurt[i].y);
          //the move of the bullet________________
          if (hurt[i].DIRECTION == 0) hurt[i].x-=speedOfBullet;   
          else if (hurt[i].DIRECTION == 1) hurt[i].x+=speedOfBullet;
          else if (0 == map.barrier(hurt[i].x, hurt[i].y, 20, 20, 3, 1)) hurt[i].y++;
          if (hurt[i].x > width || hurt[i].x < 0 || 1 == map.barrier(hurt[i].x, hurt[i].y, 15, 15, hurt[i].DIRECTION, 1))
          {
            hurt[i].SWITCH = false;
            if (hurt[i].number >= 0)
            {
              character[hurt[i].number].harmlessAttack++;
              character[hurt[i].number].recentHarmless++;
            }
          }
          //-----------------------------------------
        }
      }
    }      //end of the iteration of the hurts  [for (int i = 0; i < MAX_NUM_OF_HURT; i++)]

    for (int k = 0; k < MAX_NUM_OF_HURT; k++)
    {
      if (hurt[k] != null && hurt[k].SWITCH)
      {
        hurtTypes(hurt[k]);
      }
    }  // end of the iteration [for (int k = 0; k < MAX_NUM_OF_HURT; k++)]
  }    //end of hurtLoop

  public void hurtTypes(Hurt hurt)
  {
    fill(255, 0, 0);
    //ellipse(hurt.x, hurt.y, 10, 10);
    for (int i = 0; i <= num_of_enemy; i++)
    {
      if (hurt.team == character[i].team || character[i].DEAD) continue;

      if (hurt.type == 0)
      {
        //fill(0, 100);
        //rect(character[i].x - closeHurtWidth, character[i].y - closeHurtHeight, character[i].OBWIDTH + 2 * closeHurtWidth, character[i].OBHEIGHT + 2 * closeHurtHeight);
        if (hurt.x >= character[i].x - closeHurtWidth && hurt.x <= character[i].x + character[i].OBWIDTH + closeHurtWidth
          && hurt.y >= character[i].y - closeHurtHeight && hurt.y <= character[i].y + character[i].OBHEIGHT + closeHurtHeight)      //hit!
        {
          character[i].blood += hurt.harm;   
          character[i].HIT = hurt.harm;                  // the animation of being hit
          hurt.SWITCH = false;

          if (hurt.number >= 0)
          {
            character[hurt.number].harmfulAttack++;
            character[hurt.number].recentHarmless = 0;
          }

          if (character[i].blood <= 0) 
          {
            character[i].DEAD = true;
            character[hurt.number].kill++;
          }
          //break;    //delete the break, then the close range attack turns to multiharm(hurt several people in one time)
        }
      }
      if (hurt.type == 1)
      {
        if (hurt.x >= character[i].x && hurt.x <= character[i].x + character[i].OBWIDTH
          && hurt.y >= character[i].y && hurt.y <= character[i].y + character[i].OBHEIGHT)      //hit!
        {
          character[i].blood += hurt.harm;  
          text(hurt.harm , character[i].x, character[i].y);
          
          character[i].HIT = hurt.harm;                  // the animation of being hit
          anime.newEffect(blood, character[i].x, character[i].y, false, true, i);
          hurt.SWITCH = false;

          if (hurt.number >= 0)
          {
            character[hurt.number].harmfulAttack++;
            character[hurt.number].recentHarmless = 0;
          }

          if (character[i].blood <= 0) 
          {
            character[i].DEAD = true;
            character[hurt.number].kill++;
          }
          break;
        }
      }
    }  
    // end of the second iteration [for (int i = 0; i <= num_of_enemy; i++)]
  }

  public void supplyLoop()
  {
    for (int i = 0; i < MAX_NUM_OF_SUPPLY; i++)
    {
      if ((supplies[i] != null) && supplies[i].SWITCH)
      {
        image(supply[supplies[i].type], supplies[i].x, supplies[i].y);

        //the move of the bullet________________
        if (0 == map.barrier(supplies[i].x, supplies[i].y, 20, 20, 3, 1)) supplies[i].y++;
        if (supplies[i].y > width)
        {
          supplies[i].SWITCH = false;
        }
        //-----------------------------------------
      }
    }      //end of the iteration of the supplies  [for (int i = 0; i < MAX_NUM_OF_HURT; i++)]

    for (int k = 0; k < MAX_NUM_OF_SUPPLY; k++)
    {
      if (supplies[k] != null && supplies[k].SWITCH)
      {
        for (int i = 0; i <= num_of_enemy; i++)
        {
          if (i != HERO || character[i].DEAD) continue;
          if (supplies[k].x >= character[i].x && supplies[k].x <= character[i].x + character[i].OBWIDTH
            && supplies[k].y >= character[i].y && supplies[k].y <= character[i].y + character[i].OBHEIGHT)      //get!
          {
            character[i].blood += supplies[k].value;         
            character[i].HIT = supplies[k].value;                  // the animation
            anime.newEffect(light, character[i].x, character[i].y, false, true, 0);
              
            supplies[k].SWITCH = false;

            if (character[i].blood >= character[i].bloodAmount) 
            {
              character[i].blood = character[i].bloodAmount;
            }
            break;
          }
        }  // end of the second iteration
      }
    }  // end of the iteration [for (int k = 0; k < MAX_NUM_OF_HURT; k++)]
  }    //end of suppliesLoop
}