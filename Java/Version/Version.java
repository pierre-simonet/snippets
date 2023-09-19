package Java.Version;

public class Version {
    public static void main(String[] args) {
        Package aPackage = Version.class.getPackage();
        System.out.println("Version: " + aPackage.getImplementationVersion());
    }
}