package util;
import java.io.*;
import java.util.*;

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

    public static List<String> readFromFile(String file) {
        List<String> list = new ArrayList<>();
        try {
            BufferedReader br = new BufferedReader(new FileReader(file));
            String line;
            while ((line = br.readLine()) != null) {
                list.add(line);
            }
            br.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
