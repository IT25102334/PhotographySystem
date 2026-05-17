package model;

public class Package extends BaseEntity {

    
    private String name;
    private double price;
    private String description;  
    private String imagePath;     


    public Package(String id, String name, double price, String description, String imagePath) {
        this.id          = id;
        this.name        = name;
        this.price       = price;
        this.description = (description == null || description.trim().isEmpty())
                ? "No description provided" : description.trim();
        this.imagePath   = (imagePath == null || imagePath.trim().isEmpty())
                ? "images/packages/default.jpg" : imagePath.trim();
    }

   
    public Package(String id, String name, double price, String description) {
        this(id, name, price, description, "images/packages/default.jpg");
    }

   
    public Package(String id, String name, double price) {
        this(id, name, price, "No description provided", "images/packages/default.jpg");
    }

    
    public Package(String id, String name) {
        this(id, name, 0.0, "No description provided", "images/packages/default.jpg");
    }

    public String getName()        { return name; }
    public double getPrice()       { return price; }
    public String getDescription() { return description; }
    public String getImagePath()   { return imagePath; }

    public void setName(String name) {
        if (name == null || name.trim().isEmpty())
            throw new IllegalArgumentException("Package name cannot be empty");
        this.name = name.trim();
    }

    public void setPrice(double price) {
        if (price < 0)
            throw new IllegalArgumentException("Price cannot be negative");
        this.price = price;
    }

    public void setDescription(String description) {
        this.description = (description == null || description.trim().isEmpty())
                ? "No description provided" : description.trim();
    }

    public void setImagePath(String imagePath) {
        this.imagePath = (imagePath == null || imagePath.trim().isEmpty())
                ? "images/packages/default.jpg" : imagePath.trim();
    }


 
    public static String generateId(int currentCount) {
        return String.format("PKG-%03d", currentCount + 1);
    }

  
    @Override
    public String toString() {
        String safeDesc  = description.replace(",", ";");
        String safeImage = imagePath.replace(",", ";");
        return id + "," + name + "," + price + "," + safeDesc + "," + safeImage;
    }
}
