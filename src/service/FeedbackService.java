package service;

import util.FileUtil;
import model.Feedback;

import java.io.*;
import java.util.*;

public class FeedbackService {

    private String file;

    public FeedbackService(String file) {
        this.file = file;
    }

    public void addFeedback(Feedback f) {
        FileUtil.writeToFile(file, f.toString());
    }

    public void deleteFeedback(String customerName) {
        List<String> lines = FileUtil.readFromFile(file);
        try {
            BufferedWriter bw = new BufferedWriter(new FileWriter(file, false));
            for (String line : lines) {
                String[] data = line.split(",");
                if (!data[0].equals(customerName)) {
                    bw.write(line);
                    bw.newLine();
                }
            }
            bw.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public double calculateAverageRating() {
        double total = 0;
        int count = 0;
        for (String line : FileUtil.readFromFile(file)) {
            String[] data = line.split(",");
            if (data.length > 2) {
                try { total += Integer.parseInt(data[2].trim()); count++; }
                catch (Exception e) {}
            }
        }
        if (count == 0) return 0;
        return Math.round((total / count) * 10.0) / 10.0;
    }

    public int countPositiveFeedback() {
        int count = 0;
        for (String line : FileUtil.readFromFile(file)) {
            String[] data = line.split(",");
            if (data.length > 2) {
                try { if (Integer.parseInt(data[2].trim()) >= 4) count++; }
                catch (Exception e) {}
            }
        }
        return count;
    }

    public int countNegativeFeedback() {
        int count = 0;
        for (String line : FileUtil.readFromFile(file)) {
            String[] data = line.split(",");
            if (data.length > 2) {
                try { if (Integer.parseInt(data[2].trim()) <= 2) count++; }
                catch (Exception e) {}
            }
        }
        return count;
    }
}
