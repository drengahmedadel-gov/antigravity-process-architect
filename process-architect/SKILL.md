---
name: process-architect
description: "The Universal Visual Architecture & Workflow Engine for Google Antigravity: Create validated, boardroom-ready interactive visual diagrams for software architectures, microservices, cloud infrastructure, data pipelines, database ERDs, workflows, lifecycles, and business processes without writing code. Produces explorable standalone HTML with inline SVG, dark/light themes, live signal flow motion, and vector exports. Automatically provides a mandatory 3-pillar response: interactive controls guide, detailed architectural breakdown, and visual indicators matrix."
license: MIT
metadata:
  version: "1.0.0"
  author: "Dr. Eng. Ahmed Adel (Dr.PMO)"
  engine: "Archify Core by tt-a1i"
  adapted_for: "Google Antigravity"
---

# Process Architect for Google Antigravity

Create interactive standalone HTML diagrams from natural language, system descriptions, Mermaid code, or typed JSON.

## Antigravity Environment & CLI Location

The Process Architect engine is installed globally inside the Antigravity configuration:
- **Global Path:** `~/.gemini/config/skills/process-architect/`
- **CLI Binary:** `~/.gemini/config/skills/process-architect/bin/process-architect.mjs` (or `archify.mjs`)
- **Schemas:** `~/.gemini/config/skills/process-architect/schemas/`
- **Examples:** `~/.gemini/config/skills/process-architect/examples/`
- **References:** `~/.gemini/config/skills/process-architect/references/`

Run commands via `run_command` in PowerShell (Windows) or Bash (macOS/Linux):
```powershell
# Windows PowerShell (Universal Dynamic Resolution):
$skillDir = if (Test-Path "$HOME\.gemini\config\skills\process-architect") { "$HOME\.gemini\config\skills\process-architect" } else { (Get-Item "SKILL.md").Directory.FullName }
node "$skillDir\bin\process-architect.mjs" finalize <type> <candidate.json> <output.html> --quality showcase --json
```
```bash
# macOS / Linux (Bash):
SKILL_DIR="${HOME}/.gemini/config/skills/process-architect"
node "${SKILL_DIR}/bin/process-architect.mjs" finalize <type> <candidate.json> <output.html> --quality showcase --json
```

### Destination Folder Rules
- **In an active project workspace:** Give each new diagram request its own folder `.archify/<type>-<slug>-<YYYYMMDD-HHMMSS>/` (local time). Keep `candidate.json` and `<slug>.html` inside it.
- **In conversation/scratch mode (no active project):** Place the candidate and output HTML in the Antigravity conversation artifact directory:
  `<appDataDir>\brain\<conversation-id>\<slug>.html` or `scratch/`.
- **Clickable Links:** Always return a clickable markdown link formatted according to Antigravity rules:
  `[اسم المخطط / Descriptive Title](file:///C:/path/to/output.html)`

---

## Type Router

| Type | Use for | Schema | Example |
|---|---|---|---|
| `architecture` | Components, services, cloud/security boundaries, infrastructure, microservices | `schemas/architecture.schema.json` | `examples/web-app.architecture.json`, `examples/production-deployment.architecture.json` |
| `workflow` | Processes, approval gates, tool calls, runbooks, CI/CD, agent step-by-step executions | `schemas/workflow.schema.json` | `examples/agent-tool-call.workflow.json` |
| `sequence` | API call chains, request lifecycles, async traces, message exchanges between actors | `schemas/sequence.schema.json` | `examples/cache-miss-request.sequence.json` |
| `dataflow` | Pipelines, ETL/ELT, streaming lineage, governance, data consumers | `schemas/dataflow.schema.json` | `examples/product-analytics.dataflow.json` |
| `lifecycle` | State/status transitions, state machines, retries, waiting/terminal states | `schemas/lifecycle.schema.json` | `examples/deployment-release.lifecycle.json` |
| `erd` | Relational tables, attributes, primary/foreign/unique keys, cardinality | `schemas/erd.schema.json` | `examples/orders.erd.json` |
| `tree` | Single-parent containment: repository/module trees, feature breakdowns, org hierarchy | `schemas/tree.schema.json` | `examples/payment-platform.tree.json` |
| `class` | Classes, interfaces, selected members, inheritance/realization/composition | `schemas/class.schema.json` | `examples/payments.class.json` |
| `timeline` | Chronological events: incident reviews, release histories, timestamped lanes | `schemas/timeline.schema.json` | `examples/payment-incident.timeline.json` |
| `waterfall` | Latency breakdowns, execution spans, agent run timing breakdowns | `schemas/waterfall.schema.json` | `examples/checkout-request.waterfall.json` |

