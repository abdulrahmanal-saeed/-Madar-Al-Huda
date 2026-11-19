import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/routing/app_sections.dart';
import '../../../core/widgets/hub_scaffold.dart';

/// Quran tab root.
class QuranHubScreen extends StatelessWidget {
  const QuranHubScreen({super.key});

  static const List<AppSection> sections = [
    AppSection.mushaf,
    AppSection.recitations,
    AppSection.tafsir,
  ];

  @override
  Widget build(BuildContext context) => HubScaffold(
    title: context.l10n.navQuran,
    intro: context.l10n.quranHubIntro,
    sections: sections,
  );
}
