import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plus_todo/providers/filtered/filtered_show_list_or_card.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class TodoListOrCardPopupMenuButton extends ConsumerWidget {
  const TodoListOrCardPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
      elevation: 1,
      color: white,
      surfaceTintColor: white,
      icon: const Icon(Icons.more_vert_rounded, color: black),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadiusM),
        side: BorderSide(color: gray.withOpacity(0.2), width: 0.2),
      ),
      padding: const EdgeInsets.all(defaultPaddingS),
      onSelected: (value) => ref.read(filteredShowListOrCardProvider.notifier).toggleFilteredShowListOrCard(value),
      itemBuilder: (context) => <PopupMenuEntry>[
        PopupMenuItem(
          value: 0,
          child: Text(
            '모아서 보기',
            style: CustomTextStyle.body3,
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Text(
            '하나씩 보기',
            style: CustomTextStyle.body3,
          ),
        ),
      ],
    );
  }
}
