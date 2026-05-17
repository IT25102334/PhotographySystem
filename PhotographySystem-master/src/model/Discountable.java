package model;


/**
 * Discountable — Interface (INTERFACE)
 * Any service that handles pricing discounts must implement this.
 * Demonstrates: Interface, Abstraction, Polymorphism
 */
public interface Discountable {
    double applyDiscount(double price);
    boolean hasDiscount(double price);
    double getDiscountedPrice(double price);
}
