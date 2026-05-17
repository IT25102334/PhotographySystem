package service;

import util.FileUtil;
import model.Customer;

public class CustomerService {

    private String file;

    public CustomerService(String file) {
        this.file = file;
    }

    public boolean isValidEmail(String email) {
        return email != null && email.contains("@") && email.contains(".");
    }

    public boolean customerExists(String id) {
        for (String line : FileUtil.readFromFile(file)) {
            if (line.startsWith(id + ",")) return true;
        }
        return false;
    }

    // Returns error message or null if OK
    public String addCustomer(Customer c) {
        if (customerExists(c.getId())) {
            return "Customer ID " + c.getId() + " already exists!";
        }
        if (!isValidEmail(c.getEmail())) {
            return "Invalid email address: " + c.getEmail();
        }
        FileUtil.writeToFile(file, c.toString());
        return null; // null = success
    }

    public void deleteCustomer(String id) {
        FileUtil.deleteFromFile(file, id);
    }

    public String findCustomer(String id) {
        for (String line : FileUtil.readFromFile(file)) {
            if (line.startsWith(id + ",")) return line;
        }
        return null;
    }
}