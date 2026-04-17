package service;

import model.Booking;
import java.io.*;
import java.util.ArrayList;

public class BookingService {
    private static final String FILE_NAME = "bookings.txt";

    public void addBooking(Booking booking) {
        try {
            FileWriter writer = new FileWriter(FILE_NAME, true);
            writer.write(booking.toFileString() + "\n");
            writer.close();
            System.out.println("Booking.Booking added successfully.");
        } catch (IOException e) {
            System.out.println("Error while saving booking.");
        }
    }

    public ArrayList<Booking> getAllBookings() {
        ArrayList<Booking> bookings = new ArrayList<>();

        try {
            File file = new File(FILE_NAME);

            if (!file.exists()) {
                file.createNewFile();
            }

            BufferedReader reader = new BufferedReader(new FileReader(FILE_NAME));
            String line;

            while ((line = reader.readLine()) != null) {
                String[] data = line.split(",");

                if (data.length == 4) {
                    Booking booking = new Booking(data[0], data[1], data[2], data[3]);
                    bookings.add(booking);
                }
            }

            reader.close();
        } catch (IOException e) {
            System.out.println("Error while reading bookings.");
        }

        return bookings;
    }

    public void displayAllBookings() {
        ArrayList<Booking> bookings = getAllBookings();

        if (bookings.isEmpty()) {
            System.out.println("No bookings found.");
        } else {
            for (Booking booking : bookings) {
                System.out.println(booking);
            }
        }
    }

//Add SEARCH Booking.  shows logic / shows file reading clearly.

    public Booking searchBookingById(String searchId) {

        try {
            BufferedReader reader = new BufferedReader(new FileReader("bookings.txt"));
            String line;

            while ((line = reader.readLine()) != null) {
                String[] data = line.split(",");

                if (data[0].equals(searchId)) {
                    reader.close();
                    return new Booking(data[0], data[1], data[2], data[3]);
                }
            }

            reader.close();

        } catch (Exception e) {
            System.out.println("Error searching booking");
        }

        return null;
    }


//Update Booking.

    public boolean updateBooking(String searchId, String newName, String newDate, String newLocation) {
        ArrayList<Booking> bookings = getAllBookings();
        boolean found = false;

        try {
            FileWriter writer = new FileWriter("bookings.txt");

            for (Booking booking : bookings) {
                if (booking.getBookingId().equals(searchId)) {
                    booking.setCustomerName(newName);
                    booking.setEventDate(newDate);
                    booking.setLocation(newLocation);
                    found = true;
                }

                writer.write(booking.toFileString() + "\n");
            }

            writer.close();

        } catch (Exception e) {
            System.out.println("Error updating booking");
        }

        return found;
    }


//Delete Booking.

    public boolean deleteBooking(String deleteId) {
        ArrayList<Booking> bookings = getAllBookings();
        boolean found = false;

        try {
            FileWriter writer = new FileWriter(FILE_NAME);

            for (Booking booking : bookings) {
                if (booking.getBookingId().equals(deleteId)) {
                    found = true;
                    continue;
                }

                writer.write(booking.toFileString() + "\n");
            }

            writer.close();

        } catch (Exception e) {
            System.out.println("Error deleting booking");
        }

        return found;
    }


}