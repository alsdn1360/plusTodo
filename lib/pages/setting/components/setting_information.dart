import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:plus_todo/themes/custom_decoration.dart';
import 'package:plus_todo/themes/custom_font.dart';
import 'package:plus_todo/widgets/custom_divider.dart';

class SettingInformation extends StatefulWidget {
  const SettingInformation({super.key});

  @override
  State<SettingInformation> createState() => _SettingInformationState();
}

class _SettingInformationState extends State<SettingInformation> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPaddingS),
      width: double.infinity,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(defaultBorderRadiusM),
        border: Border.all(color: gray.withOpacity(0.2), width: 0.3),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '앱 버전',
                  style: CustomTextStyle.title3,
                ),
              ),
              const Gap(defaultGapXL),
              Text(
                _packageInfo.version,
                style: CustomTextStyle.body1.copyWith(color: gray),
              ),
            ],
          ),
          const Gap(defaultGapS),
          const CustomDivider(),
          const Gap(defaultGapS),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '빌드 넘버',
                  style: CustomTextStyle.title3,
                ),
              ),
              const Gap(defaultGapXL),
              Text(
                _packageInfo.buildNumber,
                style: CustomTextStyle.body1.copyWith(color: gray),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() => _packageInfo = info);
  }
}
