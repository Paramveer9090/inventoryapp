import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/driver_order_detail_controller.dart';

class DriverOrderDetailView extends GetView<DriverOrderDetailController> {
  const DriverOrderDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DriverOrderDetailView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DriverOrderDetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
