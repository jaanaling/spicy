import 'package:advertising_id/advertising_id.dart';
import 'package:application/routes/route_value.dart';
import 'package:application/src/ui_kit/app_icon/widget/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:application/src/core/utils/icon_provider.dart';
import 'package:loading_indicator/loading_indicator.dart';

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
    return Stack(
      children: [
        AppIcon(
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          asset: IconProvider.splash.buildImageUrl(),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon(asset: IconProvider.logo.buildImageUrl(), width: 164,),
              Gap(MediaQuery.of(context).size.height * 0.237),
              const SizedBox(
                width: 81,
                height: 81,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballSpinFadeLoader,
                  colors: [Colors.white],
                  strokeWidth: 5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
