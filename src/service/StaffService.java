package service;

import model.Staff;
import util.FileUtil;

public class StaffService {

    private String file;

    public StaffService(String file) {
        this.file = file;
    }

    public boolean staffExists(String id) {
        for (String line : FileUtil.readFromFile(file)) {
            if (line.startsWith(id + ",")) return true;
        }
        return false;
    }

    public String addStaff(Staff s) {
        if (staffExists(s.getId())) {
            return "Staff ID " + s.getId() + " already exists!";
        }
        FileUtil.writeToFile(file, s.toString());
        return null;
    }

    public void deleteStaff(String id) {
        FileUtil.deleteFromFile(file, id);
    }

    public String findStaff(String id) {
        for (String line : FileUtil.readFromFile(file)) {
            if (line.startsWith(id + ",")) return line;
        }
        return null;
    }

    public int countPhotographers() {
        int count = 0;
        for (String line : FileUtil.readFromFile(file)) {
            String[] data = line.split(",");
            if (data.length > 2 && data[2].equalsIgnoreCase("Photographer")) count++;
        }
        return count;
    }

    public int countByRole(String role) {
        int count = 0;
        for (String line : FileUtil.readFromFile(file)) {
            String[] data = line.split(",");
            if (data.length > 2 && data[2].equalsIgnoreCase(role)) count++;
        }
        return count;
    }
}