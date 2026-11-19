import 'package:material_ui/material_ui.dart';

import '../../../core/routing/app_sections.dart';
import '../../../core/widgets/section_detail_scaffold.dart';

/// Qibla direction. Sensor/geometry work is P01-08.
class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const SectionDetailScaffold(section: AppSection.qibla);
}
