package model;

public class Staff {
    String id, name, role;

    public Staff(String id, String name, String role) {
        this.id = id;
        this.name = name;
        this.role = role;
    }

    public String toString() {
        return id + "," + name + "," + role;
    }
}