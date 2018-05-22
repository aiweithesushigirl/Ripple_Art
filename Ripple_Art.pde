import peasy.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import com.hamoid.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;
ddf.minim.analysis.FFT fft;


//water ripple effect
int col;
int row ;
float [][]curr;
//= new float[col][row];
float [][]prev;
//= new float[col][row];
float damping = 0.95;

void setup(){
  size(400, 200);
  colorMode(HSB, 100, 100, 100);
  
  //water ripple
  col = width;
  row = height;
  curr = new float[col][row];
  prev = new float[col][row];
  
  colorMode(HSB, 100, 100, 100);
  smooth(4);
  blendMode(LIGHTEST);
  minim = new Minim(this);
  song = minim.loadFile("Can't Tune You Out.mp3", 128);
  song.play();
  beat = new BeatDetect();
  fft = new ddf.minim.analysis.FFT(song.bufferSize(), song.sampleRate());
}

void mouseDragged(){
  prev[mouseX][mouseY] = 255;
}

void draw(){
  background(0);
  fft.forward(song.right);
  beat.detect(song.mix);
  if (beat.isOnset()){
    waterRipple();
  }
 // waterRipple();
}

void waterRipple(){
    loadPixels();
    for (int i = 1; i < col - 1; ++i){
      for (int j = 1; j < row - 1; ++j){
         curr[i][j] = (prev[i - 1][j] + 
                       prev[i + 1][j] + 
                       prev[i][j + 1] +
                       prev[i][j - 1])/ 2 
                       - curr[i][j];
                       
         curr[i][j] = curr[i][j] * damping;
         int index = i + j * col; 
         pixels[index] = color(curr[i][j]);
          
      }
    }
    updatePixels();
    float[][] temp = prev;
    prev = curr;
    curr = temp;
}