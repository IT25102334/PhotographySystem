package util;
import java.io.*;
public class FileUtil {
    public static void writeToFile(String file, String data) {
            try {
                FileWriter fw = new FileWriter(file, true);
                fw.write(data + "\n");
                fw.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

