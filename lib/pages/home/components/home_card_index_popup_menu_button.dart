import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plus_todo/providers/filtered/filtered_home_card_provider.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';

class HomeCardIndexPopupMenuButton extends ConsumerWidget {
  const HomeCardIndexPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
      elevation: 1,
      color: white,
      surfaceTintColor: white,
      icon: const Icon(Icons.dashboard_customize_rounded, color: black),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadiusM),
      ),
      padding: const EdgeInsets.all(defaultPaddingS),
      onSelected: (value) => ref.read(filteredHomeCardIndexProvider.notifier).toggleFilteredHomeCardIndex(value),
      itemBuilder: (context) => <PopupMenuEntry>[
        PopupMenuItem(
          value: 0,
          child: Text(
            '오늘 해야 할 일 목록 보기',
            style: CustomTextStyle.body3,
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Text(
            'Do 목록 보기',
            style: CustomTextStyle.body3,
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Text(
            'Delegate 목록 보기',
            style: CustomTextStyle.body3,
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Text(
            'Schedule 목록 보기',
            style: CustomTextStyle.body3,
          ),
        ),
        PopupMenuItem(
          value: 4,
          child: Text(
            'Eliminate 목록 보기',
            style: CustomTextStyle.body3,
          ),
        ),
        PopupMenuItem(
          value: 5,
          child: Text(
            '목록 숨기기',
            style: CustomTextStyle.body3,
          ),
        ),
      ],
    );
  }
}
