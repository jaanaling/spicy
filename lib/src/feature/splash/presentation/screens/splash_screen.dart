import 'package:advertising_id/advertising_id.dart';
import 'package:application/routes/route_value.dart';
import 'package:application/src/ui_kit/app_icon/widget/app_icon.dart';
import 'package:core_logic/core_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:application/src/core/utils/icon_provider.dart';
import 'package:loading_indicator/loading_indicator.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => InitializationCubit()..initialize(),
  child: BlocListener<InitializationCubit, InitializationState>(
    listener: (context, state) {
      if (state is InitializedState) {
        context.go(state.startRoute);
      }
    },
        child: Stack(
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
        ),
      ),
    );
  }
}
