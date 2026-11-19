import 'package:material_ui/material_ui.dart';

import '../../../core/routing/app_sections.dart';
import '../../../core/widgets/section_detail_scaffold.dart';

/// Quran reader. Gated until a verified, immutable edition exists (P00-07 → P01-01).
class MushafScreen extends StatelessWidget {
  const MushafScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const SectionDetailScaffold(section: AppSection.mushaf);
}
