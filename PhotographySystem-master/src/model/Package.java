package model;


    public class Package {
        String id, name;
        double price;

        public Package(String id, String name, double price) {
            this.id = id;
            this.name = name;
            this.price = price;
        }

        public String toString() {
            return id + "," + name + "," + price;
        }
    }

