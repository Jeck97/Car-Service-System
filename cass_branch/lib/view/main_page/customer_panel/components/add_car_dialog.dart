import 'package:cass_branch/api/car_api.dart';
import 'package:cass_branch/model/car.dart';
import 'package:cass_branch/model/car_brand.dart';
import 'package:cass_branch/model/car_model.dart';
import 'package:cass_branch/model/customer.dart';
import 'package:cass_branch/utils/constants.dart';
import 'package:cass_branch/utils/dialog_utils.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddCarDialog extends StatefulWidget {
  final Customer _customer;
  AddCarDialog(this._customer);
  @override
  _AddCarDialogState createState() => _AddCarDialogState();
}

class _AddCarDialogState extends State<AddCarDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _plateNoController = TextEditingController();
  bool _isLoading = false;
  List<CarBrand> _carBrands = [];
  List<CarModel> _carModels = [];
  List<CarModel> _filteredCarModels = [];
  CarBrand _selectedBrand;
  CarModel _selectedModel;

  void _fetchCarBrands() async {
    setState(() => _isLoading = true);
    final response = await CarAPI.fetchBrands();
    setState(() {
      response.isSuccess
          ? _carBrands = response.data
          : DialogUtils.show(context, response.message);
      _isLoading = false;
    });
  }

  void _fetchCarModels() async {
    setState(() => _isLoading = true);
    final response = await CarAPI.fetchModels();
    setState(() {
      response.isSuccess
          ? _carModels = response.data
          : DialogUtils.show(context, response.message);
      _isLoading = false;
    });
  }

  void _onBrandSelected(CarBrand carBrand) {
    setState(() {
      if (_selectedBrand == null || _selectedBrand.id != carBrand.id) {
        _selectedBrand = carBrand;
        _selectedModel = null;
        _filteredCarModels = _carModels
            .where((model) => model.carBrand.id == carBrand.id)
            .toList();
      }
    });
  }

  void _onModelSelected(CarModel carModel) =>
      setState(() => _selectedModel = carModel);

  void _onAdd() async {
    final currentState = _formKey.currentState;
    if (!currentState.validate()) return;
    currentState.save();
    setState(() => _isLoading = true);
    final response = await CarAPI.add(
      Car(
        plateNo: _plateNoController.text
            .toUpperCase()
            .replaceAll(new RegExp(r"\s+"), ""),
        carModel: _selectedModel,
        customer: widget._customer,
        dateToService: DateTime.now(),
        dateFromService: DateTime.now(),
      ),
    );
    if (response.isSuccess) _onDismiss();
    DialogUtils.show(context, response.message);
    setState(() => _isLoading = false);
  }

  void _onDismiss() => Navigator.of(context).pop();

  @override
  void initState() {
    _fetchCarBrands();
    _fetchCarModels();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: AlertDialog(
        contentPadding: PADDING32,
        actionsPadding: PADDING24,
        title: DialogTitle('Add New Car'),
        content: _AddCarDialogContent(
          formKey: _formKey,
          plateNoController: _plateNoController,
          carBrands: _carBrands,
          carModels: _filteredCarModels,
          selectedBrand: _selectedBrand,
          selectedModel: _selectedModel,
          onBrandSelected: _onBrandSelected,
          onModelSelected: _onModelSelected,
        ),
        actions: [
          DialogAction(label: 'CANCEL', onPressed: _onDismiss),
          DialogAction(label: 'ADD', onPressed: _onAdd),
        ],
      ),
    );
  }
}

class _AddCarDialogContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController plateNoController;
  final List<CarBrand> carBrands;
  final List<CarModel> carModels;
  final CarBrand selectedBrand;
  final CarModel selectedModel;
  final void Function(CarBrand carBrand) onBrandSelected;
  final void Function(CarModel carModel) onModelSelected;

  _AddCarDialogContent({
    @required this.formKey,
    @required this.plateNoController,
    @required this.carBrands,
    @required this.carModels,
    @required this.selectedBrand,
    @required this.selectedModel,
    @required this.onBrandSelected,
    @required this.onModelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 300,
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _nameFormField(),
            _brandDropdown(),
            _modelDropdown(),
          ],
        ),
      ),
    );
  }

  Widget _nameFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.characters,
      decoration: InputDecoration(
        labelText: 'Plate Number *',
        helperText: 'Example: ABC1234',
      ),
      controller: plateNoController,
      validator: (plateNo) =>
          plateNo.trim().isEmpty ? 'Plate number is required' : null,
    );
  }

  Widget _brandDropdown() {
    return DropdownSearch<CarBrand>(
      mode: Mode.DIALOG,
      showSearchBox: true,
      label: 'Brand',
      hint: 'Please select the brand of car',
      selectedItem: selectedBrand,
      items: carBrands,
      itemAsString: (brand) => brand.name,
      filterFn: (carBrand, filter) =>
          carBrand.name.toLowerCase().contains(filter.toLowerCase()),
      onChanged: onBrandSelected,
      validator: (carBrand) => carBrand == null ? 'Brand is required' : null,
    );
  }

  Widget _modelDropdown() {
    return DropdownSearch<CarModel>(
      enabled: selectedBrand != null,
      mode: Mode.DIALOG,
      showSearchBox: true,
      label: 'Model',
      hint: 'Please select the model of car',
      selectedItem: selectedModel,
      items: carModels,
      itemAsString: (brand) => brand.name,
      filterFn: (carBrand, filter) =>
          carBrand.name.toLowerCase().contains(filter.toLowerCase()),
      onChanged: onModelSelected,
      validator: (carBrand) => carBrand == null ? 'Model is required' : null,
    );
  }
}
