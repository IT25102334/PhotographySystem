
package service;

import model.Admin;
import util.FileUtil;
import java.util.List;

/**
 * AdminService — handles all login/register business logic
 * Demonstrates: Encapsulation, Abstraction (hides file logic from servlet)
 *
 * Uses admins.txt for storage — completely separate from customers.txt
 */
public class AdminService {

    private String file;

    public AdminService(String file) {
        this.file = file;
        createDefaultAdmin(); // ensures admin,123,admin always exists
    }

    // Auto-create default admin if file is empty
    private void createDefaultAdmin() {
        List<String> lines = FileUtil.readFromFile(file);
        if (lines.isEmpty()) {
            Admin defaultAdmin = new Admin("admin", "123", "admin");
            FileUtil.writeToFile(file, defaultAdmin.toString());
        }
    }

    // Check if username already exists
    public boolean adminExists(String username) {
        for (String line : FileUtil.readFromFile(file)) {
            String[] parts = line.split(",");
            if (parts.length > 0 && parts[0].equalsIgnoreCase(username)) return true;
        }
        return false;
    }

    // LOGIN — returns Admin object if credentials match, null if not
    public Admin login(String username, String password) {
        for (String line : FileUtil.readFromFile(file)) {
            String[] parts = line.split(",");
            if (parts.length >= 3) {
                if (parts[0].equals(username) && parts[1].equals(password)) {
                    return new Admin(parts[0], parts[1], parts[2]);
                }
            }
        }
        return null; // login failed
    }

    // REGISTER — saves new admin account to file
    public String register(String username, String password, String role) {
        if (username == null || username.trim().isEmpty())
            return "error:Username cannot be empty";
        if (password == null || password.trim().length() < 3)
            return "error:Password must be at least 3 characters";
        if (adminExists(username))
            return "error:Username '" + username + "' already exists";

        // Uses Constructor 1 (full details)
        Admin newAdmin = new Admin(username.trim(), password.trim(), role);
        FileUtil.writeToFile(file, newAdmin.toString());
        return "success";
    }

    // Total account count
    public int getTotalAdmins() {
        return FileUtil.readFromFile(file).size();
    }
}