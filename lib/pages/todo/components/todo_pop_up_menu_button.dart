import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plus_todo/providers/filtered/filtered_show_completed_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class TodoPopUpMenuButton extends ConsumerWidget {
  const TodoPopUpMenuButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
      elevation: 1,
      color: white,
      surfaceTintColor: white,
      icon: const Icon(Icons.more_vert_rounded, color: black),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadiusM),
      ),
      padding: const EdgeInsets.all(defaultPaddingS),
      onSelected: (value) => ref.read(filteredShowCompletedProvider.notifier).toggleFilteredShow(value),
      itemBuilder: (context) => <PopupMenuEntry>[
        PopupMenuItem(
          value: true,
          child: Text(
            '완료된 할 일 목록 보기',
            style: CustomTextStyle.body3,
          ),
        ),
        PopupMenuItem(
          value: false,
          child: Text(
            '완료된 할 일 목록 숨기기',
            style: CustomTextStyle.body3,
          ),
        ),
      ],
    );
  }
}
