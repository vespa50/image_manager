
int n = 8;
float last=0;
float current=0;
PImage img;
File [] files;
int i=0;
float min=0;
float max=0;
 
float [][] dctTransform(int matrix[], int n){
    float dct[][]=new float[n][n];
 
    float ci, cj, dct1, sum;
 
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
 
            // ci and cj depends on frequency as well as
            // number of row and columns of specified matrix
            if (i == 0)
                ci = 1 / sqrt(n);
            else
                ci = sqrt(2) / sqrt(n);
            if (j == 0)
                cj = 1 / sqrt(n);
            else
                cj = sqrt(2) / sqrt(n);
 
            // sum will temporarily store the sum of 
            // cosine signals
            sum = 0;
            for (int k = 0; k < n; k++) {
                for (int l = 0; l < n; l++) {
                    dct1 = matrix[l+k*n]*cos((2*k+1)*i*PI/(2 * n))*cos((2*l+1)*j*PI/(2*n));
                    sum = sum + dct1;
                }
            }
            dct[i][j] = ci * cj * sum;
        }
    }
 
   return dct;
}

float hash(PImage scale,int dim){
  int[]gray_val=new int[dim*dim];
  float result [][]=new float[dim][dim];
  float out=0;
  scale.filter(GRAY);
        for (int x=0; x<dim; x++) {
          for (int y=0; y<dim; y++) {
            int mean=0;
            int dim_w=floor(scale.width/dim);
            int dim_h=floor(scale.height/dim);
            for (int in_x=0; in_x<dim_w; in_x++) {
              for (int in_y=0; in_y<dim_h; in_y++) {
                mean=mean+(scale.get(in_x+(x*dim_w), in_y+(y*dim_h))&0x000000ff);
              }
            }
            mean=mean/(dim_w*dim_h);
            gray_val[x+(y*dim)]=mean;
          }
        }
        result=dctTransform(gray_val,dim);
        float mean=0;
        for (int x=0; x<dim; x++) {
          for (int y=0; y<dim; y++) {
            if(x!=0&y!=0){
              mean=mean+result[x][y];
            }
          }
        }
        mean=mean/(dim*dim-1);
        for(int x=0;x<dim;x++){
          for (int y=0; y<dim; y++) {
            if(result[x][y]>mean){
               out=out+pow(2,(x+y*dim)); 
            }
          }
        }
        return out;
}

 
// Driver code
void setup()
{
    File f = new File("C:\\Users\\trava\\Desktop\\data\\in\\busy1\\Hyper_05");
    files=f.listFiles();
    for(int s=0;s<files.length;s++){
      if(files[s].isDirectory()){
        File [] partial = files[s].listFiles();
        files=joinarray(files,partial);
      }
    }
    size(800,800);                  
}

void draw(){
  String ext = files[i].getName().substring(files[i].getName().lastIndexOf('.') + 1);
  if(files[i].isFile()&&(ext.equals("jpg")||ext.equals("png")||ext.equals("jpeg"))){
    img=loadImage(files[i].getAbsolutePath());
    image(img,0,0,800,800);
    if(i==0){
      last=hash(img,n);
      println(last);
    }else{
      current=hash(img,n);
      println(log10(abs(current-last)+1)," ",abs(current-last)," ",current," ",last);
      last=current;
      
    }
   }
  i++;
}

static File[] joinarray(File[] array1, File[] array2) {
    File[] result =new File [array1.length + array2.length];
    System.arraycopy(array1, 0, result, 0, array1.length);
    System.arraycopy(array2, 0, result, array1.length, array2.length);
    return result;
}

float log10 (float x) {
  return (log(x) / log(10));
}
