public int HERO = 0;
color teamColor[] = {color(0), color(0, 255, 0), color(255, 0, 0), color(0, 0, 255), color(255, 255, 100), color(0, 255, 255)}; 

Soldier character[] = new Soldier[1000];

public class Soldier
{
  private int number;
  private int x = 1, y = 1;           //initial position
  PImage[][] Status;
  PImage head, hand, body, foot; 

  public boolean AI = false;
  public boolean SOLDIER = true;

  private int DIRECTION = 0;         //left is 0, right is 1
  public boolean JUMP = false, READYTOJUMP = false;
  private int JUMPSPEED = 20, jumpSpeed = JUMPSPEED;
  public boolean SQUAT;

  public int ATTACK = -1;
  public boolean READYTOATTACK = true;
  public boolean MOVE = false;

  private float gravity = 0.8;
  private int gravityTime = 0;
  private int SPEED = 3;
  private int attackSpeed = 10;
  public int OBHEIGHT, OBWIDTH;
  private int WIDTHCORRECT = 15;

  private SoldierMotion SMotion;
  private MonsterMotion MMotion;

  private Intelligence brain;

  public int bloodAmount = 100, blood = bloodAmount;
  public boolean ALIVE;
  public int team;

  private int kill = 0;
  private int attackTimes = 0;
  private int harmfulAttack = 0, harmlessAttack = 0, recentHarmless = 0;

  private int HIT = 0, hitCount = 50, hitRec;
  private int deadCount = 255;
  private boolean DEAD = false;

  private String name;

  public Soldier(int num, boolean ifAI, String Name, PImage[][] temp, int posiX, int posiY, int speed, boolean ifSoldier, int TEAM)
  {
    AI = ifAI;
    SOLDIER = ifSoldier;
    name = Name;
    number = num;
    Status = temp;
    SPEED = speed;
    team = TEAM;
    x = posiX;
    y = posiY;
    OBHEIGHT = Status[0][0].width;
    OBWIDTH = Status[0][0].height;
    ALIVE = true;

    if (SOLDIER) SMotion = new SoldierMotion();
    else MMotion = new MonsterMotion();
    brain = new Intelligence();
  }

  public void show()
  {
    death();

    if (HIT != 0) 
    {
      hitCount = 20;
      hitRec = HIT;
      HIT = 0;
    }
    if (hitCount >= 0)
    {
      textFont(F, 20);
      hitCount--;
      if (hitRec < 0)
      {
        fill(255, 0, 0);
        text(hitRec, x + OBWIDTH, y - 20 + hitCount);
      } else
      {
        fill(0, 255, 0);
        text(hitRec, x + OBWIDTH, y - 20 + hitCount);
      }
    }

    if (SOLDIER) SMotion.alive();
    else MMotion.alive();

    gravity();
    if (JUMP) figureJump();
    if (AI) brain.findEnemy();

    textFont(F, 15);
    fill(teamColor[team]);
    text("kill:"+ kill, x, y - 40);
    text("attack:"+ attackTimes, x, y - 85);
    text("harmful:"+ harmfulAttack, x, y - 70);
    text("harmless:"+ harmlessAttack, x, y - 55);
    text("|", x + 20, y - 25);

    fill(0);
    textFont(F, 10);
    text(name, x, y-11);
    tint(255, 255);
  }

  public void death()
  {    
    tint(255, deadCount);
    if (DEAD)
    {
      if (deadCount <= 0) ALIVE = false;
      else deadCount -= 20;
    }
  }

  private class MonsterMotion
  {   
    int count = 0;
    public MonsterMotion()
    {
      body = Status[DIRECTION][0];
    }

    public void alive()
    {
      if (MOVE)
      {
        if (count % 20 > 10) body = Status[DIRECTION][0];
        else body = Status[DIRECTION][1];
      } else body = Status[DIRECTION][0];

      count = (count + 1) % 400;
      image(body, x, y);
      if (!AI) walk();
      bloodSlot();
    }

    private void walk()
    {
      if (count > 300) move(RIGHT);
      else if (count > 200) MOVE = false;
      else if (count > 100) move(LEFT);
      else MOVE = false;
    }

    public void move(int KEY)
    {
      MOVE = true;
      switch (KEY)
      {
      case UP: 
        if (READYTOJUMP) JUMP = true; 
        break;
      case LEFT: 
        DIRECTION = 0;
        if (0 == barrier(0, SPEED))  x -= SPEED;
        else for (int i = 1; i < SPEED && 0 == barrier( 0, 1); i++) x--;
        break;
      case RIGHT: 
        DIRECTION = 1;
        if (0 == barrier(1, SPEED))  x += SPEED;
        else for (int i = 1; i < SPEED && 0 == barrier(1, 1); i++) x++;
        break;
      default: 
        break;
      }
    }

