import 'package:cass_customer/api/car_api.dart';
import 'package:cass_customer/model/car.dart';
import 'package:cass_customer/model/customer.dart';
import 'package:cass_customer/utils/dialog_utils.dart';
import 'package:cass_customer/view/add_car_page.dart';
import 'package:cass_customer/view/car_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class CarPage extends StatefulWidget {
  @override
  _CarPageState createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  List<Car>? _cars;
  bool _isLoading = false;

  void _fetchCars() async {
    setState(() => _isLoading = true);
    final response = await CarAPI.fetch(Customer.instance!);
    response.isSuccess
        ? setState(() => _cars = response.data)
        : DialogUtils.show(context, response.message!);
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    _fetchCars();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade100,
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: _isLoading || _cars == null
            ? Container()
            : ListView.builder(
                itemCount: _cars!.length,
                itemBuilder: (context, index) {
                  final car = _cars![index];
                  return Card(
                    elevation: 12,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.directions_car,
                        color: Colors.indigo,
                        size: 48,
                      ),
                      title: Text(
                        car.plateNo!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        car.carModel!.name!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        size: 36,
                      ),
                      onTap: () => Navigator.of(context).push<bool>(
                        MaterialPageRoute(builder: (_) => CarDetailPage(car)),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "fab_car_page",
        onPressed: () async {
          final isAdded = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => AddCarPage()),
          );
          if (isAdded == true) _fetchCars();
        },
        child: Icon(Icons.add),
        tooltip: "Add Car",
      ),
    );
  }
}
