import 'package:flutter/material.dart';
import 'package:food_delivery/views/customer/detail.dart';
import 'package:food_delivery/widget/widget_item_menu.dart';
import 'package:food_delivery/widget/widget_support.dart';
import 'package:food_delivery/widget/widget_theme_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool noodles = false, drink = false, rice = false, ramen = false, tea = true;
  _selectedFood(name) {
    if (name == "noodles") {
      noodles = true;
      drink = false;
      rice = false;
      ramen = false;
      tea = false;
    } else if (name == "drink") {
      noodles = false;
      drink = true;
      rice = false;
      ramen = false;
      tea = false;
    } else if (name == "fried-rice") {
      noodles = false;
      drink = false;
      rice = true;
      ramen = false;
      tea = false;
    } else if (name == "ramen") {
      noodles = false;
      drink = false;
      rice = false;
      ramen = true;
      tea = false;
    } else {
      noodles = false;
      drink = false;
      rice = false;
      ramen = false;
      tea = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ThemeWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hello Grace",
                  style: AppWidget.boldStyle(),
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            const SizedBox(height: 15.0),
            Text(
              "Delicous Food",
              style: AppWidget.headerlineStyle(),
            ),
            Text(
              "Discover and Get Greate Food",
              style: AppWidget.lightTextStyle(),
            ),
            const SizedBox(height: 15.0),
            showItem(),
            const SizedBox(height: 20),
            SizedBox(
              height: 1.0,
              child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 234, 234, 234)),
              ),
            ),
            const SizedBox(height: 8),
            FoodItem(),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const DetailFood()))
              },
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      Image.asset("images/com-ga.jpg",
                          width: 110, height: 110, fit: BoxFit.cover),
                      const SizedBox(width: 10),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Mâm cơm thập cẩm",
                              style: AppWidget.titleTextStyle(),
                            ),
                            Text(
                              "Gỏi, cơm, gà xé",
                              style: AppWidget.descriptionTextStyle(),
                            )
                          ])
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget showItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ItemMenu("noodles", noodles, _selectedFood, setState),
        ItemMenu("fried-rice", rice, _selectedFood, setState),
        ItemMenu("ramen", ramen, _selectedFood, setState),
        ItemMenu("drink", drink, _selectedFood, setState),
        ItemMenu("bubble-tea", tea, _selectedFood, setState)
      ],
    );
  }

  Widget FoodItem() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(
              right: 10,
              top: 10,
              bottom: 10,
              left: 2,
            ),
            child: Material(
              elevation: 3.0,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                margin: const EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "images/com-ga.jpg",
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      const Text(
                        "Chicken Rice",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        "Full and healthy",
                        style: AppWidget.descriptionTextStyle(),
                      ),
                      const Text(
                        "30K",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800),
                      )
                    ]),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
              margin: const EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "images/met-ga.jpeg",
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      "Chicken Rice",
                      style: AppWidget.titleTextStyle(),
                    ),
                    Text(
                      "Full and healthy",
                      style: AppWidget.descriptionTextStyle(),
                    ),
                    const Text(
                      "230K",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    )
                  ]),
            ),
          ),
          const SizedBox(width: 15),
          Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
              margin: const EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "images/chicken-rice.webp",
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      "Chicken Rice",
                      style: AppWidget.titleTextStyle(),
                    ),
                    const Text(
                      "Full and healthy",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    const Text(
                      "230K",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    )
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
