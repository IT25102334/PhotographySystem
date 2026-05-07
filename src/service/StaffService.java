package service;

import model.Staff;
import util.FileUtil;

public class StaffService {

    String file = "data/staff.txt";

    public void addStaff(Staff s) {
        FileUtil.writeToFile(file, s.toString());
    }
}
