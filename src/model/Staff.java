package model;

public class Staff extends User {

    private String role;

    public Staff(String id, String name, String role) {
        super(id, name);
        this.role = role;
    }

    public String getRole() {
        return role;
    }

    @Override
    public String toString() {
        return getId() + "," + name + "," + role;
    }
}