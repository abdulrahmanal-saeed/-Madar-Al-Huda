# Plan Changelog

## 2026-11-19 — Merge reconciliation
- [PR #4](https://github.com/abdulrahmanal-saeed/madar-al-huda/pull/4), [PR #5](https://github.com/abdulrahmanal-saeed/madar-al-huda/pull/5) و[PR #6](https://github.com/abdulrahmanal-saeed/madar-al-huda/pull/6) دُمجت في main بناءً على طلب المالك، بعد مراجعة الفروقات ونتائج CI على رؤوس PRs.
- `P00-09` DONE (التوثيق وقواعد الجودة دُمجت). `P00-06` REVIEW لحين فحص جهاز/محاكي باللغتين وAccessibility/copy. `P00-11` REVIEW لحين تفعيل أسرار توقيع التطوير وتجربة prerelease وتحديث Obtainium.
- لا يُفهم دمج كود التطوير على أنه اكتمال بوابات Phase 00 أو ترخيص نصوص دينية.

## 2026-11-19 — P00-11 dev update channel
- مهمة جديدة `P00-11` بطلب المالك: workflow `dev-release.yml` ينشر APK تطوير موقّع بعد نجاح CI على `main`، والتحديث عبر Obtainium. Phase 00 أصبحت 11 مهمة (المجموع 59). قرار D-17.

## 2026-11-19 — P00-09 QA rules & Definition of Done
- `P00-09` → `REVIEW`: [DEFINITION_OF_DONE.md](DEFINITION_OF_DONE.md) (انتقالات الحالة، قوائم الإنجاز حسب نوع المهمة، بوابات CI الحالية، المراجعات والأدلة، الخطورة)، و`docs/QA_CHECKLIST.md`، و`.github/pull_request_template.md`. لا يضيف CI جديدًا.

## 2026-11-19 — P00-06 implementation
- `P00-06` → `REVIEW`: Flutter skeleton في `apps/mobile` مع AR/EN وRTL/LTR وخمس وجهات تنقل وشاشات أقسام محجوبة المحتوى، وثيمات فاتح/داكن، وتفضيلات محلية، و81 اختبارًا، وGitHub Actions CI.
- قرارات مقترحة جديدة D-12 إلى D-16 في [DECISIONS.md](DECISIONS.md).

## 2026-11-19 — v1.0
- إنشاء خطة شاملة لـ Phase 00 إلى Phase 06، تشمل جميع أقسام التطبيق.
- تتبع 58 مهمة بحالة وتبعيات وشروط قبول وروابط تنفيذ.
- ربط خطة التأسيس المدمجة في PR #1 بأول مهمة Flutter الموجودة في Issue #2.
- الحقوق العلمية والشرعية وحقوق الوسائط موانع فعلية للنشر وليست مفترضة.
- الوضع الأولي: Phase 00 IN_PROGRESS، ولم يُنفَّذ Flutter app بعد.