    public void bloodSlot()
    {
      colorMode(RGB);
      stroke(0);
      noFill();
      rect(x, y-10, 51, 6);
      noStroke();
      fill(teamColor[team]);
      if (blood >= 0) rect(x+1, y-9, 50*blood/bloodAmount, 5);
    }
  }

  private class SoldierMotion
  {
    private int count = 0, walkCount = 0, attackCount = 0;
    private int BREATH = 0;

    public SoldierMotion()
    {
      head = Status[DIRECTION][N_HEAD];
      foot = Status[DIRECTION][N_FOOT];
      hand = Status[DIRECTION][N_HAND1];
    }

    public void alive()
    {
      body = Status[DIRECTION][N_BODY];
      if (MOVE)
      {
        if (DIRECTION == 1) hand = Status[0][N_HAND1];
        else  hand = Status[1][N_HAND1];
      }
      if (attackCount > 0 && attackCount < attackSpeed)
      {
        hand = Status[DIRECTION][N_HAND2];
      } else
      {
        hand = Status[DIRECTION][N_HAND1];
      }

      image(foot, x, y+2);
      image(body, x, y+BREATH);
      image(head, x, y+BREATH);
      image(hand, x, y+BREATH);
      if (count++ >= 100) count = 0;
      blinkEye();
      breath();
      attack();
      bloodSlot();

      if (MOVE) walk(true);
      else walk(false);
    }

    public void bloodSlot()
    {
      colorMode(RGB);
      stroke(0);
      noFill();
      rect(x, y-10, 51, 6);
      noStroke();
      fill(teamColor[team]);
      if (blood >= 0) rect(x+1, y-9, 50*blood/bloodAmount, 5);
    }

    public void blinkEye()
    {
      if (count % 60 >= 50) head = Status[DIRECTION][N_BLINK];
      else head = Status[DIRECTION][N_HEAD];
    }

    public void breath()
    {
      if (count % 50 >= 25) BREATH = -1;
      else BREATH = 0;
    }

    public void walk(boolean func)
    {
      if (func)
      {
        walkCount = (walkCount + 1) % 400;
        if (walkCount % 14 >= 7) foot = Status[DIRECTION][N_FOOT1];
        else foot = Status[DIRECTION][N_FOOT2];
      } else 
      {
        foot = Status[DIRECTION][N_FOOT];
      }
    }
    public void attack()
    {
      int squatValue;
      if (SQUAT) 
      {
        squatValue = 60;
      } else squatValue = 30;

      if (ATTACK != -1)
      {
        if (READYTOATTACK) 
        {
          attackTimes++;
          
          if (ATTACK == 0) anime.newEffect(knife, x, y, false, true, number);
          
          if (DIRECTION == 0) hurtManager.newHurt(number, team, x, y + squatValue, ATTACK, OBWIDTH, DIRECTION);
          else hurtManager.newHurt(number, team, x, y + squatValue, ATTACK, OBWIDTH, DIRECTION);
          READYTOATTACK = false;
        }
        attackCount++;
        if (attackCount > attackSpeed) 
        {
          attackCount = 0;
          READYTOATTACK = true;
          ATTACK = -1;
        }
      }
    }
  }

  public void move(int KEY)
  {
    switch (KEY)
    {
    case UP: 
      if (READYTOJUMP) JUMP = true; 
      break;
    case LEFT: 
      MOVE = true;
      DIRECTION = 0;
      if (0 == barrier(0, SPEED))  x -= SPEED;
      else for (int i = 1; i < SPEED && 0 == barrier(0, 1); i++) x--;
      break;
    case RIGHT: 
      MOVE = true;
      DIRECTION = 1;
      if (0 == barrier(1, SPEED)) x += SPEED;
      else for (int i = 1; i < SPEED && 0 == barrier(1, 1); i++) x++;
      break;
    default: 
      break;
    }
  }

  public void gravity()
  {
    gravityTime++; 
    for (int i = 1; i <= gravity * gravityTime; i++)
      if (0 == map.barrier(x + WIDTHCORRECT, y, OBWIDTH - 2 * WIDTHCORRECT, OBHEIGHT, 3, 0))
      {
        y++;
      } else
      {
        READYTOJUMP = true;
        gravityTime = 1;
      }
  }

  private void figureJump()
  {
    if (JUMP && READYTOJUMP)
    {
      READYTOJUMP = false;
    }
    if (!READYTOJUMP && JUMP)
    {
      if (0 == map.barrier(x + WIDTHCORRECT, y, OBWIDTH - 2 * WIDTHCORRECT, OBHEIGHT, 2, 0))
      {
        for (int i = 1; i <= jumpSpeed; i++)
        {
          if (1 == map.barrier(x + WIDTHCORRECT, y, OBWIDTH - 2 * WIDTHCORRECT, OBHEIGHT, 2, 0))
          {
            JUMP = false;
            jumpSpeed = JUMPSPEED;
            break;
          }
          y--;
        }
        jumpSpeed--;
      }
      if (jumpSpeed <= 0)
      {
        JUMP = false;
        jumpSpeed = JUMPSPEED;
      }
    }
  }

