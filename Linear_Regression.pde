// Gloabal variables for holding the x and y coordinates of the mouse
// position on the screen
float mouse_x;
float mouse_y;
// A list of point vectors
// stores the x and y position of the datapoints
ArrayList<PVector> points = new ArrayList<PVector>();

void setup(){
// Initialize screen width and height
  size(600,600);
}
// loop 
void draw(){
  background(45);
  
  // Add a Y and X axis line
  stroke(255);
  line(10,10,10,height-10);
  line(10,height-10,width-10,height-10);
  
  fill(255,0,0);
  // If the two data points are created, then draw the points
  // and find the line that fits the data
  if (points.size() > 0){
    for(int i = 0; i < points.size();i++){
      float xcord = map(points.get(i).x,0,1,0,width);
      float ycord = map(points.get(i).y,0,1,height,0);
      // draw the points
      circle(xcord,ycord,10);
    }
   }
  if (points.size() > 1){    
    // Draw a line
  float x1 = 0;
  float x2 = 1;
  
  float[] meanAndIntercept = linearRegression();
  float m = meanAndIntercept[0];
  float b = meanAndIntercept[1];
  
  float y1 = m *x1 + b;
  float y2 = m *x2 + b;
  
  x1 = map(x1,0,1,0,width-10);
  x2 = map(x2,0,1,0,width-10);
  
  y1 = map(y1,0,1,height-10,0);
  y2 = map(y2,0,1,height-10,0);
  stroke(0,255,0);
  line(x1,y1,x2,y2);
  } 
  
}
// Called when the user clicks the mouse on the screen
void mousePressed(){
  mouse_x = map(mouseX,0,width,0,1);
  mouse_y = map(mouseY,0,height,1,0);
  println("("+mouse_x+","+mouse_y+")");
  PVector pvector = new PVector(mouse_x,mouse_y);
  points.add(pvector);
}

/*Calculate the optimal values for slope (m) and y-intercept(b) -
for the equation of line y = mx + b*/
float[] linearRegression(){

/* The optimal values of m and b found using ordinary(simple) least squares, is given by
the equation 
            sum(((x - xMean)^2) * ((y-yMean)^2)) 
      m =   ______________________________________
                  sum((x-xMean)^2)
                  
                  
       b = yMean - m*xMean        
       
 */
  
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
