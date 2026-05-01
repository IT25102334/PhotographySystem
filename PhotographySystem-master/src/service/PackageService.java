package service;
import util.FileUtil;
import model.Package;
    public class PackageService {
        String file = "data/packages.txt";

        public void addPackage(Package p) {
            FileUtil.writeToFile(file, p.toString());
        }
    }

