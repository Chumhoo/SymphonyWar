public Director director; 

PFont F;
void setup() 
{
  size(1280, 800); 
  cursor(HAND);
  F = createFont("Georgia", 24, true);
  director = new Director();
} 

void draw() {
  director.play();
}  

void keyPressed()
{
  keyboard.press();
  if (keyCode == ALT) director.RESTART = true;
}

void keyReleased()
{
  keyboard.release();
}

void mousePressed()
{
   hurtManager.newSupply(mouseX, mouseY, 0, 100);
}
void mouseDragged()
{
   hurtManager.newSupply(mouseX, mouseY, 0, 100);
}