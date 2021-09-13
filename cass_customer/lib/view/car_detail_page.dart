import 'package:cass_customer/model/car.dart';
import 'package:flutter/material.dart';

class CarDetailPage extends StatelessWidget {
  final Car car;

  CarDetailPage(this.car);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade100,
      appBar: AppBar(
        title: Text("Car Detail"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.delete_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.pin_rounded),
            title: Text(car.plateNo!),
            horizontalTitleGap: 0,
          ),
          ListTile(
            leading: Icon(Icons.directions_car_rounded),
            title: Text(car.carModel!.name!),
            horizontalTitleGap: 0,
          ),
        ],
      ),
    );
  }
}