  private class Intelligence
  {
    int Count = 0;
    int attackInterval = 1, attackIntervalCount = attackInterval;
    int jumpInterval = 100, jumpIntervalCount = jumpInterval;
    int freeMoveInterval = 200;
    int detectDistance = 500;
    int clever = 2;             /*0 is off, on is 1 ~ 10*/
    int closestEnemy = 0;

    public void findEnemy()
    {
      boolean DISCOVER = false;
      for (int i = 0; i <= num_of_enemy; i++)
      {
        if (!character[i].ALIVE || team == character[i].team) continue;   //dead or find the same team, jump over
        if (character[i].x >= x - detectDistance && character[i].x <= x + detectDistance)   //discover enemy!
        {
          DISCOVER = true;
          if (Math.abs(character[i].x - x) <= Math.abs(character[i].x - character[closestEnemy].x)) closestEnemy = i;
        }
      }
      if (character[closestEnemy].ALIVE == false) DISCOVER = false;
      if (DISCOVER)
      {
        //textFont(F, 15);
        //text("find: " + closestEnemy, x, y-13);
        //fill(teamColor[character[closestEnemy].team]);
        //rect(x + 35, y - 25, 15, 15);
        if (character[closestEnemy].x < x) DIRECTION = 0;
        else DIRECTION = 1;
        if (y > character[closestEnemy].y) 
        {
          jumpIntervalCount--;
          if (jumpIntervalCount <= 0)
          {
            if (READYTOJUMP) JUMP = true;
            jumpIntervalCount = jumpInterval;
          }
        }
        if (x < character[closestEnemy].x - 50) move(RIGHT);
        else if (x > character[closestEnemy].x + 50) move(LEFT);
        else MOVE = false;

        attackIntervalCount--;
        if (READYTOATTACK && attackIntervalCount <= 0)
        {
          ATTACK = 1; 
          attackIntervalCount = attackInterval;
        }
      } else                    //free move
      {
        Count++;
        if (Count < freeMoveInterval) move(RIGHT);
        else if (Count < freeMoveInterval * 2) move(LEFT);
        else Count = 0;
      }
      if (clever > 0) clever();
    }

    public void clever()
    {
      if (recentHarmless >= (10 - clever)) 
      {
        recentHarmless = 0;

        if (READYTOJUMP) JUMP = true;
        if (character[closestEnemy].x > x)
          for (int i = 0; i < 20; i++)move(RIGHT); 
        else
          for (int i = 0; i < 20; i++) move(RIGHT);
      } else return;
    }
  }

  public int barrier(int dir, int value)   
  {
    if (dir == 0)
    {
      if (map.boarder(x - 1 - value, y)) return 1;
      for (int j = y; j < y + OBHEIGHT && j < height; j++)
      {
        for (int i = x - 1; i >= x - value && i < width; i--)
          if (map.barrier[i - 1][j - 1] /* || figureBarrier[i][j] */)
          { 
            if ((y + OBHEIGHT) - j < 20)     //tolerance of feet (the height of feet is 10)
            {
              y += j - (y + OBHEIGHT);
              return 0;
            } else
            {
              return 1;
            }
          }
      }
    } else if (dir == 1)
    {
      if (map.boarder(x+OBWIDTH + 1 + value, y)) return 0;
      for (int j = y; j <= y + OBHEIGHT && j < height; j++)
      {
        for (int i = x + 1 + OBWIDTH; i <= x + 1 + OBWIDTH + value && i < width; i++)
          if (map.barrier[i - 1][j - 1] /* || figureBarrier[i][j] */)
          {
            if ((y + OBHEIGHT) - j < 20)
            {
              y += j - (y + OBHEIGHT);
              return 0;
            } else 
            {
              return 1;
            }
          }
      }
    } else if (dir == 2)
    {
      if (map.boarder(x, y - 2)) return 1;
      for (int i = x; i <= x + OBWIDTH && i < width; i++)
      {
        for (int j = y; j >= y - 1 && j < height; j--)
          if (map.barrier[i][j])
          { 
            return 1;
          }
      }
    } else {
      if (map.boarder(x, y + OBHEIGHT + 2)) return 1;
      for (int i = x; i <= x + OBWIDTH && i < width; i++)
      {
        for (int j = y + 1 + OBHEIGHT; j <= y + 1 + OBHEIGHT + 1 && j < height; j++)
          if (map.barrier[i][j])
          { 
            return 1;
          }
      }
    }
    return 0;
  }
}