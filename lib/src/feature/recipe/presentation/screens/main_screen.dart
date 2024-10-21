import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:application/src/feature/recipe/bloc/recipe_bloc.dart';
import 'package:application/src/feature/recipe/presentation/widgets/recipe_card.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => RecipeBloc()..add(LoadRecipes()),
      child: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          if (state is RecipeLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: width * 0.67,
                    height: height * 0.4,
                    child: PageView.builder(
                      itemCount: state.recipes.length,
                      physics: const NeverScrollableScrollPhysics(),
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
