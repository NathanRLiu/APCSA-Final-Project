final static float MOVE_SPEED = 4;
final static float SPRITE_SCALE = 50.0 / 128;
final static float SPRITE_SIZE = 50;
final static float GRAVITY = 0.6;
final static float JUMP_SPEED = 16;

final static float RIGHT_MARGIN = 400;
final static float LEFT_MARGIN = 200;
final static float VERTICAL_MARGIN = 40;

final static float WIDTH = SPRITE_SIZE * 60;
final static float HEIGHT = SPRITE_SIZE * 22;
final static float GROUND_LEVEL = HEIGHT - SPRITE_SIZE;

final static int NEUTRAL_FACING = 0; 
final static int RIGHT_FACING = 1; 
final static int LEFT_FACING = 2; 

Player player;
PImage snow, crate, red_brick, brown_brick, gold, spider, playerImage;
ArrayList<Sprite> platforms;
ArrayList<Sprite> coins;
ArrayList<Enemy> enemies;

boolean isGameOver;
int numCoins;

float view_x, view_y;

void setup()
{
  size(800, 600);
  imageMode(CENTER);
  
  playerImage = loadImage("player_stand_right.png");
  player = new Player(playerImage, 0.8);
  player.center_x = 20;
  player.center_y = 200;
  
  snow = loadImage("ground.png");
  crate = loadImage("crate.png");
  red_brick = loadImage("red_brick.png");
  brown_brick = loadImage("brown_brick.png");
  gold = loadImage("spike1.png");
  spider = loadImage("spider_walk_right1.png");
  
  enemies = new ArrayList<Enemy>();
  
  coins = new ArrayList<Sprite>();
  numCoins = 0;
  isGameOver = false;
  
  platforms = new ArrayList<Sprite>();
  createPlatforms("map.csv");
  
  view_x = 0;
  view_y = 0;
}

void draw()
{
  background(255);
  scroll();
  displayAll();
  
  if(!isGameOver){
    updateAll();
    collectCoins();
    checkDeath();
  }
}

void checkDeath()
{
  ArrayList<Enemy> col_list = checkCollisionEnemy(player, enemies);
  boolean collideEnemy = col_list.size() > 0;
  boolean fallOffCliff = player.getBottom() > GROUND_LEVEL;
  if (collideEnemy || fallOffCliff)
  {
    player.lives--;
    if (player.lives == 0)
    {
      isGameOver = true;
    }
    else
    {
      player.center_x = 400;
      player.setBottom(GROUND_LEVEL);
    }
  }
}

void updateAll()
{
  player.updateAnimation();
  resolvePlatformCollisions(player, platforms);
  
  for (Enemy e: enemies)
  {
    e.update();
    e.updateAnimation();
  }

  for(Sprite coin: coins)
  {
    ((AnimatedSprite)coin).updateAnimation();
  }
}

void collectCoins()
{
  ArrayList<Sprite> collision_list = checkCollisionList(player, coins);
  if (collision_list.size() > 0)
  {
    for(Sprite coin: collision_list)
    {
      coins.remove(coin);
      numCoins++;
    }
  }
  if (coins.size() == 0)
  {
    isGameOver = true;
  }
}

void displayAll()
{
  player.display();
  
  for(Sprite platform: platforms)
  {
    platform.display();
  }
  
  for (Enemy e: enemies)
  {
    e.display();
  }
  
  for(Sprite coin: coins)
  {
    coin.display();
  }
  
  textSize(32);
  fill(255, 0, 0);
  text("Coins: " + numCoins, view_x + 50, view_y + 50);
  text("Lives: " + player.lives, view_x + 50, view_y + 100);
  
  if(isGameOver)
  {
    fill(0,0,255);
    text("GAME OVER!", view_x + width/2 - 100, view_y + height/2);
    if(player.lives == 0)
    {
      text("You lose!", view_x + width/2 - 100, view_y + height/2 + 50);
    }
    else 
    {
      text("You win!", view_x + width/2 - 100, view_y + height/2 + 50);
    }
    text("Press SPACE to restart!", view_x + width/2 - 100, view_y + height/2 + 100);
  }
}

