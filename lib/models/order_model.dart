class Order {
  final String id;
  final String customerName;
  final DateTime orderTime;
  String status;
  final List<OrderItem> items;
  final String deliveryAddress;

  Order({
    required this.id,
    required this.customerName,
    required this.orderTime,
    required this.status,
    required this.items,
    required this.deliveryAddress,
  });

  double get total =>
      items.fold(0, (sum, item) => sum + item.price * item.quantity);
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({required this.name, required this.quantity, required this.price});
}
