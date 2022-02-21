import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dedaldev/models/vehicle.dart';

class VehicleListItem extends StatelessWidget {
  final Vehicle vehicle;
  final int index;

  const VehicleListItem({Key? key, required this.vehicle, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      width: 350,
      child: Stack(
        children: [
          Positioned(
            bottom: 5,
            right: !(index.isOdd) ? 20 : 0,
            left: !(index.isOdd) ? 0 : 20,
            child: Container(
              width: 350,
              height: 65,
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(8)),
            ),
          ),
          if (index.isOdd)
            Positioned(
              left: 90,
              bottom: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(vehicle.manufacturer,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0,
                      )),
                  Text(
                    vehicle.model,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            )
          else
            Positioned(
              bottom: 20,
              right: 90,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(vehicle.manufacturer,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0,
                        )),
                    Text(vehicle.model,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0,
                        )),
                  ]),
            ),
          if (index.isOdd)
            Positioned(
              right: 30,
              top: 20,
              child: SizedBox(
                height: 92,
                width: 152,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(100),
                    child: Image.file(File(vehicle.imagePath)),
                  ),
                ),
              ),
            )
          else
            Positioned(
              left: 30,
              top: 20,
              child: SizedBox(
                height: 92,
                width: 152,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(100),
                    child: Image.file(File(vehicle.imagePath)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
