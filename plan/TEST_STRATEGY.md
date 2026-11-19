# Test Strategy & Quality Gates

| Level | Test scope | Evidence |
|---|---|---|
| Static | formatter, analyzer, lint, secret checks | GitHub CI |
| Unit | prayer time, Qibla geometry, indexing, hash, bookmarks | Test logs |
| Widget | Arabic RTL, English LTR, font scaling, night mode | Widget tests |
| Integration | Quran → bookmark → reopen, audio background, CMS publish/withdraw | Verified runs |
| Religious data | verse integrity, cited hadith/fiqh, translations, rights | Reviewer log + checksums |
| Security | RLS, separation of users/admin, no frontend secrets | Security report |
| Devices | Android permissions, location, compass, audio, battery | Device matrix |
| Release | AAB, upgrade preservation, privacy statement | Release checklist |

## Critical checks
- القرآن النص الأصلي ثابت؛ يمكن معالجة نسخة مشتقة للبحث فقط، ولا تغير التخزين المرجعي.
- مصدر القرآن يحدد الإصدار والعد والبصمة، وتُقارن جميع الآيات آليًا.
- الصلاة تختبر دبي وأبوظبي والقاهرة والإسكندرية بنفس معاملات الحساب والمناطق الزمنية المرجعية.
- أخطاء GPS أو غياب حساس البوصلة تظهر للمستخدم بوضوح مع خيار إدخال مدينة يدويًا.
- Android قد يؤخر إشعارات غير دقيقة أو يقيّد التنبيهات الدقيقة؛ اختبر الأذونات ووضع البطارية ولا تعد بمواعيد مضمونة في كل ظرف.
- كل حديث له مصدر وحكم بدرجته إذا كانت معروضة، وكل مسألة فقهية لها مراجع ومراجعة ومؤشر تغطية.
- لا يحتفظ backend بموقع المستخدم الجغرافي بشكل مستمر بلا حاجة.
- عند كل PR: اختبارات وتغييرات وثائق وقائمة مخاطر. هدف تغطية المنطق الأساسي 80% مش بديل عن اختبار الميزات الحقيقية.

**Gate قبل Production:** صفر أعطال حرجة/عالية مفتوحة، صفر أخطاء قرآنية معروفة، صفر مواد منشورة غير مرخصة، مراجعة بشرية مكتملة للمحتوى الشرعي المطلوب.
