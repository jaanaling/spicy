import 'package:advertising_id/advertising_id.dart';
import 'package:application/routes/route_value.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startLoading(context);
  }

  Future<void> startLoading(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    await AdvertisingId.id(true);
    context.go(RouteValue.home.path);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
