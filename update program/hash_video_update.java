import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Scanner;

import java.awt.image.BufferedImage;
import org.bytedeco.javacv.FFmpegFrameGrabber;
import org.bytedeco.javacv.Frame;
import org.bytedeco.javacv.Java2DFrameConverter;

public class hash_video_update {

    public static void main(String[] args) {
        File in = new File("C:\\Users\\trava\\Desktop\\data\\tool\\general\\var\\hash_vid");
        File[] cartelle = in.listFiles();
        int size = 0;

        for (int i = 0; i < cartelle.length; i++) {
            String line = "";
            File target;
            String[] img_key = new String[1];
            String[] img_path = new String[1];
            try {
                FileInputStream fr = new FileInputStream(cartelle[i]);
                Scanner reader = new Scanner(fr);
                line = reader.nextLine();
                size = Integer.parseInt(line.substring(line.lastIndexOf(' ') + 1, line.length()));
                line = line.substring(0, line.lastIndexOf(' '));
                target = new File(line);
                System.out.println("reading file of " + line);
                File[] files = target.listFiles();
                for (int j = 0; j < files.length; j++) {
                    // System.out.println(j+"\\"+files.length);
                    if (files[j].isDirectory()) {
                        files = joinfile(files, files[j].listFiles());
                    }
                }

                files = seev(files);
                line = "";
                System.out.println("reading key");
                while (reader.hasNextLine()) {
                    // System.out.println(line);
                    line = reader.nextLine();
                    if (line != null & line.length() > (size * size * 2) - 1) {
                        img_key = pushs(img_key, line.substring(0, (size * size * 2)));
                        img_path = pushs(img_path, line.substring((size * size * 2) + 1));
                    }
                }
                fr.close();
                reader.close();
                int toHash = 0;
                int toFind = 0;
                try {
                    FileWriter fw = new FileWriter(cartelle[i]);
                    // FileWriter fw =new FileWriter("C:\\Users\\trava\\Desktop\\data\\test.txt");
                    fw.write(target.getAbsolutePath() + " " + size + "\n");
                    System.out.println("processing");
                    for (int j = 0; j < files.length; j++) {
                        // System.out.println(files[j].toPath());
                        boolean find = false;
                        boolean next = false;
                        for (int k = 0; k < img_key.length & !next; k++) {
                            if (files[j].getAbsolutePath().equals(img_path[k])) {
                                fw.write(img_key[k] + " " + img_path[k] + "\n");
                                find = true;
                            } else if (find) {
                                next = true;
                            }
                        }

                        if (!find) {
                            System.out.println(
                                    files[j].getAbsolutePath() + " " + j + "\\" + (files.length - 1) + " hash");
                            toHash++;
                            tohash(files[j], fw, size);
                        } else {
                            System.out.println(
                                    files[j].getAbsolutePath() + " " + j + "\\" + (files.length - 1) + " find");
                            toFind++;
                        }
                    }
                    System.out.println("to hash " + toHash + " to find " + toFind);
                    fw.close();
                } catch (Exception e) {

                }

            } catch (IOException ex) {
                System.err.println("file not found");
            }
        }

    }

    static File[] seev(File[] in) {
        File[] out = null;
        for (int i = 0; i < in.length; i++) {
            if (in[i].isFile() & extensioncheck(in[i]) & !in[i].isDirectory()) {
                out = pushfile(out, in[i]);
            }
        }
        return out;
    }

    static boolean extensioncheck(File f) {
        String ext = f.getName().substring(f.getName().lastIndexOf('.') + 1);
        String[] ok = { "mp4", "webm", "mkv", "MP4", "m4v" };
        for (int i = 0; i < ok.length; i++) {
            if (ext.equals(ok[i])) {
                return true;
            }
        }
        return false;
    }

    static File[] pushfile(File[] array1, File in) {
        File[] result;
        if (array1 == null) {
            result = new File[1];
            result[0] = in;
        } else {
            result = new File[array1.length + 1];
            System.arraycopy(array1, 0, result, 0, array1.length);
            result[result.length - 1] = in;
        }
        return result;
    }

    static File[] joinfile(File[] array1, File[] array2) {
        File[] result = new File[array1.length + array2.length];
        System.arraycopy(array1, 0, result, 0, array1.length);
        System.arraycopy(array2, 0, result, array1.length, array2.length);
        return result;
    }

    static String[] pushs(String[] array1, String val) {
        String[] result;
        if (array1[0] != null) {
            result = new String[array1.length + 1];
            System.arraycopy(array1, 0, result, 0, array1.length);
            result[result.length - 1] = val;
        } else {
            result = new String[1];
            result[0] = val;
        }
        return result;
    }