void createPlatforms(String filename)
{
  String[] lines = loadStrings(filename);
  for (int row = 0; row < lines.length; row++)
  {
    String[] values = split(lines[row], ",");
    for (int col = 0; col < values.length; col++)
    {
      if (values[col].equals("A"))
      {
        Sprite s = new Sprite (red_brick, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if (values[col].equals("B"))
      {
        Sprite s = new Sprite(snow, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if (values[col].equals("C"))
      {
        Sprite s = new Sprite(brown_brick, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if (values[col].equals("D"))
      {
        Sprite s = new Sprite(crate, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if (values[col].equals("E"))
      {
        Coin c = new Coin(gold, SPRITE_SCALE);
        c.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        c.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        coins.add(c);
      }
      else if (values[col].equals("F"))
      {
        float bLeft = col * SPRITE_SIZE;
        float bRight = bLeft + 4 * SPRITE_SIZE;
        Enemy enemy = new Enemy(spider, 50/72.0, bLeft, bRight);
        enemy.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        enemy.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        enemies.add(enemy);
      }
    }
  }
}

boolean checkCollision(Sprite s1, Sprite s2)
{
  boolean noXOverlap = s1.getRight() <= s2.getLeft() || s1.getLeft() >= s2.getRight();
  boolean noYOverlap = s1.getBottom() <= s2.getTop() || s1.getTop() >= s2.getBottom();
  if (noXOverlap || noYOverlap)
  {
    return false;
  }
  else
  {
    return true;
  }
} 

ArrayList<Enemy> checkCollisionEnemy(Sprite sprite, ArrayList<Enemy> list)
{
  ArrayList<Enemy> col_list = new ArrayList<Enemy>();
  for (Enemy p: list)
  {
    if(checkCollision(sprite, p))
    {
      col_list.add(p);
    }
  }
  return col_list;
}

ArrayList<Sprite> checkCollisionList(Sprite sprite, ArrayList<Sprite> list)
{
  ArrayList<Sprite> col_list = new ArrayList<Sprite>();
  for (Sprite p: list)
  {
    if(checkCollision(sprite, p))
    {
      col_list.add(p);
    }
  }
  return col_list;
}

void resolvePlatformCollisions(Sprite s, ArrayList<Sprite> walls)
{
  s.change_y += GRAVITY;  
  s.center_y += s.change_y;
  ArrayList<Sprite> list = checkCollisionList(s, walls);

  if (list.size() > 0)
  {
    Sprite collided = list.get(0);
    if (s.change_y > 0)
    {
      s.setBottom(collided.getTop());
    }
    else if (s.change_y < 0)
    {
      s.setTop(collided.getBottom());
    }
    s.change_y = 0;
  }

  s.center_x += s.change_x;
  list = checkCollisionList(s, walls);

  if (list.size() > 0)
  {
    Sprite collided = list.get(0);
    if (s.change_x > 0)
    {
      s.setRight(collided.getLeft());
    }
    else if (s.change_x < 0)
    {
      s.setLeft(collided.getRight());
    }
    s.change_x = 0;
  }
}

boolean isOnPlatforms(Sprite s, ArrayList<Sprite> walls)
{
  s.center_y += 5;
  ArrayList<Sprite> col_list = checkCollisionList(s, walls);
  s.center_y -= 5;

  if (col_list.size() > 0)
  {
    return true;
  }
  else
  {
    return false;
  }
}

void scroll()
{
  float left_boundary = view_x + LEFT_MARGIN;
  if (player.getLeft() < left_boundary)
  {
    view_x -= left_boundary - player.getLeft();
  }

  float right_boundary = view_x + width - RIGHT_MARGIN;
  if (player.getRight() > right_boundary)
  {
    view_x += player.getRight() - right_boundary;
  }

  float top_boundary = view_y + VERTICAL_MARGIN;
  if (player.getTop() < top_boundary)
  {
    view_y -= top_boundary - player.getTop();
  }

  float bottom_boundary = view_y + height - VERTICAL_MARGIN;
  if (player.getBottom() > bottom_boundary)
  {
     view_y += player.getBottom() - bottom_boundary;
  }
  translate(-view_x, -view_y);
}

void keyPressed()
{
  if(keyCode == RIGHT)
  {
    player.change_x = MOVE_SPEED;
  }
  else if (keyCode == LEFT)
  {
    player.change_x = -MOVE_SPEED;
  }
  else if (keyCode == UP && isOnPlatforms(player, platforms))
  {
    player.change_y = - JUMP_SPEED;
  }
  else if(isGameOver && key == ' ')
  {
    setup();
  }
}

void keyReleased()
{
  if (keyCode == RIGHT)
  {
    player.change_x = 0;
  }
  else if(keyCode == LEFT)
  {
    player.change_x = 0;
  }  
}

  
