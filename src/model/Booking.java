package model;

/**
 * Booking — Model class
 * Now includes packageId so customer can select a package when booking
 *
 * Stored as: id,customerId,date,packageId
 *
 * OOP Concepts:
 *  - Encapsulation  : private fields with getters
 *  - Constructor OL : 2 constructors (with package, without package)
 *  - toString       : CSV format for file storage
 */
public class Booking {

    // Private fields — ENCAPSULATION
    private String id;
    private String customerId;
    private String date;
    private String packageId;  // NEW — selected package

    // Constructor 1 — Full details with package (CONSTRUCTOR OVERLOADING)
    public Booking(String id, String customerId, String date, String packageId) {
        this.id         = id;
        this.customerId = customerId;
        this.date       = date;
        this.packageId  = (packageId == null || packageId.trim().isEmpty())
                ? "None" : packageId.trim();
    }

    // Constructor 2 — No package selected (CONSTRUCTOR OVERLOADING)
    public Booking(String id, String customerId, String date) {
        this(id, customerId, date, "None");
    }

    // ── Getters — ENCAPSULATION ──
    public String getId()         { return id; }
    public String getCustomerId() { return customerId; }
    public String getDate()       { return date; }
    public String getPackageId()  { return packageId; }

    // toString for file storage
    @Override
    public String toString() {
        return id + "," + customerId + "," + date + "," + packageId;
    }
}