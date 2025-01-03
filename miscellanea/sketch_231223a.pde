import java.awt.image.BufferedImage;
import javax.imageio.ImageReader;
import java.io.FileInputStream;
import java.awt.image.Raster;
import javax.imageio.stream.ImageInputStream;
import javax.imageio.ImageIO;
import java.util.Iterator;

import java.io.File;
import java.io.IOException;
import javax.imageio.ImageReader;
import javax.imageio.stream.ImageInputStream;


String f="C:\\Users\\Fabio\\Desktop\\data\\new\\futanari new\\to filter\\1656077705504.jpg";
PImage img;

void setup() {
  try{
    println(ext(f));
  }catch(IOException e){
  }
  size(400, 400);
}

void draw() {
  background(0);
  exit();
  //image(img,0,0,400,400);
}




public static String ext (String f) throws IOException {
  File file = new File(f);
  ImageInputStream iis = ImageIO.createImageInputStream(file);
  Iterator<ImageReader> iter = ImageIO.getImageReaders(iis);
  if (!iter.hasNext()) {
    throw new RuntimeException("No readers found!");
  }
  ImageReader reader = iter.next();
  iis.close();
  return reader.getFormatName();
}



public static PImage readCMYKImage(String source) throws Exception {
  File file=new File (source);
  Iterator<ImageReader> readers = ImageIO.getImageReadersByFormatName("jpeg");
  ImageReader reader = null;
  while (readers.hasNext()) {
    reader = readers.next();
    if (reader.canReadRaster()) {
      break;
    }
  }

  FileInputStream fis = new FileInputStream(file);

  BufferedImage image=null;
  try {
    ImageInputStream input = ImageIO.createImageInputStream(fis);

    reader.setInput(input); // original CMYK-jpeg stream

    Raster raster = reader.readRaster(0, null); // read image raster
    println(raster.getWidth());
    image = new BufferedImage(raster.getWidth(), raster.getHeight(), BufferedImage.TYPE_4BYTE_ABGR);
    image.getRaster().setRect(raster);
  }
  catch(Exception e) {
    println("an error ocurred");
    e.printStackTrace();
  }
  finally {
    try {
      fis.close();
    }
    catch(Exception ex) {
    }
  }


  try {
    PImage img=new PImage(image.getWidth(), image.getHeight(), PConstants.ARGB);
    image.getRGB(0, 0, img.width, img.height, img.pixels, 0, img.width);
    img.updatePixels();

    return img;
  }
  catch(Exception e) {
    System.err.println("Can't create image from buffer");
    e.printStackTrace();
  }
  return null;
}
