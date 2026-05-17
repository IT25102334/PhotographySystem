package model;

public class User {


    protected String name;
    private String id;

    public String getId() {
        return id;
    }

    public User(String id, String name) {
        this.id = id;
        this.name = name;
    }
}
