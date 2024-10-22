import 'package:application/routes/route_value.dart';
import 'package:application/src/core/utils/icon_provider.dart';
import 'package:application/src/feature/challenge/bloc/challenge_bloc.dart';
import 'package:application/src/feature/recipe/bloc/recipe_bloc.dart';
import 'package:application/src/ui_kit/app_icon/widget/app_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 35, 16, 150),
      child: Column(
        children: [
          SizedBox(
            width: 270,
            child: Transform.translate(
              offset: const Offset(-40, 0),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Transform.flip(
                    flipX: true,
                    child: Container(
                      child: AppIcon(
                          height: 82,
                          asset: IconProvider.pepper.buildImageUrl()),
                    ),
                  ),
                  const Padding(
                      padding: EdgeInsets.only(left: 32),
                      child: Text(
                        'Spicy Challenges',
                        style: TextStyle(
                            fontSize: 31,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            height: 1.2),
                        textAlign: TextAlign.left,
                      ))
                ],
              ),
            ),
          ),
          const Gap(16),
          const Divider(
            color: Color(0xFF9A0A10),
            thickness: 3,
            height: 3,
          ),
          const Gap(16),
          BlocBuilder<ChallengeBloc, ChallengeState>(
            builder: (context, state) {
              return state is ChallengeLoaded
                  ? ListView.separated(
                      itemCount: state.challenges.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => const Gap(9),
                      itemBuilder: (context, index) => ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: AssetImage(
                                  state.challenges[index].imageUrl,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                
                                Positioned.fill(
                                  child: ColoredBox(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(13),
                                      child: Text(
                                        state.challenges[index].name,
                                        style: const TextStyle(
                                          fontSize: 25,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'poppins',
                                        ),
                                      ),
                                    )),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 13,
                                      vertical: 8,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        context.read<ChallengeBloc>().add(
                                            ShareChallengeEvent(
                                                state.challenges[index].name));
                                      },
                                      child: Icon(
                                        Icons.share,
                                        color: Colors.white,
                                        size: 38,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      context.push(
                                        '${RouteValue.challenge.path}/${RouteValue.recipe.path}',
                                        extra: (context.read<RecipeBloc>().state
                                                as RecipeLoaded)
                                            .recipes
                                            .firstWhere((element) =>
                                                element.name ==
                                                state.challenges[index].name),
                                      );
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        AppIcon(
                                         
                                            asset: IconProvider.bigb
                                                .buildImageUrl()),
                                        Text(
                                          'take on the challenge',
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : const CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}
