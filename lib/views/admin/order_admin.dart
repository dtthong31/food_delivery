import 'package:flutter/material.dart';
import 'package:food_delivery/models/order_model.dart';

class OrderAdminScreen extends StatefulWidget {
  @override
  _OrderAdminScreenState createState() => _OrderAdminScreenState();
}

class _OrderAdminScreenState extends State<OrderAdminScreen> {
  List<Order> orders = [
    Order(
      id: "ORD001",
      customerName: "John Doe",
      orderTime: DateTime.now().subtract(const Duration(hours: 2)),
      status: "Received",
      items: [
        OrderItem(name: "Pizza", quantity: 2, price: 10.99),
        OrderItem(name: "Gà Quay", quantity: 2, price: 10.99),
        OrderItem(name: "Lẩu cá tằm", quantity: 2, price: 10.99),
        OrderItem(name: "Ốc Hương hấp", quantity: 2, price: 10.99),
        OrderItem(name: "Càng ghẹ rang muối", quantity: 2, price: 10.99),
        OrderItem(name: "Chân gà xả tắc", quantity: 2, price: 10.99),
        OrderItem(name: "Burger", quantity: 1, price: 5.99)
      ],
      deliveryAddress: "123 Main St, City",
    ),
    Order(
      id: "ORD002",
      customerName: "Hong Doan",
      orderTime: DateTime.now().subtract(const Duration(hours: 2)),
      status: "Processing",
      items: [OrderItem(name: "Cơm tấm", quantity: 2, price: 30.99)],
      deliveryAddress: "19 Tân cảng, Bình Thạnh, TP.HCM",
    ),
  ];

  String filterStatus = "All";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order List'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              setState(() {
                filterStatus = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'All',
                child: Text('Tất cả đơn'),
              ),
              const PopupMenuItem<String>(
                value: 'Received',
                child: Text('Nhận đơn'),
              ),
              const PopupMenuItem<String>(
                value: 'Processing',
                child: Text('Đang chuẩn bị'),
              ),
              const PopupMenuItem<String>(
                value: 'Preparing',
                child: Text('Đang giao hàng'),
              ),
              const PopupMenuItem<String>(
                value: 'Completed',
                child: Text('Đã giao thành công'),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: orders
            .where((order) =>
                filterStatus == 'All' || order.status == filterStatus)
            .length,
        itemBuilder: (context, index) {
          final order = orders
              .where((order) =>
                  filterStatus == 'All' || order.status == filterStatus)
              .toList()[index];
          return _buildOrderCard(order);
        },
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text(
          'Order ${order.id}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.customerName,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Text(
              '${order.orderTime.toString().substring(0, 16)}',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            ),
            _buildStatusChip(order.status),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: () => _showOrderDetails(order),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Received':
        color = Colors.blue;
        break;
      case 'Processing':
        color = Colors.orange;
        break;
      case 'Preparing':
        color = Colors.yellow;
        break;
      case 'Completed':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }
    return Chip(
      label: Text(status, style: TextStyle(color: Colors.white)),
      backgroundColor: color,
    );
  }

  void _showOrderDetails(Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Customer: ${order.customerName}'),
              Text('Address: ${order.deliveryAddress}'),
              const Divider(),
              ...order.items.map((item) => Text(
                  '${item.name} x${item.quantity} - \$${item.price * item.quantity}')),
              Divider(),
              Text('Total: \$${order.total.toStringAsFixed(2)}'),
              const SizedBox(height: 20),
              DropdownButton<String>(
                value: order.status,
                items: ['Received', 'Processing', 'Preparing', 'Completed']
                    .map((status) =>
                        DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                onChanged: (newStatus) {
                  setState(() {
                    order.status = newStatus!;
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
