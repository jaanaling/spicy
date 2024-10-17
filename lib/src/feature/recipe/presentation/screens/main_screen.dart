import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:application/src/feature/recipe/bloc/recipe_bloc.dart';
import 'package:application/src/feature/recipe/presentation/widgets/recipe_card.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipeBloc()..add(LoadRecipes()),
      child: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          if (state is RecipeLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.separated(
                    itemCount: state.recipes.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (BuildContext context, int index) =>
                        const Gap(16),
                    itemBuilder: (BuildContext context, int index) {
                      final recipe = state.recipes[index];
                      return GestureDetector(
                        onTap: () {},
                        child: RecipeCard(
                          recipe: recipe,
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CupertinoActivityIndicator());
          }
        },
      ),
    );
  }
}
