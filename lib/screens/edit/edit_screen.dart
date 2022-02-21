import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dedaldev/config/config.dart';
import 'package:dedaldev/models/vehicle.dart';

class VehicleScreen extends StatefulWidget {
  static const String routeName = '/add';

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => const VehicleScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }

  final Vehicle? vehicle;
  const VehicleScreen({Key? key, this.vehicle}) : super(key: key);

  @override
  State<VehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<VehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  late File _tmpAdded;
  late String _manufacturer;
  late String _model;
  late String _description;
  late String _vehicleType;
  late String _imagePath;

  @override
  void initState() {
    super.initState();
    _manufacturer = widget.vehicle?.manufacturer ?? '';
    _model = widget.vehicle?.model ?? '';
    _description = widget.vehicle?.description ?? '';
    _vehicleType = widget.vehicle?.vehicleType ?? '';
    _imagePath = widget.vehicle?.imagePath ?? 'assets/splash-logo.png';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        deleteFile(_tmpAdded);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
              deleteFile(_tmpAdded);
            },
          ),
          centerTitle: true,
          title: const Text('Add a new vehicle'),
          actions: [
            IconButton(
              onPressed: _deleteVehicle,
              icon: const Icon(Icons.delete_outline),
            ),
            IconButton(
              onPressed: _saveVehicle,
              icon: const Icon(Icons.save_alt),
            ),
          ],
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: SizedBox(
                height: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: ClipRRect(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.circular(100),
                        child: checkImage(_imagePath),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () =>
                            _addImageFromCamera(ImageSource.camera),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                      key: _formKey,
                      child: FormWidget(
                        manufacturer: _manufacturer,
                        model: _model,
                        description: _description,
                        vehicleType: _vehicleType,
                        imagePath: _imagePath,
                        changedManufacturer: (value) => _manufacturer = value,
                        changedModel: (value) => _model = value,
                        changedDescription: (value) => _description = value,
                        changedVehicleType: (value) => _vehicleType = value,
                        changedImagePath: (value) => _imagePath = value,
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  checkImage(String imagePath) {
    if (imagePath == 'assets/splash-logo.png') {
      return Image.asset(_imagePath);
    } else {
      return Image.file(
        File(_imagePath),
      );
    }
  }

  _saveVehicle() async {
    final bool isValid = _formKey.currentState!.validate();

    if (isValid) {
      final bool isUpdate = (widget.vehicle != null);

      if (isUpdate) {
        _updateVehicle();
      } else {
        _addvehicle();
      }
      Navigator.of(context).pop();
    }
  }

  _addvehicle() {
    final vehicle = Vehicle(
      id: DateTime.now().millisecondsSinceEpoch,
      manufacturer: _manufacturer.trim(),
      model: _model.trim(),
      description: _description.trim(),
      vehicleType: _vehicleType,
      imagePath: _imagePath,
    );

    Provider.of<VehicleProvider>(context, listen: false).add(vehicle);
  }

  _updateVehicle() {
    final vehicle = widget.vehicle!.copy(
      manufacturer: _manufacturer.trim(),
      model: _model.trim(),
      description: _description.trim(),
      vehicleType: _vehicleType,
      imagePath: _imagePath,
    );

    Provider.of<VehicleProvider>(context, listen: false).update(vehicle);
  }

  _deleteVehicle() async {
    if (widget.vehicle != null) {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Remove the vehicle'),
          content: const Text('Do you want to remove the selected vehicle?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'No');
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                context.read<VehicleProvider>().delete(widget.vehicle!.id);
                Navigator.pop(context, 'Yes');
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    }
  }

  _addImageFromCamera(ImageSource camera) async {
    try {
      File? imgFile = await pickImage(ImageSource.camera);

      if (imgFile == null) return;

      setState(() {
        _imagePath = imgFile.path;
        _tmpAdded = imgFile;
      });
    } catch (e) {
      throw Exception(e);
    }
  }
}

class FormWidget extends StatelessWidget {
  final String manufacturer;
  final String model;
  final String description;
  final String vehicleType;
  final String imagePath;

  final ValueChanged changedManufacturer;
  final ValueChanged changedModel;
  final ValueChanged changedDescription;
  final ValueChanged changedVehicleType;
  final ValueChanged changedImagePath;

  const FormWidget({
    Key? key,
    required this.manufacturer,
    required this.model,
    required this.description,
    required this.vehicleType,
    required this.imagePath,
    required this.changedManufacturer,
    required this.changedModel,
    required this.changedDescription,
    required this.changedVehicleType,
    required this.changedImagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTextFormField(
            value: manufacturer,
            changedValue: changedManufacturer,
            label: 'Enter manufacturer',
            hint: 'Ford, Fiat...',
            lines: 1),
        CustomTextFormField(
            value: model,
            changedValue: changedModel,
            label: 'Enter model',
            hint: 'Mustang, Punto...',
            lines: 1),
        CustomTextFormField(
            value: description,
            changedValue: changedDescription,
            label: 'Enter description',
            hint: 'Enter the description...',
            lines: 3),
        CustomDropDownFormField(
          value: vehicleType,
          selectedValue: changedVehicleType,
        ),
      ],
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final String value;
  final String label;
  final ValueChanged changedValue;
  final String hint;
  final int lines;

  const CustomTextFormField({
    Key? key,
    required this.value,
    required this.changedValue,
    required this.hint,
    required this.lines,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        maxLines: lines,
        initialValue: value,
        decoration: InputDecoration(
          label: Text(label),
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onChanged: changedValue,
        textInputAction: TextInputAction.next,
      ),
    );
  }
}

class CustomDropDownFormField extends StatelessWidget {
  final String value;
  final ValueChanged selectedValue;
  const CustomDropDownFormField(
      {Key? key, required this.value, required this.selectedValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          label: const Text('Pick vehicles fuel type'),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        items: <String>['Gasoline', 'Electric', 'Hybrid', 'None']
            .map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: selectedValue,
      ),
    );
  }
}