When ambiguous, run:
```powershell
node "$HOME\.gemini\config\skills\process-architect\bin\process-architect.mjs" guide "<scenario>" --json
```

---

## Mermaid Input Translation

Read Mermaid for topology and meaning, then author fresh Archify JSON:
- `flowchart` / `graph` → `workflow` (processes) or `architecture` (systems/components).
- `sequenceDiagram` → `sequence` (participants become semantic participants, arrows become messages).
- `stateDiagram` → `lifecycle` (states and transitions retain meaning).
- `erDiagram` → `erd` (entity and relationship names, keys, and cardinality).
- `classDiagram` → `class` (types, members, and relations).

---

## Bilingual (Arabic & English) Support

Archify supports full UTF-8 text in SVG and HTML viewer:
- Titles, node `label`, `sublabel`, boundary labels, connection labels, card `title`, and card `items` can all be written in Arabic, English, or a mix.
- Keep identifiers (`id`, `from`, `to`) in simple ASCII kebab-case (e.g. `api-gateway`, `user-db`).
- Set `meta.title` to the Arabic or English title of the diagram.

---

## Fast Authoring Path & Embedded Documentation

1. **Select Type**: Choose one of the 10 types from the user's prompt or diagram context.
2. **Read Schema & Example**: If unsure of the exact fields, inspect the corresponding schema and example in `examples/`.
3. **Write Candidate JSON with Embedded Documentation (`cards` & `tags`)**:
   - **إلزامية البطاقات التوضيحية (`cards`)**: يجب دائماً تضمين مصفوفة `cards` في ملف الـ JSON لشرح طبقات المخطط والمفاهيم المعمارية، بحيث يكون ملف الـ HTML المستقل موثقاً بذاته عند فتحه في أي متصفح.
   - **الوسوم والمؤشرات (`tags`)**: ضع وسوماً دالة على المكونات الهامة (مثل: `"OAuth 2.0"`, `"Cached"`, `"PK/FK"`).
   - Use automatic routes first (`fromSide`, `toSide` only when necessary).
   - Set `meta.quality_profile` to `"showcase"` (or `"standard"` for dense schemas).
   - For `boundaries`, only use allowed enum kinds (e.g. `"region"`, `"security-group"` for architecture).
4. **Compile & Finalize**: Run `finalize` via `run_command`:
   ```powershell
   node "$HOME\.gemini\config\skills\process-architect\bin\process-architect.mjs" finalize <type> <candidate.json> <output.html> --quality showcase --json
   ```
5. **Handle Diagnostics (Repair Loop)**:
   - If exit code is 0: all automated gates (`validate`, `deliver`, `check`, `browser-check`) passed!
   - If exit code is 1: inspect JSON output diagnostics. Apply `supportedFixes` or schema corrections directly using `replace_file_content` on `candidate.json`, then re-run `finalize`.
