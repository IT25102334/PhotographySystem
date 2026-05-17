package service;

import util.FileUtil;
import model.Package;
import model.Discountable;
import java.util.List;

public class PackageService implements Discountable {

    private String file;

    public PackageService(String file) {
        this.file = file;
    }


    public boolean packageExists(String id) {
        for (String line : FileUtil.readFromFile(file)) {
            if (line.startsWith(id + ",")) return true;
        }
        return false;
    }

    public String addPackage(Package p) {
        if (packageExists(p.getId()))
            return "error:Package ID " + p.getId() + " already exists!";
        if (p.getPrice() <= 0)
            return "error:Price must be greater than 0!";
        FileUtil.writeToFile(file, p.toString());
        return "success";
    }

    public void deletePackage(String id) {
        FileUtil.deleteFromFile(file, id);
    }

    // Update: remove old line, write new (ENCAPSULATION of file logic)
    public String updatePackage(String originalId, Package updated) {
        if (!originalId.equals(updated.getId()) && packageExists(updated.getId()))
            return "error:Package ID " + updated.getId() + " already exists!";
        if (updated.getPrice() <= 0)
            return "error:Price must be greater than 0!";
        FileUtil.deleteFromFile(file, originalId);
        FileUtil.writeToFile(file, updated.toString());
        return "success";
    }

   
    public String findPackage(String id) {
        for (String line : FileUtil.readFromFile(file)) {
            if (line.startsWith(id + ",")) return line;
        }
        return null;
    }

    
    public String findPackage(String keyword, boolean searchByName) {
        if (!searchByName) return findPackage(keyword);
        for (String line : FileUtil.readFromFile(file)) {
            String[] parts = line.split(",");
            if (parts.length > 1 && parts[1].toLowerCase().contains(keyword.toLowerCase()))
                return line;
        }
        return null;
    }

    @Override
    public double applyDiscount(double price) {
        if (price > 5000) return price * 0.85;
        return price;
    }

    @Override
    public double getDiscountedPrice(double price) {
        return Math.round(applyDiscount(price) * 100.0) / 100.0;
    }

    @Override
    public boolean hasDiscount(double price) {
        return price > 5000;
    }


    public int getTotalPackages() {
        return FileUtil.readFromFile(file).size();
    }

    public double getTotalPortfolioValue() {
        double total = 0;
        for (String line : FileUtil.readFromFile(file)) {
            String[] d = line.split(",");
            if (d.length > 2) {
                try { total += Double.parseDouble(d[2].trim()); } catch (Exception e) {}
            }
        }
        return Math.round(total * 100.0) / 100.0;
    }

    public int countDiscountedPackages() {
        int count = 0;
        for (String line : FileUtil.readFromFile(file)) {
            String[] d = line.split(",");
            if (d.length > 2) {
                try { if (hasDiscount(Double.parseDouble(d[2].trim()))) count++; } catch (Exception e) {}
            }
        }
        return count;
    }

    public String getMostExpensiveName() {
        String name = "-";
        double max  = -1;
        for (String line : FileUtil.readFromFile(file)) {
            String[] d = line.split(",");
            if (d.length > 2) {
                try {
                    double p = Double.parseDouble(d[2].trim());
                    if (p > max) { max = p; name = d.length > 1 ? d[1] : "-"; }
                } catch (Exception e) {}
            }
        }
        return name;
    }

    // Uses static method from Package class
    public String suggestNextId() {
        return Package.generateId(getTotalPackages());
    }
}