    static int tohash(File target, FileWriter out, int dim) {
        final int snip = 1;
        int frame = 0;
        int i = 0;
        int fill = 0;
        FFmpegFrameGrabber frameGrabber = new FFmpegFrameGrabber(target);

        try {
            frameGrabber.start();
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (frameGrabber.getFrameRate() < 1) { // se il framerate è minore di 1 (1 caso noto) troppo lavoro da fare
            try {
                frameGrabber.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            return 0;
        }
        Java2DFrameConverter c = new Java2DFrameConverter();
        Frame f;
        String[] hash = new String[(int) (frameGrabber.getLengthInTime() / 1000000) + 1];
        boolean acq = false;
        int drop = 0;
        try {
            i = 0;
            int hash_index = 0;
            BufferedImage[] frames = new BufferedImage[roundto1(frameGrabber.getFrameRate() * snip)];
            while (i < frameGrabber.getLengthInFrames() & drop < 100) {
                f = frameGrabber.grabImage();
                BufferedImage bi = c.convert(f);
                if (bi != null) {
                    frames[fill] = bi;
                    fill++;
                    i++;
                    acq = true;
                    drop = 0;
                } else {
                    drop++;
                }
                if (fill == (int) Math.round(frameGrabber.getFrameRate() * snip) & i < frameGrabber.getLengthInFrames()
                        & i != 0
                        & acq) {
                    fill = 0;
                    hash[hash_index] = key(frames, dim);
                    if (hash_index + 1 < hash.length) {
                        hash_index++;
                    }
                }
                acq = false;
            }
            frame = frameGrabber.getLengthInFrames();
            frameGrabber.stop();
            frameGrabber.close();
            c.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.println("printing " + hash.length + " result");
        for (int d = 0; d < hash.length; d++) {
            try {
                if (hash[d] != null & !zero_check(hash[d])) {
                    out.write(hash[d] + " " + target.getAbsoluteFile() + "\n");
                }
            } catch (IOException e) {
                System.out.println("An error occurred.");
                e.printStackTrace();
            }
        }
        return frame;
    }

    static int roundto1(double a) {
        float res = Math.round(a);
        if (res < 1) {
            res = 1;
        }
        return (int) res;
    }

    static boolean zero_check(String hash) {
        boolean is_zero = true;
        if (hash != null) {
            for (int i = 0; i < hash.length() & is_zero; i++) {
                if (hash.charAt(i) != '0') {
                    is_zero = false;
                }
            }
        }
        return is_zero;

    }

    static String key(BufferedImage[] val, int dim) {
        String result = "";
        int[] key = new int[dim * dim];
        int i = 0;
        for (i = 0; i < val.length; i++) {
            if (val[i] != null) {
                int[] aux = makeGray(val[i], dim);
                for (int j = 0; j < dim * dim; j++) {
                    key[j] += aux[j];
                }
            } else {
                System.err.println("null");
            }
        }
        for (int j = 0; j < dim * dim; j++) {
            key[j] = key[j] / i;
        }
        for (int k = 0; k < dim * dim; k++) {
            result += toHex((int) key[k]);
        }
        return result;
    }

    static String toHex(int a) {
        String result = "";
        result += esa(a / 16);
        result += esa(a % 16);
        return result;
    }

    static char esa(int val) {
        switch (val) {
            case 0:
                return '0';
            case 1:
                return '1';
            case 2:
                return '2';
            case 3:
                return '3';
            case 4:
                return '4';
            case 5:
                return '5';
            case 6:
                return '6';
            case 7:
                return '7';
            case 8:
                return '8';
            case 9:
                return '9';
            case 10:
                return 'a';
            case 11:
                return 'b';
            case 12:
                return 'c';
            case 13:
                return 'd';
            case 14:
                return 'e';
            case 15:
                return 'f';
            default:
                return '-';
        }

    }

    static File[] pushf(File[] array, File val) {
        File[] result = null;
        if (array != null) {
            result = new File[array.length + 1];
            System.arraycopy(array, 0, result, 0, array.length);
            result[result.length - 1] = val;
        } else {
            result = new File[1];
            result[0] = val;
        }
        return result;
    }

    static BufferedImage[] push(BufferedImage[] array, BufferedImage val) {
        BufferedImage[] result = null;
        if (array != null) {
            result = new BufferedImage[array.length + 1];
            System.arraycopy(array, 0, result, 0, array.length);
            result[result.length - 1] = val;
        } else {
            result = new BufferedImage[1];
            result[0] = val;
        }
        return result;
    }

    public static int[] makeGray(BufferedImage img, int dim) {
        int hei = img.getHeight();
        int wid = img.getWidth();
        int[] result = new int[dim * dim];
        int stepx = (int) ((wid) / (dim));
        int stepy = (int) ((hei) / (dim));

        for (int i = 0; i < dim; i++) {// x
            for (int j = 0; j < dim; j++) {// y
                int rgb = img.getRGB(i * stepx, j * stepy);
                int r = (rgb >> 16) & 0xFF;
                int g = (rgb >> 8) & 0xFF;
                int b = (rgb & 0xFF);

                // Normalize and gamma correct:
                double rr = Math.pow(r / 255.0, 2.2);
                double gg = Math.pow(g / 255.0, 2.2);
                double bb = Math.pow(b / 255.0, 2.2);

                // Calculate luminance:
                double lum = 0.2126 * rr + 0.7152 * gg + 0.0722 * bb;

                // Gamma compand and rescale to byte range:
                result[j + (i * dim)] = (int) (255.0 * Math.pow(lum, 1.0 / 2.2));
            }
        }
        return result;
    }

    static File[] joinarray(File[] array1, File[] array2) {
        File[] result = new File[array1.length + array2.length];
        System.arraycopy(array1, 0, result, 0, array1.length);
        System.arraycopy(array2, 0, result, array1.length, array2.length);
        return result;
    }
}