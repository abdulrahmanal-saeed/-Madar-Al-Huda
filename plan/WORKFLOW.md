# Workflow: GitHub + AI_BRIDGE

**المصدر الوحيد للتقدم:** [TRACKER.md](TRACKER.md).

1. اختر مهمة ID من Phase الحالي وتحقق من إن تبعياتها `DONE`.
2. أنشئ Issue يحتوي المطلوب ومعايير قبول واختبارات وتبعيات. المهمة `P00-06` مربوطة بالفعل بـ [Issue #2](https://github.com/abdulrahmanal-saeed/madar-al-huda/issues/2).
3. نفذ في فرع `phase-NN/task-id-short-title` وPR صغيرة، ولا تنشر أسرارًا أو نصوصًا محمية.
4. دوّن الملفات المتغيرة والاختبارات **التي أُجريت فعلًا** في `AI_BRIDGE/IMPLEMENTATION.md`.
5. راجع PR تقنيًا (وشرعيًا ولغويًا لأي محتوى ديني) مع ملاحظات `AI_BRIDGE/REVIEW.md`.
6. مرّر CI والفحوص اللازمة ثم ادمج بعد معالجة الموانع.
7. غير صف المهمة إلى `DONE` في TRACKER واربط PR/commit والدليل. لا تغيّرها لمجرد رفع كود بلا اختبارات.
8. عند إغلاق مرحلة، وثق تقرير إنجاز بوابة Exit Gate ومخاطر متبقية.

## Status states
`TODO`, `IN_PROGRESS`, `BLOCKED`, `REVIEW`, `DONE`, `DEFERRED`, `CANCELLED`.

## Definition of Done
القائمة التفصيلية القابلة للتحقق: **[DEFINITION_OF_DONE.md](DEFINITION_OF_DONE.md)**، وقائمة الاختبار اليدوي [../docs/QA_CHECKLIST.md](../docs/QA_CHECKLIST.md)، وقالب PR في `.github/pull_request_template.md`.

ملخص: متطلبات قبول محققة، اختبارات حقيقية، مراجعة، دمج، وتحديث tracker. وبالنسبة للنصوص الدينية **موافقة المصدر/حقوقه + المراجعة البشرية المؤهلة إلزامية**؛ نجاح البرمجة وحده لا يكفي.
