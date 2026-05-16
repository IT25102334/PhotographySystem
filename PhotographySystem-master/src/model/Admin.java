package model;

/**
 * Admin — Model class for system login accounts
 * Kept SEPARATE from Customer intentionally:
 *   - Customer = a person who books photo sessions (extends User)
 *   - Admin    = a person who logs into the management system
 *
 * Stored in admins.txt as: username,password,role
 * e.g: admin,123,admin
 *      staff1,pass1,user
 *
 * OOP Concepts:
 *  - Encapsulation        : private fields, validated getters/setters
 *  - Constructor Overload : 2 constructors (full, default role)
 *  - toString override    : for file storage
 */
public class Admin {

    // Private fields — ENCAPSULATION
    private String username;
    private String password;
    private String role;     // "admin" or "user"

    // Constructor 1 — Full details (CONSTRUCTOR OVERLOADING)
    public Admin(String username, String password, String role) {
        this.username = username;
        this.password = password;
        this.role     = role;
    }

    // Constructor 2 — Default role is "user" (CONSTRUCTOR OVERLOADING)
    public Admin(String username, String password) {
        this(username, password, "user");
    }

    // ── Getters — ENCAPSULATION ──
    public String getUsername() { return username; }
    public String getPassword() { return password; }
    public String getRole()     { return role; }

    // ── Setters with validation — ENCAPSULATION ──
    public void setPassword(String password) {
        if (password == null || password.trim().length() < 3)
            throw new IllegalArgumentException("Password must be at least 3 characters");
        this.password = password;
    }

    public void setRole(String role) {
        if (!role.equals("admin") && !role.equals("user"))
            throw new IllegalArgumentException("Role must be admin or user");
        this.role = role;
    }

    // Check if this admin has full admin rights
    public boolean isAdmin() {
        return "admin".equals(this.role);
    }

    // toString for saving to file
    @Override
    public String toString() {
        return username + "," + password + "," + role;
    }
}