float mouse_x;
float mouse_y;
ArrayList<PVector> points = new ArrayList<PVector>();

void setup(){
  size(400,400);
}

void draw(){
  background(45);
  fill(255,0,0);
  if (points.size() > 1){
    for(int i = 0; i < points.size();i++){
      float xcord = map(points.get(i).x,0,1,0,width);
      float ycord = map(points.get(i).y,0,1,height,0);
      circle(xcord,ycord,10);
    }
    
    // Draw a line
  float x1 = 0;
  float x2 = 1;
  float[] meanAndIntercept = linearRegression();
  float m = meanAndIntercept[0];
  float b = meanAndIntercept[1];
  
  float y1 = m *x1 + b;
  float y2 = m *x2 + b;
  
  x1 = map(x1,0,1,0,width);
  x2 = map(x2,0,1,0,width);
  
  y1 = map(y1,0,1,height,0);
  y2 = map(y2,0,1,height,0);
  stroke(255);
  line(x1,y1,x2,y2);
  } 
  
}

void mousePressed(){
  mouse_x = map(mouseX,0,width,0,1);
  mouse_y = map(mouseY,0,height,1,0);
  println("("+mouse_x+","+mouse_y+")");
  PVector pvector = new PVector(mouse_x,mouse_y);
  points.add(pvector);
}

float[] linearRegression(){
  
  float sumOfMeanResiduals = 0;
  float xMeanSquaredError = 0;
  
  float[] means = findMeanValues();
  float xMean = means[0];
  float yMean = means[1];
  
  for(PVector p : points){
    sumOfMeanResiduals += (p.x - xMean) * (p.y - yMean);
    xMeanSquaredError += pow((p.x - xMean),2);
  }
  
  float slope = sumOfMeanResiduals / xMeanSquaredError;
  float yIntercept = findYIntercept(slope,means);  
  
  float[] slopeAndIntercept = {slope,yIntercept};
  return slopeAndIntercept;
}


float[] findMeanValues(){
  //Calculate the xMean and yMean of the observed data
  
  float xMean = 0;
  float yMean = 0;
  //Find xMean
  for(PVector p : points){
    xMean += p.x;
    yMean += p.y;
  }
  xMean = xMean / points.size();
  yMean = yMean / points.size();
  
  float[] means = {xMean,yMean};
  
  return means;
  
}

float findYIntercept(float slope,float[] means){
  float b;
  float m = slope;
  float xMean = means[0];
  float yMean = means[1];
  
  b = yMean - m * xMean;
  
  return b;
}
