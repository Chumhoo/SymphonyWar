public boolean keyPressing[] = {false, false, false, false};
keyBoardControl keyboard = new keyBoardControl();

public class keyBoardControl
{
  public void press()
  { 
    if (key == CODED)
    {
      switch (keyCode)
      {
      case LEFT: 
        keyPressing[0] = true;
        break;
      case RIGHT: 
        keyPressing[1] = true;
        break;
      case UP: 
        keyPressing[2] = true;
        break;
      case DOWN:
        keyPressing[3] = true;
        break;
      case ESC: 
        exit(); 
        break;
      default: 
        break;
      }
    } else
    {
      if (key == 'p') map.clearMap();
      if (character[HERO].READYTOATTACK) 
      {
        switch(key)
        {
        case 'a':
          character[HERO].ATTACK = 0;
          break;
        case 's':
          character[HERO].ATTACK = 1;
          break;
        default:
          break;
        }
      }
    }
  }

  public void release()
  {
    if (key == CODED)
    {
      switch (keyCode)
      {
      case LEFT: 
        keyPressing[0] = false;
        character[HERO].MOVE = false;
        break;
      case RIGHT: 
        keyPressing[1] = false;
        character[HERO].MOVE = false;
        break;
      case UP: 
        keyPressing[2] = false;
        break;
      case DOWN: 
        keyPressing[3] = false;
        break;
      default: 
        break;
      }
    }
  }

  public void control()
  {
    if (keyPressing[0])  character[HERO].move(LEFT);
    else if (keyPressing[1]) character[HERO].move(RIGHT);
    
    if (keyPressing[2]) character[HERO].move(UP);
   
   if (keyPressing[3]) 
    {
      character[HERO].SQUAT = true;
    }
    else character[HERO].SQUAT = false;
  }
}