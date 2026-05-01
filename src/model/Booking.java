package model;

public class Booking {
    private String bookingId;
    private String customerName;
    private String eventDate;
    private String location;

    public Booking() {
    }

    public Booking(String bookingId, String customerName, String eventDate, String location) {
        this.bookingId = bookingId;
        this.customerName = customerName;
        this.eventDate = eventDate;
        this.location = location;
        //this.Dumindu
    }

    public String getBookingId() {
        return bookingId;
    }

    public void setBookingId(String bookingId) {
        this.bookingId = bookingId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getEventDate() {
        return eventDate;
    }

    public void setEventDate(String eventDate) {
        this.eventDate = eventDate;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String toFileString() {
        return bookingId + "," + customerName + "," + eventDate + "," + location;
    }

    @Override
    public String toString() {
        return "Booking.Booking ID: " + bookingId +
                ", Customer Name: " + customerName +
                ", Event Date: " + eventDate +
                ", Location: " + location;
    }
}