6. **Visual Capture (التقاط الصور المرئية)**:
   بمجرد نجاح `finalize`، قم دائماً بتشغيل أمر الفحص البصري لتوليد اللقطات عالية الدقة للوضعين النهاري والليلي:
   ```powershell
   node "$HOME\.gemini\config\skills\process-architect\bin\process-architect.mjs" visual-check <output.html> --json
   ```
   انسخ اللقطات إلى مجلد الأرتفاكتس للمحادثة `<appDataDir>\brain\<conversation-id>\`.

---

## البروتوكول الإلزامي لمخرجات المهارة (The Mandatory 3-Pillar Output Contract)

> [!IMPORTANT]
> **قاعدة صارمة وغير قابلة للتجاوز**: لكل مخرج ومخطط يتم إنشاؤه عبر هذه المهارة، **يجب** أن يحتوي الرد على الأركان الثلاثة التالية مفصلة بشكل كامل ومستقل لهذا المخطط تحديداً، ولا يجوز الاكتفاء برابط الملف أو ملخص عائم:

### 1. الركن الأول: طريقة الاستخدام والتفاعل (Interactive Controls & How-to-Use)
شرح دقيق لكيفية تفاعل المستخدم مع هذا المخطط الحي في المتصفح:
- ⚡ **التحكم بالتدفق والحركة (Flow / Still)**: كيفية تشغيل أو تجميد نبضات ومسارات الإشارات التفاعلية.
- 🔍 **التنقل والتكبير (Zoom & Pan)**: استخدام عجلة الماوس للتقريب وزر `100% Fit` لإعادة ضبط المشهد للمركز.
- 🎯 **عزل المسارات والوصولية (Reach & Route Tracing)**: النقر على أي عقدة (Node) لتسليط الضوء على اتصالاتها المباشرة وتعتيم باقي العناصر غير المرتبطة.
- 🌓 **المظهر (Theme)**: التبديل الفوري بين الوضع الليلي (Dark Mode) والنهاري (Light Mode).
- 💾 **التصدير (Export)**: خيارات حفظ المخطط بصيغة متجهات نقية `SVG`، صورة عالية الدقة `PNG`، أو فيديو متحرك `WebM`.

### 2. الركن الثاني: فهم المخرجات والتحليل المعماري (Output Understanding & Layer Breakdown)
تحليل معماري شامل وعميق يفكك محتوى المخطط:
- **تحليل الطبقات (Layer-by-Layer Analysis)**: شرح كل طبقة (Edge, Gateway, Logic, Storage, Security).
- **دور العقد الرئيسية (Key Nodes & Components)**: ما الذي يمثله كل عنصر في النظام وما هي مسؤوليته المحددة.
- **مسار تدفق البيانات والعمليات (Execution / Request Lifecycle)**: رحلة الطلب من لحظة البداية حتى الرد النهائي خطوة بخطوة.
- **القرارات الهندسية ونقاط الاعتمادية (Architectural Rationale & Trade-offs)**: لماذا تم تصميم النظام بهذه الطريقة (مثل التخزين المؤقت، بوابات الحوكمة، عزل الشبكات).

### 3. الركن الثالث: جدول المؤشرات والدلالات البصرية (Indicators, Colors, Lines & Badges Table)
جدول مرجعي دقيق يفسر جميع الدلالات والرموز البصرية الموجودة داخل المخطط:
- **دلالات الألوان للعقد (Color-Coded Nodes)**:
  - 🟦 `Cyan / Blue` (External / Gateway / Edge): نقاط الدخول الخارجية والشبكات.
  - 🟩 `Emerald / Green` (Core / Business Logic): خوادم التطبيقات والخدمات التنفيذية الناجحة.
  - 🟪 `Purple / Indigo` (Message Bus / Middleware): طوابير الرسائل واستدعاء الأدوات وأحداث الوسيط.
  - 🟨 `Amber / Yellow` (Data / Storage): قواعد البيانات ومخازن الذاكرة السريعة وملفات الحالة.
  - 🟥 `Rose / Red` (Security / Policy / Block): جدران الحماية، سياسات الأمان، والمحطات المرفوضة.
- **دلالات وأنماط الخطوط والمسارات (Line Variants & Edge Semantics)**:
  - **خط صلب عادي (Default)**: اتصال متزامن مباشر (Synchronous HTTP/TCP).
  - **خط عريض مميز (Emphasis)**: المسار السعيد الرئيسي للطلب (Happy Path).
  - **خط متقطع (Dashed)**: اتصال غير متزامن، تخزين مؤقت، أو استدعاءات فرعية في الخلفية.
  - **خط أمان أحمر/وردي (Security)**: تدفق مشفر أو فحص أمني وتفويض صلاحيات.
- **الشارات والوسوم (Badges & Tags)**: تفسير أي شارات فرعية ملحقة بالعقد (مثل `JWT`, `PK/FK`, `OAI protected`).

---

### الهيكل الإلزامي للرد النهائي لكل مخطط
```markdown
### [اسم المخطط التفاعلي]

````carousel
![المخطط - الوضع الليلي](file:///path/to/dark.png)
<!-- slide -->
![المخطط - الوضع النهاري](file:///path/to/light.png)
````

🔗 **رابط فتح المخطط التفاعلي:** [فتح المخطط في المتصفح](file:///path/to/diagram.html)

#### 1. 🛠️ طريقة الاستخدام والتفاعل (How to Use & Controls)
...

#### 2. 🧠 فهم المخرجات والتحليل المعماري (Output Understanding)
...

#### 3. 📊 جدول المؤشرات والدلالات البصرية (Indicators & Legends)
| العنصر البصري | النوع | الدلالة في هذا المخطط |
|---|---|---|
| ... | ... | ... |
```
