// You only need to implement the update method of this class.

public class Omen extends Enemy{
  public Omen(PImage img, float scale){
    super(img, scale);;
    standNeutral = new PImage[1];
    standNeutral[0] = loadImage("enemyOmen_standRight.png");
    currentImages = standNeutral;
    direction = NEUTRAL_FACING;
    change_x = 0;
  }
  void update(){
    // call update of Sprite(super)
    super.update();
    
    // if right side of spider >= right boundary
    //   fix by setting right side of spider to equal right boundary
    //   then change x-direction 
    // else if left side of spider <= left boundary
    //   fix by setting lfet side of spider to equal left boundary
    //   then change x-dire


  }
}
