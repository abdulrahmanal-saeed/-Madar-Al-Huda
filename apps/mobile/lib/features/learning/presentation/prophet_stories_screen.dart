import 'package:material_ui/material_ui.dart';

import '../../../core/routing/app_sections.dart';
import '../../../core/widgets/section_detail_scaffold.dart';

/// Stories of the prophets. Requires scholarly review (P04-04).
class ProphetStoriesScreen extends StatelessWidget {
  const ProphetStoriesScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const SectionDetailScaffold(section: AppSection.stories);
}
