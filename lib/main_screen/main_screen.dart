import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stone_crusher_machine/machine_detail_screen/machine_detail_screen.dart';
import 'package:stone_crusher_machine/main_screen/components/machine_card.dart';

import 'components/custom_bottom_sheet.dart';

class MainScreen extends StatefulWidget {
  static String routeName = "MainScreen";

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  final Stream<QuerySnapshot> _machineCollectionStream =
      FirebaseFirestore.instance.collection('machines').snapshots();

  var box;

  @override
  void initState() {
    super.initState();
    openHiveDB();
  }

  void _logout() {
    setState(() {
      auth.signOut();
      Navigator.of(context).pushReplacementNamed('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 110,
        centerTitle: true,
        // elevation: 0,
        title: const Text(
          'Stone Crushing Machine',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
            stream: _machineCollectionStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Text("Loading"));
              }

              return Column(children: [
                SizedBox(
                  height: 10,
                ),
                ...snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return MachineCard(
                      machineId: data['machineID'],
                      machineName: data['machineName'],
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(
                            MachineDetailsScreen.routeName);
                      });
                }).toList(),
              ]);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showTransactionModalSheet(context);
        },
      ),
    );
  }

  //Show Bottom Sheet~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  void _showTransactionModalSheet(BuildContext ctx) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: CustomBottomSheet(),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  Future<void> openHiveDB() async {
    box = await Hive.openBox('loginCredentials');
  }

  void showProgress() {
    EasyLoading.show(
      status: 'Loading...',
      indicator: CircularProgressIndicator(),
      dismissOnTap: false,
      maskType: EasyLoadingMaskType.black,
    );
  }
}
