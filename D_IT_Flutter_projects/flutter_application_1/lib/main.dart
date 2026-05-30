
class Product {
  String name;
  double price;

  Product(this.name, this.price);

  @override
  String toString() {
    return '$name (\$${price.toStringAsFixed(2)})';
  }
}

class ShoppingCart {
  List<Product> items = [];

  void addProduct(Product product) {
    items.add(product);
    print('Added ${product.name} to the shopping cart.');
  }

  double calculateTotal() {
    double total = 0;
    for (var item in items) {
      total += item.price;
    }
    return total;
  }

  void _printCart(String customerName) {
    print("$customerName's Shopping Cart:");
    for (var item in items) {
      print("- $item");
    }
  }

  void checkout(String customerName) {
    _printCart(customerName);
    print("Checking out...");
    double total = calculateTotal();
    print("Total amount: \$${total.toStringAsFixed(2)}");
    print("Payment successful. Order placed!");
  }
}

class Customer {
  String name;
  ShoppingCart shoppingCart;

  Customer(this.name) : shoppingCart = ShoppingCart();

  void addToCart(Product product) {
    shoppingCart.addProduct(product);
  }

  void checkout() {
    shoppingCart.checkout(name);
  }
}

void main() {
  Product laptop = Product("Laptop", 1200.00);
  Product mouse = Product("Mouse", 30.00);

  Customer customer = Customer("Michael");

  customer.addToCart(laptop);
  customer.addToCart(mouse);

  customer.checkout();

  print("\nExited.");
}
