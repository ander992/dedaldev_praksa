import 'package:flutter/material.dart';

import 'package:dedaldev/models/vehicle.dart';
import 'package:dedaldev/config/config.dart';
import 'package:dedaldev/screens/screens.dart';
import 'vehicle_list_item.dart';

class VehicleListView extends StatelessWidget {
  final List<Vehicle> vehicles;
  final BuildContext? scaffoldContext;
  const VehicleListView(
      {Key? key, required this.vehicles, this.scaffoldContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: vehicles.length,
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, index) => _listItem(context, index),
    );
  }

  Widget _listItem(BuildContext context, int index) {
    final currentVehicle = vehicles[index];

    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VehicleScreen(
              vehicle: currentVehicle,
            ),
          ),
        );
        refreshOrGetData(scaffoldContext!);
      },
      child: VehicleListItem(vehicle: currentVehicle, index: index),
    );
  }
}
