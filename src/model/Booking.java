package model;

public class Booking {

    private String id;
    private String customerId;
    private String date;
    private String packageId;  

    public Booking(String id, String customerId, String date, String packageId) {
        this.id         = id;
        this.customerId = customerId;
        this.date       = date;
        this.packageId  = (packageId == null || packageId.trim().isEmpty())
                ? "None" : packageId.trim();
    }

    public Booking(String id, String customerId, String date) {
        this(id, customerId, date, "None");
    }

    public String getId()         { return id; }
    public String getCustomerId() { return customerId; }
    public String getDate()       { return date; }
    public String getPackageId()  { return packageId; }

    @Override
    public String toString() {
        return id + "," + customerId + "," + date + "," + packageId;
    }
}
