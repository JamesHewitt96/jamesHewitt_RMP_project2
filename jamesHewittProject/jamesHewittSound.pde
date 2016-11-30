import ddf.minim.*;

AudioPlayer player;
Minim minim;

void stop()
{
  player.close();
  minim.stop();
  super.stop();
}