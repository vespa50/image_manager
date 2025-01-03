


final String target = "C:\\Users\\trava\\Desktop\\data";
File [] files;

void setup() {
  File dir=new File(target);
  files=dir.listFiles();
  for (int s=0; s<files.length; s++) {
    if (files[s].isDirectory()) {
      File [] partial = files[s].listFiles();
      if (partial.length==0) {
        println(files[s].getPath()+" "+partial.length+" elements");
      } else {
        files=joinarray(files, partial);
      }
    }
  }
}

void draw() {
  exit();
}

File[] joinarray(File[] array1, File[] array2) {
  File[] result =new File [array1.length + array2.length];
  System.arraycopy(array1, 0, result, 0, array1.length);
  System.arraycopy(array2, 0, result, array1.length, array2.length);
  return result;
}
