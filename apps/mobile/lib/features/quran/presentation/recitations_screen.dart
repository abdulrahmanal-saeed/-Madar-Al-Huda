import 'package:material_ui/material_ui.dart';

import '../../../core/routing/app_sections.dart';
import '../../../core/widgets/section_detail_scaffold.dart';

/// Recitation player. Gated until per-reciter streaming rights are confirmed (P00-07 → P01-06).
class RecitationsScreen extends StatelessWidget {
  const RecitationsScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const SectionDetailScaffold(section: AppSection.recitations);
}
