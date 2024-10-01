import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FoodItem {
  String id;
  String name;
  String description;
  double price;
  String imageUrl;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  factory FoodItem.fromDocument(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return FoodItem(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}

class FoodManagementScreen extends StatefulWidget {
  @override
  _FoodManagementScreenState createState() => _FoodManagementScreenState();
}

class _FoodManagementScreenState extends State<FoodManagementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Management'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('food_admin').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<FoodItem> foodItems = snapshot.data!.docs
              .map((doc) => FoodItem.fromDocument(doc))
              .toList();

          return GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: foodItems.length,
            itemBuilder: (context, index) {
              return _buildFoodCard(foodItems[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditFoodDialog(null),
        child: Icon(Icons.add),
        tooltip: 'Add new dish',
      ),
    );
  }

  Widget _buildFoodCard(FoodItem food) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: food.imageUrl.isNotEmpty
                ? Image.network(
                    food.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading image: $error');
                      return _buildPlaceholderImage();
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(child: CircularProgressIndicator());
                    },
                  )
                : _buildPlaceholderImage(),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('\$${food.price.toStringAsFixed(2)}'),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _showAddEditFoodDialog(food),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _deleteFood(food),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[300],
      child: Icon(
        Icons.restaurant,
        size: 50,
        color: Colors.grey[600],
      ),
    );
  }

  void _showAddEditFoodDialog(FoodItem? food) {
    final isEditing = food != null;
    final nameController = TextEditingController(text: food?.name ?? '');
    final descriptionController =
        TextEditingController(text: food?.description ?? '');
    final priceController =
        TextEditingController(text: food?.price.toString() ?? '');
    File? imageFile;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Dish' : 'Add New Dish'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Food Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final picker = ImagePicker();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    imageFile = File(pickedFile.path);
                  }
                },
                child: Text('Upload Image'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text;
              final description = descriptionController.text;
              final price = double.tryParse(priceController.text) ?? 0.0;

              if (name.isNotEmpty && price > 0) {
                String imageUrl = food?.imageUrl ?? '';
                if (imageFile != null) {
                  imageUrl = await _uploadImage(imageFile!);
                }

                final foodData = FoodItem(
                  id: food?.id ?? '',
                  name: name,
                  description: description,
                  price: price,
                  imageUrl: imageUrl,
                );

                if (isEditing) {
                  await _updateFood(foodData);
                } else {
                  await _addFood(foodData);
                }

                Navigator.of(context).pop();
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<String> _uploadImage(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef = _storage.ref().child('food_images/$fileName');
    UploadTask uploadTask = storageRef.putFile(imageFile);
    await uploadTask;
    return await storageRef.getDownloadURL();
  }

  Future<void> _addFood(FoodItem food) async {
    await _firestore.collection('food_admin').add(food.toMap());
  }

  Future<void> _updateFood(FoodItem food) async {
    await _firestore.collection('food_admin').doc(food.id).update(food.toMap());
  }

  Future<void> _deleteFood(FoodItem food) async {
    await _firestore.collection('food_admin').doc(food.id).delete();
    // Optionally, delete the image from storage as well
    if (food.imageUrl.isNotEmpty) {
      await _storage.refFromURL(food.imageUrl).delete();
    }
  }
}
