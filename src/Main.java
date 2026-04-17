import model.Booking;
import service.BookingService;
public class Main {
    public static void main(String[] args) {
        BookingService bookingService = new BookingService();

        Booking booking1 = new Booking("B001", "Thisath", "2026-05-10", "Colombo");
        Booking booking2 = new Booking("B002", "Nimal", "2026-06-15", "Galle");

        bookingService.addBooking(booking1);
        bookingService.addBooking(booking2);

        System.out.println("\nAll Bookings:");
        bookingService.displayAllBookings();

//Add SEARCH Booking.Booking.  shows logic / shows file reading clearly.

        BookingService service = new BookingService();

        Booking result = service.searchBookingById("B001");

        if (result != null) {
            System.out.println("\nFound Booking.Booking:");
            System.out.println(result);
        } else {
            System.out.println("Booking.Booking not found");
        }

//Update Booking.Booking.

        boolean updated = bookingService.updateBooking("B001", "Thisath Geemeth", "2026-05-20", "Kandy");

        if (updated) {
            System.out.println("Booking.Booking updated successfully.");
        } else {
            System.out.println("Booking.Booking not found.");
        }

        System.out.println("\nAll Bookings After Update:");
        bookingService.displayAllBookings();

//Delete Booking.Booking.

        boolean deleted = bookingService.deleteBooking("B002");

        if (deleted) {
            System.out.println("Booking.Booking deleted successfully.");
        } else {
            System.out.println("Booking.Booking not found.");
        }

        System.out.println("\nAll Bookings After Delete:");
        bookingService.displayAllBookings();
    }
}



/*
import model.Booking;
import service.BookingService;

public class Main {
    public static void main(String[] args) {

        BookingService bookingService = new BookingService();

        Booking booking1 = new Booking("B001", "Thisath", "2026-05-10", "Colombo");
        Booking booking2 = new Booking("B002", "Nimal", "2026-06-15", "Galle");

        bookingService.addBooking(booking1);
        bookingService.addBooking(booking2);

        System.out.println("\nAll Bookings:");
        bookingService.displayAllBookings();
    }
}*/