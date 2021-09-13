import 'package:cass_customer/api/car_api.dart';
import 'package:cass_customer/model/car.dart';
import 'package:cass_customer/model/car_brand.dart';
import 'package:cass_customer/model/car_model.dart';
import 'package:cass_customer/model/customer.dart';
import 'package:cass_customer/utils/dialog_utils.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class AddCarPage extends StatefulWidget {
  @override
  State<AddCarPage> createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  final _formKey = GlobalKey<FormState>();
  final _plateNoController = TextEditingController();
  CarModel? _carModel;
  CarBrand? _carBrand;
  bool _isLoading = false;

  void _onAdd() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final response = await CarAPI.add(
      Car(
        plateNo: _plateNoController.text
            .toUpperCase()
            .replaceAll(new RegExp(r"\s+"), ""),
        carModel: _carModel,
        customer: Customer.instance,
      ),
    );
    if (response.isSuccess) {
      Navigator.of(context).pop<bool>(true);
      DialogUtils.show(context, "Car had added successful.");
    } else
      DialogUtils.show(context, response.message!);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade100,
      appBar: AppBar(title: Text("Add Car")),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.characters,
                    controller: _plateNoController,
                    decoration: InputDecoration(
                      labelText: "PLATE NUMBER",
                      hintText: "Enter your car plate number...",
                      border: OutlineInputBorder(),
                    ),
                    validator: (p) => p == null || p.trim().isEmpty
                        ? 'Plate number is required'
                        : null,
                  ),
                  SizedBox(height: 24),
                  DropdownSearch<CarBrand>(
                    showSearchBox: true,
                    mode: Mode.DIALOG,
                    label: "BRAND",
                    hint: "-- Select Brand --",
                    itemAsString: (b) => b.name!,
                    validator: (b) => b == null ? "Brand is required" : null,
                    onChanged: (b) => setState(() {
                      _carBrand = b;
                      _carModel = null;
                    }),
                    filterFn: (b, f) =>
                        b.name!.toLowerCase().contains(f.toLowerCase()),
                    onFind: (_) async =>
                        (await CarAPI.fetchBrands()).data ?? [],
                  ),
                  SizedBox(height: 24),
                  DropdownSearch<CarModel>(
                    enabled: _carBrand != null,
                    showSearchBox: true,
                    mode: Mode.DIALOG,
                    label: "MODEL",
                    hint: "-- Select Model --",
                    itemAsString: (m) => m.name!,
                    validator: (m) => m == null ? "Model is required" : null,
                    onChanged: (m) => setState(() => _carModel = m),
                    filterFn: (m, f) =>
                        m.name!.toLowerCase().contains(f.toLowerCase()),
                    onFind: (_) async =>
                        (await CarAPI.fetchModels(_carBrand!)).data ?? [],
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: Text(
                        "ADD",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    onPressed: _onAdd,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
