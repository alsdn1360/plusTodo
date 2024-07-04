import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/pages/home/components/home_matrix.dart';
import 'package:plus_todo/pages/home/components/home_summary.dart';
import 'package:plus_todo/provider/todo/todo_uncompleted_provider.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoData = ref.watch(todoUncompletedProvider);

    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '+',
                style: CustomTextStyle.header1.copyWith(
                  fontFamily: 'Prentendard',
                  fontFeatures: [const FontFeature.superscripts()],
                ),
              ),
              TextSpan(
                text: 'Todo',
                style: CustomTextStyle.header1,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPaddingM),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                HomeMatrix(todoData: todoData),
                const Gap(defaultGapL),
                HomeSummary(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
