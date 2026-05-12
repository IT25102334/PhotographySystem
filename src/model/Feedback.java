package model;

public class Feedback {

    String customerName;
    String message;
    int rating;

    public Feedback(String customerName, String message, int rating) {
        this.customerName = customerName;
        this.message = message;
        this.rating = rating;
    }

    @Override
    public String toString() {
        return customerName + "," + message + "," + rating;
    }
}

