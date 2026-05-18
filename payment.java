public class payment {
    public class Payment {
        String id, bookingId;
        double amount;

        public Payment(String id, String bookingId, double amount) {
            this.id = id;
            this.bookingId = bookingId;
            this.amount = amount;
        }

        public String toString() {
            return id + "," + bookingId + "," + amount;
        }
    }
}
