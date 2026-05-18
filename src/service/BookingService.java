package service;

import util.FileUtil;
import model.Booking;

public class BookingService {

    private String file;

    public BookingService(String file) {
        this.file = file;
    }

    public boolean isDateAvailable(String date) {
        for (String line : FileUtil.readFromFile(file)) {
            String[] data = line.split(",");
            if (data.length > 2 && data[2].equals(date)) return false;
        }
        return true;
    }

    // Returns error string or null if success
    public String addBooking(Booking b) {
        if (!isDateAvailable(b.getDate())) {
            return "Date " + b.getDate() + " is already booked! Please choose another date.";
        }
        FileUtil.writeToFile(file, b.toString());
        return null; // null = success
    }

    public void deleteBooking(String id) {
        FileUtil.deleteFromFile(file, id);
    }

    public String findBooking(String id) {
        for (String line : FileUtil.readFromFile(file)) {
            if (line.startsWith(id + ",")) return line;
        }
        return null;
    }

    public int countBookings() {
        return FileUtil.readFromFile(file).size();
    }
}