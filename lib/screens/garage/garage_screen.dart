import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dedaldev/config/config.dart';
import 'package:dedaldev/screens/screens.dart';
import 'package:dedaldev/widgets/widgets.dart';

class GarageScreen extends StatefulWidget {
  const GarageScreen({Key? key}) : super(key: key);

  @override
  State<GarageScreen> createState() => _GarageScreenState();
}

class _GarageScreenState extends State<GarageScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Garage'),
      ),
      body: RefreshIndicator(
        onRefresh: () => refreshOrGetData(context),
        child: Consumer<VehicleProvider>(
          builder: (context, vehicleProvider, child) =>
              vehicleProvider.items.isNotEmpty
                  ? VehicleListView(vehicles: vehicleProvider.items)
                  : child!,
          child: const Center(
            child: Text('No vehicles to display..'),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
        onPressed: () => {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const VehicleScreen(),
            ),
          ),
        },
      ),
    );
  }
}
