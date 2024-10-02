import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery/models/food_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FoodManagementScreen extends StatefulWidget {
  @override
  _FoodManagementScreenState createState() => _FoodManagementScreenState();
}

class _FoodManagementScreenState extends State<FoodManagementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

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
            child: PageView.builder(
              itemCount: food.imageUrls.isNotEmpty ? food.imageUrls.length : 1,
              itemBuilder: (context, index) {
                if (food.imageUrls.isNotEmpty) {
                  return Image.network(
                    food.imageUrls[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading image: $error');
                      return _buildPlaceholderImage();
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(child: CircularProgressIndicator());
                    },
                  );
                } else {
                  return _buildPlaceholderImage();
                }
              },
            ),
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
    List<File> newImageFiles = [];
    List<String> currentImageUrls = food?.imageUrls ?? [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isEditing ? 'Edit Dish' : 'Add New Dish'),
              content: SizedBox(
                // Use SizedBox or ConstrainedBox to give the content a defined height
                width: double.maxFinite, // Ensure the dialog is not too wide
                child: SingleChildScrollView(
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
                      Text('Images:'),
                      Container(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ...currentImageUrls.map((url) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    children: [
                                      Image.network(url,
                                          height: 80,
                                          width: 80,
                                          fit: BoxFit.cover),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: IconButton(
                                          icon: Icon(Icons.close,
                                              color: Colors.red),
                                          onPressed: () {
                                            setState(() {
                                              currentImageUrls.remove(url);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            ...newImageFiles.map((file) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    children: [
                                      Image.file(file,
                                          height: 80,
                                          width: 80,
                                          fit: BoxFit.cover),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: IconButton(
                                          icon: Icon(Icons.close,
                                              color: Colors.red),
                                          onPressed: () {
                                            setState(() {
                                              newImageFiles.remove(file);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            IconButton(
                              icon: Icon(Icons.add_photo_alternate),
                              onPressed: () async {
                                final List<XFile>? pickedFiles =
                                    await _picker.pickMultiImage();
                                if (pickedFiles != null) {
                                  setState(() {
                                    newImageFiles.addAll(pickedFiles
                                        .map((xFile) => File(xFile.path)));
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                      List<String> updatedImageUrls = [...currentImageUrls];
                      for (var file in newImageFiles) {
                        String? imageUrl = await _uploadImage(file);
                        if (imageUrl != null && imageUrl.isNotEmpty) {
                          updatedImageUrls.add(imageUrl);
                        }
                      }

                      final foodData = FoodItem(
                        id: food?.id ?? '',
                        name: name,
                        description: description,
                        price: price,
                        imageUrls: updatedImageUrls,
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
            );
          },
        );
      },
    );
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = _storage.ref().child('food_images/$fileName');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      if (Uri.parse(downloadUrl).isAbsolute) {
        return downloadUrl;
      } else {
        throw Exception('Invalid URL generated');
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _addFood(FoodItem food) async {
    await _firestore.collection('food_admin').add(food.toMap());
  }

  Future<void> _updateFood(FoodItem food) async {
    await _firestore.collection('food_admin').doc(food.id).update(food.toMap());
  }

  Future<void> _deleteFood(FoodItem food) async {
    await _firestore.collection('food_admin').doc(food.id).delete();
    // Delete all associated images from storage
    for (String imageUrl in food.imageUrls) {
      try {
        await _storage.refFromURL(imageUrl).delete();
      } catch (e) {
        print('Error deleting image: $e');
      }
    }
  }
}
