package model;


/**
 * BaseEntity — Abstract base class (INHERITANCE)
 * All entities in the system extend this class.
 * Demonstrates: Inheritance, Abstraction
 */
public abstract class BaseEntity {

    protected String id;

    // Getter
    public String getId() { return id; }

    // Setter with validation (ENCAPSULATION)
    public void setId(String id) {
        if (id == null || id.trim().isEmpty())
            throw new IllegalArgumentException("ID cannot be empty");
        this.id = id;
    }

    // Forces every subclass to implement toString (ABSTRACTION)
    @Override
    public abstract String toString();
}
