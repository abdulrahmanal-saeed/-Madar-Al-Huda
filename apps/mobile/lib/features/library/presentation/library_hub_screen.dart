import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/routing/app_sections.dart';
import '../../../core/widgets/hub_scaffold.dart';

/// Islamic Library tab root.
class LibraryHubScreen extends StatelessWidget {
  const LibraryHubScreen({super.key});

  static const List<AppSection> sections = [
    AppSection.hadith,
    AppSection.fiqh,
    AppSection.articles,
  ];

  @override
  Widget build(BuildContext context) => HubScaffold(
    title: context.l10n.navLibrary,
    intro: context.l10n.libraryHubIntro,
    sections: sections,
  );
}
