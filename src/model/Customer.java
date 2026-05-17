package model;

public class Customer extends User {

    private String email;

    public Customer(String id, String name, String email) {
        super(id, name);
        this.email = email;
    }

    public String getEmail() {
        return email;
    }

    @Override
    public String toString() {
        return getId() + "," + name + "," + email;
    }
}