import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:plus_todo/functions/general_format_time.dart';
import 'package:plus_todo/models/todo.dart';
import 'package:plus_todo/providers/todo/todo_uncompleted_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';
import 'package:plus_todo/widgets/custom_divider.dart';

class HomeSummaryCount extends ConsumerWidget {
  final String title;
  final Color color;
  final bool Function(Todo) filteredTodoData;

  const HomeSummaryCount({
    super.key,
    required this.title,
    required this.color,
    required this.filteredTodoData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uncompletedTodoData = ref.watch(todoUncompletedProvider).where(filteredTodoData).toList();

    return Flexible(
      flex: 1,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              elevation: 1,
              backgroundColor: white,
              surfaceTintColor: white,
              alignment: Alignment.center,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(defaultBorderRadiusL),
              ),
              insetAnimationCurve: Curves.easeOutQuad,
              insetAnimationDuration: const Duration(milliseconds: 200),
              insetPadding: const EdgeInsets.symmetric(horizontal: defaultPaddingM * 2),
              child: Container(
                padding: const EdgeInsets.all(defaultPaddingL),
                width: double.infinity,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: CustomTextStyle.title3.copyWith(color: color),
                        ),
                        const Gap(defaultGapS),
                        const CustomDivider(),
                        const Gap(defaultGapS),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) => const Gap(defaultGapS),
                          itemCount: uncompletedTodoData.length,
                          itemBuilder: (context, index) {
                            final todoList = uncompletedTodoData[index];
                            final isDeadlineSoon =
                                todoList.deadline != null && todoList.deadline!.isBefore(DateTime.now());

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  todoList.title,
                                  style: CustomTextStyle.body3,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(GeneralFormatTime.formatDate(todoList.deadline!),
                                        style: isDeadlineSoon
                                            ? CustomTextStyle.caption1.copyWith(color: red)
                                            : CustomTextStyle.caption1),
                                    const Gap(defaultGapS),
                                    Visibility(
                                      visible: isDeadlineSoon,
                                      child: Text(
                                        '미뤄진 일',
                                        style: CustomTextStyle.caption1.copyWith(color: red),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                        if (uncompletedTodoData.isEmpty)
                          Text(
                            '할 일이 없어요.',
                            style: CustomTextStyle.caption1,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AutoSizeText(
              title,
              style: CustomTextStyle.body1.copyWith(color: color),
              maxLines: 1,
              maxFontSize: 40,
              softWrap: true,
            ),
            const Gap(defaultGapS / 2),
            Text('${uncompletedTodoData.length}', style: CustomTextStyle.body2),
          ],
        ),
      ),
    );
  }
}
