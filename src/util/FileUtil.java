package util;

import java.io.*;
import java.util.*;

public class FileUtil {

    // READ from file
    public static List<String> readFromFile(String filePath) {
        List<String> lines = new ArrayList<>();
        try {
            BufferedReader br = new BufferedReader(new FileReader(filePath));
            String line;
            while ((line = br.readLine()) != null) {
                if (!line.trim().isEmpty()) lines.add(line);
            }
            br.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return lines;
    }

   
    public static void writeToFile(String filePath, String text) {
        try {
            BufferedWriter bw = new BufferedWriter(new FileWriter(filePath, true));
            bw.write(text);
            bw.newLine();
            bw.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    
    public static void deleteFromFile(String filePath, String id) {
        List<String> lines = readFromFile(filePath);
        try {
            BufferedWriter bw = new BufferedWriter(new FileWriter(filePath, false));
            for (String line : lines) {
                if (!line.startsWith(id + ",")) {
                    bw.write(line);
                    bw.newLine();
                }
            }
            bw.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
