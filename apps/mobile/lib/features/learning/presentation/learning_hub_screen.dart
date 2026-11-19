import 'package:material_ui/material_ui.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/routing/app_sections.dart';
import '../../../core/widgets/hub_scaffold.dart';

/// Learning tab root.
class LearningHubScreen extends StatelessWidget {
  const LearningHubScreen({super.key});

  static const List<AppSection> sections = [
    AppSection.lessons,
    AppSection.stories,
  ];

  @override
  Widget build(BuildContext context) => HubScaffold(
    title: context.l10n.navLearning,
    intro: context.l10n.learningHubIntro,
    sections: sections,
  );
}
