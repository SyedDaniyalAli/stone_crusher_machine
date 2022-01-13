import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MachineCard extends StatelessWidget {
  final String machineId;
  final String machineName;
  final GestureTapCallback onPressed;

  const MachineCard(
      {Key? key,
      required this.machineId,
      required this.machineName,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0, right: 14.0),
      child: Card(
        color: Colors.yellow.shade500,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(35.0),
            child: Column(
              children: [
                Icon(
                  FontAwesomeIcons.cashRegister,
                  size: 80,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Machine ID: $machineId',
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Machine Name: $machineName',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
