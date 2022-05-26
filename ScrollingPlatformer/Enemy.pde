// You only need to implement the update method of this class.

public class Enemy extends AnimatedSprite{
  public float speed;
  public Enemy(PImage img, float scale){
    super(img, scale);
  }
  void update(){
    // call update of Sprite(super)
    super.update();
    
    // if right side of spider >= right boundary
    //   fix by setting right side of spider to equal right boundary
    //   then change x-direction 
    // else if left side of spider <= left boundary
    //   fix by setting lfet side of spider to equal left boundary
    //   then change x-direction 
  }
}
