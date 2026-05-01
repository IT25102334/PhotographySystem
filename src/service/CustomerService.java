package service;

import model.Customer;

import java.io.*;
import java.util.ArrayList;

public class CustomerService {

    private final String FILE_NAME = "customers.txt";

    // Add Customer
    public void addCustomer(Customer customer) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_NAME, true))) {
            writer.write(customer.toString());
            writer.newLine();
            System.out.println("Customer added successfully.");
        } catch (IOException e) {
            System.out.println("Error saving customer.");
        }
    }

    // Display All Customers
    public void displayAllCustomers() {
        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_NAME))) {

            String line;

            while ((line = reader.readLine()) != null) {
                String[] data = line.split(",");
                System.out.println("ID: " + data[0] +
                        ", Name: " + data[1] +
                        ", Email: " + data[2]);
            }

        } catch (IOException e) {
            System.out.println("No customer records found.");
        }
    }

    // Search
    public Customer searchCustomerById(String id) {
        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_NAME))) {

            String line;

            while ((line = reader.readLine()) != null) {

                String[] data = line.split(",");

                if (data[0].equals(id)) {
                    return new Customer(data[0], data[1], data[2]);
                }
            }

        } catch (IOException e) {
            System.out.println("Error reading file.");
        }

        return null;
    }

    // Update
    public boolean updateCustomer(String id, String newName, String newEmail) {

        ArrayList<Customer> list = loadCustomers();
        boolean found = false;

        for (Customer c : list) {
            if (c.getId().equals(id)) {
                c.setName(newName);
                c.setEmail(newEmail);
                found = true;
            }
        }

        saveAll(list);
        return found;
    }

    // Delete
    public boolean deleteCustomer(String id) {

        ArrayList<Customer> list = loadCustomers();
        boolean found = false;

        for (int i = 0; i < list.size(); i++) {
            if (list.get(i).getId().equals(id)) {
                list.remove(i);
                found = true;
                break;
            }
        }

        saveAll(list);
        return found;
    }

    // Load all customers
    private ArrayList<Customer> loadCustomers() {

        ArrayList<Customer> list = new ArrayList<>();

        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_NAME))) {

            String line;

            while ((line = reader.readLine()) != null) {
                String[] data = line.split(",");
                list.add(new Customer(data[0], data[1], data[2]));
            }

        } catch (IOException e) {
        }

        return list;
    }

    // Save all again
    private void saveAll(ArrayList<Customer> list) {

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_NAME))) {

            for (Customer c : list) {
                writer.write(c.toString());
                writer.newLine();
            }

        } catch (IOException e) {
            System.out.println("Error saving file.");
        }
    }
}