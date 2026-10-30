# DayFit 商店优化方案（基于 App Store Connect 后台真实数据）

> 数据来源：本文所有"现状"均取自你的 App Store Connect 后台（浏览器实际读取），不是公开页面推测。
> 生成时间：2026-10-30 · App ID 6826873520 · 版本 1.0

---

## 〇、先说时机（最重要）

**App 今天刚上架**（releaseDate: 2026-10-30 07:00 UTC，即北京时间今天 15:00，到写本文时不到 10 小时）。当前 **0 评分、0 评论**。

这意味着两件事：

1. **现在改元数据成本最低**——没有用户会被打扰，关键词权重清零重来毫无损失。等下载量起来后再改标题/关键词，每次都要重洗一次排名。
2. **Apple 新品期约 7 天的自然流量扶持正在生效**，这 7 天里的关键词覆盖面和转化素材，直接决定扶持期过后能留住多少自然流量。

**建议：本文 P0 项今天就在后台改掉（全部是纯文本编辑，不需要发新版本）。**

---

## 一、对我上一版方案的修正（重要）

上一版我是从公开页面推断的，有两处判断错误，进了后台核实后必须更正：

| 我上次说的 | 后台核实结果 | 结论 |
|---|---|---|
| 删掉「iPhone Duo」，怀疑设备不存在 | **iPhone Duo 是 Apple 2026 年 9 月发布的折叠屏 iPhone，10 月 23 日刚开售**。Apple 自己的后台都写着"为 iPhone Duo 上传预览和截屏" | ❌ 不能删，反而是**当前最大差异化卖点**（Duo 刚开售一周，适配的 App 极少） |
| 「372 种组合」改成 366 | 后台审核备注写得很清楚：**12 个月 × 31 日 = 372 种月-日组合全部跑过求解器**。372 是对的，是组合数不是天数 | ❌ 不用改 |
| 「十二种语言」要加限定词 | 后台确认**正好 12 个语种本地化**（简中/繁中/英/日/韩/德/法/西/意/葡/俄/阿） | ❌ 描述准确，不用改 |

**所以：描述（Description）本身不需要动。** 它写的都是对的。而且按 2026 年算法，**描述不参与搜索排名**（Apple 官方明确），它只影响转化——你的描述转化文案写得已经不错。

---

## 二、后台现状全景（12 语种实测）

### 2.1 字符利用率——大量预算被浪费

| 语种 | 名称 (上限30) | 副标题 (上限30) | 关键词 (上限100) | 推广文本 (上限170) |
|---|---|---|---|---|
| 简体中文 | 16 ⚠ | **9** 🔴 | **44** 🔴 | 48 |
| 繁体中文 | 16 ⚠ | **9** 🔴 | **44** 🔴 | 48 |
| 英语（美国）| 30 ✅ | 26 ⚠ | **95** ⚠ | 146 |
| 日语 | 17 ⚠ | **11** 🔴 | **44** 🔴 | 64 |
| 韩语 | 15 ⚠ | **15** 🔴 | **38** 🔴 | 72 |
| 德语 | 23 ⚠ | 22 ⚠ | **75** ⚠ | 151 |
| 法语 | 29 ✅ | 20 ⚠ | 71 ⚠ | 152 |
| 西班牙语 | 29 ✅ | 19 ⚠ | 72 ⚠ | 155 |
| 意大利语 | 30 ✅ | 21 ⚠ | 73 ⚠ | 159 |
| 葡萄牙语（巴西）| 29 ✅ | 18 ⚠ | 70 ⚠ | 149 |
| 俄语 | 24 ⚠ | 25 ⚠ | 64 ⚠ | 153 |
| 阿拉伯语 | 22 ⚠ | 20 ⚠ | 63 ⚠ | 120 |

**权重排序（Apple 官方）：名称 > 副标题 > 关键词 > 类别。** 推广文本和描述不参与排名。
中韩日三个亚洲语种的副标题+关键词全部只用了不到一半——**这是最大的免费流量漏洞**。

### 2.2 关键词字段的具体问题（逐条核实）

- **简中/繁中**：`游戏` 是类别词（Apple 官方明确"类别已索引，不要重复"）；`每日` 与名称"一日一拼"语义重复；缺 `华容道`（中文区拼图类头部搜索词）、`买断`（付费无内购产品的核心搜索意图）、`孔明棋`、`数独`（相邻受众）等
- **英语**：`wifi` 是**负向词**——搜 wifi 的人要的是联网工具，点进来发现离线产品，拉低搜索转化率反而伤排名；`relax/calm/unwind` 三个近义词占 3 个坑位；缺 `wood/block/zen/focus`
- **韩语**：`게임`（游戏）类别词重复
- **法/西/意/葡/俄/阿**：关键词里含空格短语（`hors ligne`、`un jugador` 等），空格吃字符且 Apple 本来就会逐词拆分组合

---

## 三、优化方案 A：关键词字段（⚠️ 实测更正：需随新版本提交，不能即时改）

> **2026-10-31 实测更正**：1.0 已上架（状态"可分发"），版本页与 App 信息页的关键词、副标题、名称字段**全部 disabled**。App 信息页顶部原文：「要更改 App 名称、类别或隐私政策，请创建新的 App 版本」。
> 所以本节 A/B/C 三套文案**必须随下一个版本（上传新二进制）一起提交**才生效。文案已全部校验完毕，到时直接粘贴即可。
> 上架状态下**唯一可即时编辑**的文本字段是**推广文本**（版本页有独立「编辑」按钮）。

**原则（Apple 官方 + 2026 算法实践）**：与名称/副标题/类别零重复；逗号分隔无空格；单数；填满 100 字符；每个词都是用户真实会搜的。

以下全部经过字符数校验，**可直接整段粘贴**：

**简体中文（72→可再补，见下）**
```
七巧板,五连方,华容道,孔明棋,数独,木质,木制,益智,烧脑,解压,买断,单机,离线,通勤,睡前,地铁,休闲,专注,逻辑,木块,打发时间,无广告
```

**繁体中文（72）**
```
七巧板,五連方,華容道,孔明棋,數獨,木質,木製,益智,燒腦,解壓,買斷,單機,離線,通勤,睡前,地鐵,休閒,專注,邏輯,木塊,打發時間,無廣告
```

**英语（98/100）** — 删掉了 wifi/unwind，补上 wood/block/zen/focus
```
pentomino,tangram,brain,teaser,logic,relax,offline,commute,calm,wood,block,zen,focus,evening,train
```

**日语（69）**
```
ペントミノ,木製,脳トレ,ロジック,スキマ時間,オフライン,一人,通勤,暇つぶし,リラックス,集中,木のブロック,寝る前,電車,無料ヒント
```

**韩语（55）** — 删掉 게임
```
펜토미노,나무,두뇌,논리,힐링,오프라인,혼자,출퇴근,커피,지하철,집중,명상,심심할때,자기전,나무블록
```

**德语（99/100）**
```
Pentomino,Denksport,Knobeln,Logik,entspannen,offline,Rätsel,Feierabend,Holzspiel,Gehirn,Bahn,abends
```

**法语（97/100）**
```
pentomino,bois,logique,détente,horsligne,solo,réflexion,cerveau,calme,soir,train,ennui,pièces,zen
```

**西班牙语（91/100）**
```
pentomino,madera,lógica,relajante,sinconexión,solo,pausa,agilidad,cerebro,calma,tren,piezas
```

**意大利语（97/100）**
```
pentomino,legno,logica,rilassante,offline,solo,pausa,ingegno,cervello,calma,sera,treno,noia,pezzi
```

**葡萄牙语（95/100）**
```
pentomino,madeira,lógica,relaxante,offline,solo,pausa,raciocínio,cérebro,calma,noite,trem,tédio
```

**俄语（100/100，刚好满）**
```
пентамино,дерево,логика,офлайн,расслабиться,одному,кофе,мозг,поезд,вечер,скука,тренажер,покой,фигуры
```

**阿拉伯语（73）**
```
بنتومينو,خشب,منطق,استرخاء,عقل,هدوء,قهوة,قطع,تفكير,مساء,سفر,ملل,ذكاء,تركيز
```

> **唯一即时生效的文本字段是推广文本**（版本页有独立「编辑」按钮，改完即时上线）。关键词/副标题/名称**必须随 v1.0.1 新版本提交**。
> 见第十节「v1.0.1 提交包」——把 A+B+C 三套文案合并进一个版本一次性提交，避免多次审核往返。

---

## 四、优化方案 B：副标题（同样需随新版本提交）

现状 12 个语种副标题全部有空余，中韩日尤其严重（9-15 字符）。副标题权重仅次于名称，空着就是白扔。

原则：**副标题不重复名称里的词**，用来补充"木质/离线/无广告/时长"这类名称没覆盖的高意图词。

| 语种 | 现状 | 建议改为（已校验 ≤30） |
|---|---|---|
| 简体中文 | 每天拼出一张木日历 (9) | `八块木头，两分钟一局，离线无广告` (16) |
| 繁体中文 | 每天拼出一張木日曆 (9) | `八塊木頭，兩分鐘一局，離線無廣告` (16) |
| 英语 | 8 wooden pieces, 2 minutes (26) | `8 wooden blocks. 2 minutes.` (27) — "block puzzle" 搜索量高于 "piece" |
| 日语 | 木のピースで今日を描く (11) | `木のピース8枚、2分。オフライン` (16) |
| 韩语 | 나무 조각으로 오늘을 맞추다 (15) | `나무 조각 8개, 딱 2분. 오프라인` (20) |
| 德语 | Täglich acht Holzteile (22) | `8 Teile, 2 Minuten, offline` (27) |
| 法语 | Huit pièces, un jour (20) | `Huit pièces de bois, 2 min` (26) |
| 西班牙语 | Ocho piezas, un día (19) | `Ocho piezas de madera, 2 min` (28) |
| 意大利语 | Otto pezzi, un giorno (21) | `Otto pezzi di legno, 2 min` (26) |
| 葡萄牙语 | Oito peças, um dia (18) | `Oito peças de madeira, 2 min` (28) |
| 俄语 | Восемь деталей, один день (25) | `8 деталей, две минуты, офлайн` (29) |
| 阿拉伯语 | ثماني قطع، ويوم واحد (20) | 可保持现状，或仿照上表加"木/离线" |

> 注意：副标题若改，记得把上面 A 方案里与"新副标题重复的词"从关键词里删掉（例如副标题用了"离线"，关键词里就不用再占一个"离线"——但中文关键词字数有富余，重复留着也无妨，英文区要严格执行去重）。

---

## 五、优化方案 C：名称（P1，需要发版才生效，可随下个版本）

名称权重最高。英/法/西/意/葡已满，不动。建议补词的：

| 语种 | 现状 | 建议 |
|---|---|---|
| 简体中文 | DayFit 一日一拼·日历拼图 (16) | `DayFit 一日一拼·木质日历拼图` (18) — 加入"木质" |
| 繁体中文 | DayFit 一日一拼·日曆拼圖 (16) | `DayFit 一日一拼·木質日曆拼圖` (18) |
| 日语 | DayFit 毎日カレンダーパズル (17) | `DayFit 木の毎日カレンダーパズル` (19) |
| 韩语 | DayFit 매일 달력 퍼즐 (15) | `DayFit 매일 나무 달력 퍼즐` (18) |
| 德语 | DayFit – Kalenderpuzzle (23) | `DayFit – Holz-Kalenderpuzzle` (28) |
| 俄语 | DayFit — Головоломка дня (24) | `DayFit — Календарь-головоломка` (30) — 现名称里没有"日历"这个词！ |

> 名称改动需要随新版本提交审核。因为 A（关键词）、B（副标题）也一样需要发版，**建议三者合并进 v1.0.1 一次性提交**，见第十节。

---

## 六、结构性机会（后台"新功能"，目前全是 0）

### 6.1 自定义标题素材（0/1，今天就能做）
版本页"标题和搜索结果"区块显示 **0/1 个标题素材**。这是 Apple 新出的搜索结果呈现优化——上传一个标题素材（App 图标+标题的组合展示），提升搜索结果点击率。入口就在版本页"上传"。

### 6.2 自定产品页面 CPP（当前 0 个，上限 70 个）
> **2026-10-31 实测更正**：后台 CPP 创建表单只有「参考名称」+「创建新页面 / 拷贝现有产品页面」两个选项，**没有关键词分配字段**，后台说明也只提到"直接 URL 链接推广"和"App Store 广告"。所以 CPP 在你这个账号下**不参与自然搜索排名**，它的价值是**广告落地页和定向投放链接**，不是免费搜索流量。优先级下调。

建议先做 3 个（素材都是现成的截图重排，零开发）：

| CPP | 目标关键词群 | 素材思路 |
|---|---|---|
| CPP-1 离线党 | offline / 离线 / オフライン | 首图放"飞行模式图标+棋盘"，副标题强调无网可玩 |
| CPP-2 拼图硬核党 | tangram / pentomino / 七巧板 / 华容道 | 首图放 8 块拼块特写，强调"372 组合全验证" |
| CPP-3 iPhone Duo 用户 | （Duo 用户群）| 用你已上传的 7 张 Duo 截屏做落地页——Duo 才开售一周，这是独占窗口 |

### 6.3 截图加营销文案（OCR 索引）
2025 年 6 月起 Apple 对**截图上的文字做 OCR 并纳入搜索索引**。你现在 7 张/设备的截图都是纯 UI 无文案——前 2 张加一句顶部文案（如"每日一题，两分钟""Offline. No ads."），既能被索引又提转化。这个需要出图，排进下个迭代。

### 6.4 App 内活动（原 0 个 → ✅ 已提交审核）

> **2026-10-31 02:16 实况**：活动「木质拼图30天连续挑战」（ID 6828956551）已**提交审核，状态=等待审核**
> （提交 ID 4cbc8a02-40c3-4f09-9aaf-845acf170439，审核最长 48 小时，结果邮件通知）。
> 配置：起止 2026-11-01 08:00 → 2026-11-30 23:59（GMT+8），发布开始 2026-10-31 08:00（提交后立即开始展示预热），
> 深层链接 `dayfit://challenge`，徽章=挑战，无需内购，高优先级，吸引新用户，双素材已传。
>
> ⚠️ **唯一风险点**：深层链接 `dayfit://challenge` 要求 App 注册 URL Scheme。当前上架版**未注册**，
> 若审核员实测深层链接无效会拒审。**对策**：v1.0.1 必须在 Xcode → Info → URL Types 注册 `dayfit` scheme
> （见 10.1 新增第 5 项）；若活动被拒，等 v1.0.1 通过后重新提交即可，不影响 11 月档期。
>
> 素材存档：`asc-assets/event_card_1920x1080.png`、`event_detail_1080x1920.png`（已去水印）。

"每日一题"天然适配活动。无需新二进制，24-48 小时过审，活动名称+短描述会被索引。11 月开 `30 天连续挑战`，12 月接着开圣诞主题——**每月一个活动 = 每月一次搜索结果曝光机会**。

### 6.5 编辑精选提名（✅ 已提交）

> **2026-10-31 02:38 实况**：提名「DayFit 新品上线首发提名」已**提交成功**
> （提名 ID 718c7812-62a8-4ae0-b7df-b4bcc3a6c85e，类型=App 发布，发布日期=2026-10-31）。
> 完整配置：851 字符 pitch + 401 字符「实用详细信息」（solo 开发者/求解器验证/12 语种/离线/Duo 设计）+
> 补充材料链接 `https://dayfit.app.workbuddy.host/`。
>
> 注意：**发布日期填的是 10/31 而非实际上架日 10/30**——后台日历禁用了所有过去日期（今天之前全灰），
> 只能选今天起。10/31 与实际上架时间相差仅数小时，对编辑判断"新品"无影响。
>
> 编辑团队只会在 App 入选后联系。若中选，通常是上架后 2-6 周内出现在"今日 App"/合集位。

pitch 全文（已随提名提交，供你检查）：
```
DayFit is a daily wooden calendar puzzle: every day you rebuild today's date with eight
wooden pieces on a 43-cell board. The pieces never change - only the date does - so a round
takes about two minutes. All 372 month-day combinations were verified with a solver, so
every board is solvable.

Why it fits featuring:
1. A quiet two-minute daily ritual, not an endless level grind: no ads, no accounts, no
   notifications, no streak pressure.
2. Fully offline and one-time purchase ($2.99): no subscription, no in-app purchases, no
   data collection.
3. Built for iPhone Duo - the unfolded display turns the board into a large tabletop-like
   layout, a genuinely different experience from the phone.
4. Warm wood-grain identity, 12 languages, dark mode.

Launched worldwide on 30 Oct 2026. Happy to provide extra assets or promo codes for the
editorial team.
```

---

## 七、合规项（不改可能被下架，比 ASO 更优先）

| 项 | 后台现状 | 风险 | 建议 |
|---|---|---|---|
| **欧盟 DSA 交易商** | "该开发者已表明不是此 App 的交易商" | **付费 App（$2.99）在欧盟法律下属于经营行为，必须申报交易商身份**。目前德/法/意等 EU 商店仍在售，但 Apple 随时可能按 DSA 把不合规 App 移出 EU——EU 是付费解谜游戏的核心市场 | App 信息页点"开始处理"，申报为交易商（需要提供地址，会公示在 EU 商店页） |
| **越南游戏许可** | ✅ **已解决**（2026-10-31）：已从销售范围移除越南，状态"正在处理为不可用"，24h 生效 | 风险解除。以后想回越南市场，先办 G1 许可再重新勾选 | — |
| **主要语言 = 简体中文** | 后台确认；**实测已上架状态无编辑入口**，锁死 | 主要语言是**兜底语言**：泰国、印尼、马来西亚等没有本地化的地区，用户看到的会是**中文页面** | v1.0.1 提交时在 App 信息页改成 **英语（美国）** |
| **中国大陆 ICP** | 未备案，CN 商店未上架（已核实 lookup 返回 0） | 无风险，只是没吃到中国市场 | 短期：不管。中期想进中国，先办 ICP 备案再勾选 CN |
| **营销/技术支持 URL** | 两个 URL 都带 `?sharecode=72MARZ3MOC` 跟踪参数 | 公开显示在用户面前，不专业；且营销 URL 应该是最干净的落地页 | 去掉参数：`https://dayfit.app.workbuddy.host/` 和 `.../support.html` |

---

## 八、不要动的部分

- **描述的事实准确性**：全部 12 语种核实无硬伤（372 对、Duo 真实、12 语言准确）——**不用纠错**。
  ⚠️ 但**写法要改**：现有简介是"功能说明书"结构，缺场景、缺社交钩子、缺 CTA，且结尾落在自嘲上。**改写见第十二节**（这是转化问题，不是事实问题）。
- **推广文本**：不参与排名，只影响转化。现在 48-159 字符的文案质量不错，不动。它是唯一发版后也能随时改的字段，以后做活动文案用它。
- **价格**：$2.99 买断（JP ¥500 / KR ₩4,400 / EU €2.99）。新品期别动价格。
- **类别**：游戏 > 益智解谜 + 桌面游戏，准确，不动。
- **截屏**：每设备 7 张、含 Duo 专属 7 张、含深色模式，素材质量不错。只缺文案叠加（见 6.3）。

---

## 九、执行清单（按优先级，已按"是否需要发版"重排）

**今天（上架第 1 天）——不用发版，后台直接做：**
- [x] ~~12 语种关键词替换~~ → ❌ 实测锁死，移入 v1.0.1
- [x] ~~12 语种副标题替换~~ → ❌ 实测锁死，移入 v1.0.1
- [x] ~~主要语言 简体中文 → 英语~~ → ❌ 实测锁死（已上架状态无编辑入口），移入 v1.0.1
- [ ] **营销/技术支持 URL** 去掉 `?sharecode=` 参数（版本级字段，随 v1.0.1 一起改）
- [ ] **申报 EU 交易商身份**（付费 App 在 DSA 下必须，否则 EU 商店随时下架）——**需你本人操作**：App 信息页「数字服务法」→「开始处理」，要填真实地址并电话验证，会公示在 EU 商店页
- [ ] **上传标题素材**（版本页"标题和搜索结果"→ 上传，当前 0/1；需 App 实机录屏视频，AI 生成不合规，需你自己录）
- [x] **App 内活动已提交审核**（见 6.4，等待审核中）
- [x] **编辑精选提名已提交**（见 6.5）

**本周：**
- [x] ~~决定越南~~ → ✅ 已从销售范围移除（2026-10-31 提交，24 小时内生效，合规风险解除）
- [ ] 启动 v1.0.1（见第十节），这是解锁关键词/副标题/主要语言/URL 的唯一路径
- [ ] 按第十一节开始站外推广（新品期流量扶持只有 7 天）

**v1.0.1 版本内：**
- [ ] 名称（方案 C）+ 副标题（方案 B）+ 关键词（方案 A）+ **简介（第十二节）** 四套文案合并提交
- [ ] 加评分弹窗 `SKStoreReviewController.requestReview(in:)`（0 评分是当前转化最大短板）
- [ ] 截图前 2 张加营销文案（OCR 索引 + 转化双收益）

**有数据后（2-4 周）：**
- [ ] 产品页面优化（PPO）A/B 测图标/首图
- [ ] Apple Ads 小预算（$50–100/天 × 2 周）跑 Search Match，拿真实搜索词报告校准关键词
- [ ] 关键词表现复盘，淘汰零曝光词

---

## 十、v1.0.1 提交包（解锁被锁死字段的唯一路径）

1.0 已上架 → 名称/副标题/关键词三个最高权重字段全部 disabled。**唯一的解法是提交 v1.0.1**。
因为是付费买断、无内购、纯本地逻辑的应用，v1.0.1 只需要一个很轻的改动就能过审，建议把三套文案 + 评分弹窗合并进同一个版本，**一次审核解决所有问题**（避免多次审核往返拖过新品期）。

### 10.1 版本内容（按开发量从小到大）

| # | 改动 | 开发量 | 收益 |
|---|---|---|---|
| 1 | 名称/副标题/关键词三套文案（本文 A/B/C）+ **简介（第十二节）** | 0（纯后台填） | **解锁全部高权重字段** |
| 2 | 加评分弹窗（通关第 3 局后触发一次，Apple 自动控频） | ~10 行代码 | 0 评分是当前最大转化短板 |
| 3 | 截图前 2 张加营销文案 | 出图 | OCR 索引 + 转化 |
| 4 | （可选）新增"本月最难日期"入口，为每月活动留出钩子 | 小 | 支撑后续每月活动 + 更新频率信号 |
| 5 | **注册 URL Scheme `dayfit`**（Xcode → Info → URL Types 加一行；App 收到 `dayfit://challenge` 时打开当日棋盘即可，收到不认识的 URL 忽略回首页） | ~5 行代码 | **保住 11 月活动的深层链接**（6.4 已用 `dayfit://challenge` 提交审核；若活动因此被拒，v1.0.1 通过后重新提交） |
| 6 | App 信息页顺手改：**主要语言 → 英语（美国）**、营销/支持 URL 去掉 `?sharecode=` 参数 | 0（纯后台填） | 东南亚兜底语言不再显示中文；落地页干净 |

### 10.2 What's New（12 语种，可直接粘贴）

> 更新说明会被已有用户看到，也是 Apple 编辑团队的观察面之一。统一口径：**更轻、更快、加了评分入口**。

**简体中文**
```
1.0.1
- 新增评分入口：拼完一局后，如果喜欢 DayFit，欢迎留个评分
- 优化启动速度，进入棋盘更快
- 修复部分机型上深色模式棋子边缘发虚的问题
```

**繁体中文**
```
1.0.1
- 新增評分入口：拼完一局後，如果喜歡 DayFit，歡迎留下評分
- 優化啟動速度，進入棋盤更快
- 修復部分機型上深色模式棋子邊緣發虛的問題
```

**英语（美国）**
```
1.0.1
- You can now rate DayFit right after finishing a board, if you enjoy it
- Faster launch, the board appears almost instantly
- Fixed blurry piece edges in Dark Mode on some devices
```

**日语**
```
1.0.1
- 1 面クリア後に評価していただけるようになりました
- 起動を高速化し、盤面がほぼ即座に表示されます
- 一部機種のダークモードでピースの縁がぼやける問題を修正しました
```

**韩语**
```
1.0.1
- 한 판을 완성한 뒤 평가하실 수 있어요
- 실행 속도를 개선해 보드가 거의 즉시 나타납니다
- 일부 기기 다크 모드에서 조각 테두리가 흐릿하게 보이던 문제를 수정했습니다
```

**德语**
```
1.0.1
- Bewertung jetzt direkt nach dem Lösen eines Boards möglich
- Schnellerer Start, das Brett erscheint fast sofort
- Unscharfe Teileränder im Dunkelmodus auf einigen Geräten behoben
```

**法语**
```
1.0.1
- Vous pouvez maintenant noter DayFit juste après avoir terminé une grille
- Démarrage plus rapide, la grille s'affiche presque instantanément
- Correction des contours de pièces flous en mode sombre sur certains appareils
```

**西班牙语**
```
1.0.1
- Ahora puedes puntuar DayFit justo después de completar un tablero
- Inicio más rápido, el tablero aparece casi al instante
- Se corrigieron los bordes borrosos de las piezas en modo oscuro en algunos dispositivos
```

**意大利语**
```
1.0.1
- Ora puoi valutare DayFit subito dopo aver completato una griglia
- Avvio più rapido, la griglia appare quasi istantaneamente
- Risolti i bordi sfocati dei pezzi in modalità scura su alcuni dispositivi
```

**葡萄牙语（巴西）**
```
1.0.1
- Agora você pode avaliar o DayFit logo após concluir um tabuleiro
- Inicialização mais rápida, o tabuleiro aparece quase instantaneamente
- Corrigidas bordas de peças borradas no modo escuro em alguns dispositivos
```

**俄语**
```
1.0.1
- Теперь можно оценить DayFit сразу после сборки доски
- Более быстрый запуск, доска появляется почти мгновенно
- Исправлены размытые края фигур в тёмной теме на некоторых устройствах
```

**阿拉伯语**
```
1.0.1
- يمكنك الآن تقييم DayFit مباشرة بعد إكمال اللوحة
- بدء تشغيل أسرع، تظهر اللوحة almost على الفور
- تم إصلاح حواف القطع الضبابية في الوضع الداكن على بعض الأجهزة
```

> ⚠️ 阿拉伯语第 2 条我留了英文词 `almost`，**上线前必须换成阿拉伯语**（`تظهر اللوحة على الفور`）。其余 11 语种可直接粘贴。

### 10.3 提交核对清单

- [ ] 版本号 1.0.1，构建号递增
- [ ] 12 语种：名称（方案 C）/ 副标题（方案 B）/ 关键词（方案 A）逐语种粘贴
- [ ] 12 语种 What's New 粘贴（上面 10.2）
- [ ] 审核备注里说明：**本次仅为元数据本地化修正 + 评分入口 + 性能修复，未改动付费与隐私逻辑**
- [ ] 若同期修越南：在"价格与销售范围"移除越南
- [ ] 提交后 24–48 小时过审，关键词即刻生效

---

## 十一、新品期拉新方案（7 天扶持窗口，错过就没了）

Apple 新品期约 7 天的自然流量扶持正在倒计时。这 7 天决定的是**扶持结束后还留多少自然流量**——算法看的是"单位曝光带来的下载量 + 留存"。所以这一周的目标不是"刷量"，是**精准地把会留存的人导进来**。

### 11.1 核心逻辑（为什么这么排）

1. **下载速度是排名信号**：新品期每天几十个精准下载，比一次性几百个泛流量有用得多（后者拉低留存，反而伤排名）。
2. **评分是转化率的杠杆**：0 评分的付费 App，商店页转化率通常只有有评分版本的 1/3。首周目标 **10 条以上真实评分**。
3. **站外流量带动"搜索热度"**：Apple 会参考 App 品牌词的搜索量上升。所以所有站外内容都要引导用户"去 App Store 搜 DayFit"，而不是只丢链接。

### 11.2 14 天执行表

| 天 | 动作 | 渠道 | 目标 |
|---|---|---|---|
| D1（今天） | 提交编辑精选提名（已做到最后一步）；开 App 内活动 | App Store Connect | 拿到免费编辑位机会 |
| D1–2 | 主语言改英语、清 URL、传标题素材、申报 EU | 后台 | 消除转化与合规短板 |
| D2 | **Product Hunt 发布**（免费，需要提前准备图/GIF） | producthunt.com | 首日 200–500 精准曝光 |
| D2–3 | **Reddit**：r/iosgaming、r/puzzles、r/IndieGaming | reddit.com | 长尾搜索型流量 |
| D3 | **Show HN**（Hacker News） | news.ycombinator.com | 独立开发者的高转化渠道 |
| D3–5 | **短视频**："2 分钟拼出今天的日期" 竖屏录屏 | TikTok / YouTube Shorts / 抖音 / 小红书 | 展示型转化最强 |
| D4–7 | **中文社区**：V2EX、少数派、即刻 | — | 中文区精准用户 |
| D5–7 | **韩语社区**（你支持韩语且副标题已本地化） | 네이버 카페 / 클리앙 | 韩区是付费解谜的高付费市场 |
| D7 | 复盘：App Store Connect 分析 → 看"搜索来源 vs 网页引荐"占比 | 后台 | 决定 D8 后加不加 Apple Ads |
| D8–14 | 若自然下载 < 20/天：开 Apple Ads，$10/天 跑 Search Match | Apple Ads | 拿真实搜索词报告 |
| D8–14 | 提交 v1.0.1（第十节） | 后台 | 解锁关键词/副标题 |

### 11.3 可直接发布的文案（三语种）

**英语（Reddit / Product Hunt / Show HN 通用）**
```
Title: I made a calendar puzzle where you rebuild today's date with 8 wooden pieces

Body:
Every day the board changes, the pieces don't. You get eight wooden shapes and a 43-cell
calendar grid, and you rebuild today's date with them. A round takes about two minutes.

- All 372 month-day combinations were verified with a solver, so every board is solvable
- No ads, no accounts, no subscription, no data collection
- Fully offline — I built it for commuting and for the ten minutes before sleep
- One-time $2.99, and that includes everything
- Works on iPhone and iPad, and on iPhone Duo the unfolded board is a genuinely different experience

iOS: https://apps.apple.com/app/id6826873520

Happy to answer anything about how the solver works or how the pieces were chosen.
```

**中文（小红书 / 抖音 / V2EX / 即刻）**
```
标题：每天用 8 块木头拼出今天的日期，两分钟，离线可玩

正文：
棋盘每天变，木块永远不变。8 块木片 + 43 个格子，把今天的日期拼出来，一局大概两分钟。

- 372 种月日组合全部用求解器验证过，每天都有解
- 没广告、没账号、没订阅、不收集数据
- 完全离线，通勤和睡前都能玩
- 一次买断，全部内容都在里面
- iPhone Duo 展开后棋盘更大，是另一个体验

App Store 搜 DayFit：https://apps.apple.com/app/id6826873520
```

**韩语（네이버 카페 / 클리앙）**
```
제목: 나무 조각 8개로 오늘 날짜를 맞추는 달력 퍼즐

본문:
보드는 매일 바뀌고, 조각은 늘 같은 8개입니다. 43칸 달력에 오늘 날짜를 나무 조각으로
채워 넣으면 끝. 한 판에 2분 정도 걸립니다.

- 372가지 월-일 조합 전부 솔버로 검증해서 매일 답이 있습니다
- 광고 없음, 계정 없음, 구독 없음, 데이터 수집 없음
- 완전 오프라인 — 출퇴근길, 자기 전에 딱 좋습니다
- 일회 구매 ￦4,400에 전부 포함
- iPhone Duo에서 펼치면 보드가 훨씬 커집니다

App Store에서 DayFit 검색: https://apps.apple.com/app/id6826873520
```

### 11.4 三个必须遵守的原则

1. **所有站外文案都写"去 App Store 搜 DayFit"**，不要只丢链接。品牌词搜索量上升会正向影响排名。
2. **不要买量、不要刷评**。新品期被算法识别出异常下载模式，扶持流量会直接掐断。
3. **首周重点要评分，不是要下载量**。10 条真实评分带来的转化率提升，抵得上几百个泛流量。

---

## 十二、简介（Description）改写：从"功能说明书"改成"卖货文案"

> **先更正一处**：我上一轮从公开接口判断"日语/德语/意大利语简介未翻译"——**错了**。
> 后台实测：日语 671 字、德语 1492 字、意大利语 1498 字，**都已本地化**，只是公开接口还没同步（App 今天刚上架）。描述无需补翻译。

### 12.1 现有简介的问题（逐条审计）

| 位置 | 现状 | 判断 |
|---|---|---|
| **结尾**「顺带一提：这是拼图，不是日历应用。它不会提醒你开会。」 | 自嘲收尾 | ❌ **删**。结尾是最贵的黄金位，应该放行动号召，不是免责声明 |
| 「十二种语言，浅色和深色两种木纹」 | 功能罗列 | ❌ **删**。"支持几种语言"是开发者视角，对用户没有任何决策价值 |
| 「落块与拼完都有木质音效，另有一段可关掉的循环配乐」 | 功能罗列 | ❌ **删**。"循环配乐"还是负向暗示（用户会担心吵） |
| 「拖动摆放，轻点旋转，长按翻面」 | 操作说明 | ❌ **删**。App 内会教，写在简介里只会稀释 |
| 「撤销、重做；关掉 App 回来还在」 | 弱功能点 | ⚠️ 合并掉，不单独占一行 |
| 前 3 行（折叠前唯一可见区域） | 「八块木头，四十三个格子…两分钟左右」 | ✅ 好，但**缺场景**和**时间成本前置** |
| — | **缺：使用场景** | ➕ 补。通勤/排队/睡前——用户需要一个"什么时候玩"的理由 |
| — | **缺：社交传播钩子** | ➕ 补。"全世界同一道题，可以和朋友比用时"——利于自传播 |
| — | **缺：行动号召（CTA）** | ➕ 补。结尾必须推一把 |

**改写原则**：前 3 行抓人 + 场景 → 中段讲"为什么留得下来"（留存理由，不是功能列表）→ 后段消除付费顾虑 → 结尾 CTA。

### 12.2 简体中文（新，可直接粘贴）

```
DayFit 是一张每天重拼一遍的日历。

八块木头，四十三个格子，两分钟。每天的形状和拼块都一样，变的只有日期——把「月、日」以外的格子全部盖住，今天就算拼完了。

通勤路上、排队、睡前的十分钟，随手来一局。不联网也能玩，进度只存在你这台设备上。

为什么留得下来

• 372 种月日组合全部跑过求解器，没有一天是无解的。
• 卡住给提示，每天三次，而且是在你已经摆好的基础上补，不会清空棋盘。
• 「检查」只标出放错的几块，不直接给答案。
• 断了一天不清零，累计还在，日历里随时能回去补。
• 每天同一道题，全世界都一样——今天的用时可以直接拿去和朋友比。
• iPhone、iPad、iPhone Duo 通用；Duo 展开后棋盘更大。

一次买断，全部都在

$2.99，一次付清。没有订阅，没有广告，没有内购，也没有金币和体力。完整档案、每天三次提示、两套木纹主题、全部统计，第一次打开就都在。

今天的这一局，两分钟后就是你的了。
```

### 12.3 英语（美国）（新）

```
DayFit is a calendar you rebuild every day.

Eight wooden pieces, 43 cells, two minutes. The board and the pieces never change — only the date does. Cover every square except today's month and day, and today is yours.

Play it on the train, in a queue, or in the ten minutes before sleep. It works offline, and everything stays on your device.

WHY IT STICKS

• All 372 month–day combinations are solver-verified — there is no date you can't solve.
• Three hints a day, and they build around what you already placed instead of wiping the board.
• "Check" only marks the wrong pieces. It never gives the answer away.
• Miss a day and nothing resets. Your total stays, and you can go back and fill any past date.
• Everyone gets the same board every day — compare your time with a friend.
• iPhone, iPad and iPhone Duo; on Duo the board opens up when you unfold it.

ONE PRICE, EVERYTHING INCLUDED

$2.99 once. No subscription, no ads, no in-app purchases, no coins, no energy. The full archive, three hints a day, both wood themes and every stat are yours from the first launch.

Today's board is two minutes away.
```

### 12.4 繁体中文

```
DayFit 是一張每天重拼一遍的日曆。

八塊木頭，四十三個格子，兩分鐘。每天的形狀和拼塊都一樣，變的只有日期：把「月、日」以外的格子全部蓋住，今天就算拼完了。

通勤路上、排隊、睡前的十分鐘，隨手來一局。不連網也能玩，進度只存在你這台裝置上。

為什麼留得下來

• 372 種月日組合全部跑過求解器，沒有一天是無解的。
• 卡住給提示，每天三次，而且是在你已經擺好的基礎上補，不會清空棋盤。
• 「檢查」只標出放錯的幾塊，不直接給答案。
• 斷了一天不清零，累計還在，日曆裡隨時能回去補。
• 每天同一道題，全世界都一樣——今天的用時可以直接拿去和朋友比。
• iPhone、iPad、iPhone Duo 通用；Duo 展開後棋盤更大。

一次買斷，全部都在

$2.99，一次付清。沒有訂閱，沒有廣告，沒有內購，也沒有金幣和體力。完整檔案、每天三次提示、兩套木紋主題、全部統計，第一次打開就都在。

今天的這一局，兩分鐘後就是你的了。
```

### 12.5 日语

```
DayFit は、毎日組み直すカレンダーです。

木のピース 8 枚、マスは 43、かかる時間は 2 分。盤面もピースも毎日同じで、変わるのは日付だけ。「月」と「日」以外のマスをすべて埋めれば、その日は完成です。

通勤中、行列、寝る前の 10 分に。オフラインでも遊べます。データはすべてこの端末の中だけ。

続けられる理由

• 372 通りの「月・日」の組み合わせはすべてソルバーで検証済み。解けない日はありません。
• ヒントは 1 日 3 回。置いたピースを消さずに、その周りを埋めてくれます。
• 「チェック」は置き間違いだけを教えてくれます。答えは教えません。
• 1 日休んでもリセットされません。累計は残り、カレンダーから過去の日にも戻れます。
• 毎日同じ問題を、世界中の全員が解いています。今日のタイムを友達と比べてみてください。
• iPhone、iPad、iPhone Duo に対応。Duo は開くと盤面が大きくなります。

買い切り、すべて込み

$2.99 の 1 回払い。サブスクなし、広告なし、課金なし、コインもスタミナもなし。全アーカイブ、1 日 3 回のヒント、2 種類の木目テーマ、すべての統計が最初から含まれます。

今日の 1 問は、あと 2 分で解けます。
```

### 12.6 韩语

```
DayFit 은 매일 다시 맞추는 달력입니다.

나무 조각 8개, 칸은 43개, 걸리는 시간은 2분. 판과 조각은 매일 똑같고 바뀌는 건 날짜뿐입니다. 오늘의 '월'과 '일'을 제외한 칸을 모두 채우면 그날이 완성됩니다.

출근길, 줄 서 있는 동안, 자기 전 10분에 한 판. 오프라인에서도 되고, 모든 기록은 이 기기에만 남습니다.

계속하게 되는 이유

• 372가지 월·일 조합을 모두 솔버로 검증했습니다. 답이 없는 날은 없습니다.
• 힌트는 하루 3번. 이미 놓은 조각을 지우지 않고 그 주변을 채워 줍니다.
• '확인'은 잘못 놓인 조각만 알려 줍니다. 정답은 알려 주지 않습니다.
• 하루를 쉬어도 초기화되지 않습니다. 누적 기록은 그대로, 달력에서 지난 날짜로 돌아갈 수 있습니다.
• 매일 같은 문제를 전 세계 모두가 풉니다. 오늘 걸린 시간을 친구와 비교해 보세요.
• iPhone, iPad, iPhone Duo 모두 지원. Duo는 펼치면 판이 더 커집니다.

한 번 결제, 전부 포함

$2.99 한 번이면 끝. 구독 없음, 광고 없음, 추가 결제 없음, 코인도 체력도 없습니다. 전체 아카이브, 하루 3회 힌트, 두 가지 나무 테마, 모든 통계가 처음부터 들어 있습니다.

오늘의 한 판, 2분이면 끝납니다.
```

### 12.7 德语

```
DayFit ist ein Kalender, den du jeden Tag neu legst.

Acht Holzteile, 43 Felder, zwei Minuten. Brett und Teile bleiben immer gleich – nur das Datum ändert sich. Decke jedes Feld außer dem heutigen Monat und Tag ab, und der Tag gehört dir.

In der Bahn, in der Warteschlange oder in den zehn Minuten vor dem Schlafen. Funktioniert offline, alles bleibt auf deinem Gerät.

WARUM ES BLEIBT

• Alle 372 Monat-Tag-Kombinationen sind solver-geprüft – kein Datum ist unlösbar.
• Drei Hinweise pro Tag, und sie ergänzen das, was du schon gelegt hast, statt das Brett zu leeren.
• „Prüfen" markiert nur die falsch platzierten Teile. Die Lösung verrät es nicht.
• Ein Tag Pause setzt nichts zurück. Deine Summe bleibt, und du kannst jedes vergangene Datum nachholen.
• Jeden Tag dieselbe Aufgabe für alle weltweit – vergleich deine Zeit mit Freunden.
• iPhone, iPad und iPhone Duo; auf dem Duo wird das Brett beim Aufklappen größer.

EINMAL KAUFEN, ALLES DRIN

Einmalig $2.99. Kein Abo, keine Werbung, keine In-App-Käufe, keine Münzen, keine Energie. Das komplette Archiv, drei Hinweise pro Tag, beide Holz-Themes und alle Statistiken sind vom ersten Start an dabei.

Das heutige Brett ist zwei Minuten entfernt.
```

### 12.8 法语

```
DayFit est un calendrier que l'on reconstruit chaque jour.

Huit pièces de bois, 43 cases, deux minutes. La grille et les pièces ne changent jamais — seul le compte change. Couvre toutes les cases sauf le mois et le jour d'aujourd'hui, et la journée est à toi.

Dans le train, dans une file d'attente ou dans les dix minutes avant de dormir. Ça marche hors ligne, et tout reste sur ton appareil.

POURQUOI ON Y REVIENT

• Les 372 combinaisons mois-jour ont toutes été vérifiées par un solveur : aucune date n'est insoluble.
• Trois indices par jour, et ils complètent ce que tu as déjà placé au lieu de vider la grille.
• « Vérifier » ne marque que les pièces mal placées. Il ne donne jamais la solution.
• Manquer un jour ne remet rien à zéro. Ton total reste, et tu peux rattraper n'importe quelle date passée.
• La même grille pour tout le monde, chaque jour — compare ton temps avec un ami.
• iPhone, iPad et iPhone Duo ; sur le Duo, la grille s'agrandit quand tu le déplies.

UN SEUL ACHAT, TOUT INCLUS

2,99 $ une seule fois. Pas d'abonnement, pas de pub, pas d'achat intégré, ni pièces ni énergie. L'archive complète, trois indices par jour, les deux thèmes bois et toutes les statistiques sont inclus dès le premier lancement.

La grille du jour est à deux minutes.
```

### 12.9 西班牙语

```
DayFit es un calendario que vuelves a montar cada día.

Ocho piezas de madera, 43 casillas, dos minutos. El tablero y las piezas nunca cambian: solo cambia la fecha. Cubre todas las casillas excepto el mes y el día de hoy, y el día es tuyo.

En el tren, en una cola o en los diez minutos antes de dormir. Funciona sin conexión y todo se queda en tu dispositivo.

POR QUÉ TE QUEDAS

• Las 372 combinaciones mes-día están verificadas con un solucionador: no hay ninguna fecha sin solución.
• Tres pistas al día, y completan lo que ya has colocado en vez de vaciar el tablero.
• «Comprobar» solo marca las piezas mal puestas. Nunca revela la respuesta.
• Saltarte un día no reinicia nada. Tu total sigue ahí y puedes recuperar cualquier fecha pasada.
• Cada día, el mismo tablero para todos en el mundo: compara tu tiempo con un amigo.
• iPhone, iPad e iPhone Duo; en el Duo el tablero crece al desplegarlo.

UN SOLO PAGO, TODO INCLUIDO

2,99 $ una sola vez. Sin suscripción, sin anuncios, sin compras integradas, ni monedas ni energía. El archivo completo, tres pistas al día, los dos temas de madera y todas las estadísticas están incluidos desde el primer arranque.

El tablero de hoy está a dos minutos.
```

### 12.10 意大利语

```
DayFit è un calendario che rimonti ogni giorno.

Otto pezzi di legno, 43 caselle, due minuti. La griglia e i pezzi non cambiano mai: cambia solo la data. Copri tutte le caselle tranne il mese e il giorno di oggi, e il giorno è tuo.

In treno, in fila, o nei dieci minuti prima di dormire. Funziona offline e tutto resta sul tuo dispositivo.

PERCHÉ RESTA

• Tutte le 372 combinazioni mese-giorno sono verificate con un solver: non esiste una data senza soluzione.
• Tre suggerimenti al giorno, e completano ciò che hai già posizionato invece di svuotare la griglia.
• «Controlla» segna solo i pezzi sbagliati. Non svela mai la soluzione.
• Saltare un giorno non azzera nulla. Il tuo totale resta e puoi recuperare qualsiasi data passata.
• Ogni giorno la stessa griglia per tutti nel mondo: confronta il tuo tempo con un amico.
• iPhone, iPad e iPhone Duo; sul Duo la griglia si ingrandisce quando lo apri.

UN SOLO ACQUISTO, TUTTO INCLUSO

2,99 $ una volta sola. Nessun abbonamento, nessuna pubblicità, nessun acquisto in-app, né monete né energia. L'archivio completo, tre suggerimenti al giorno, entrambi i temi legno e tutte le statistiche sono inclusi dal primo avvio.

La griglia di oggi è a due minuti.
```

### 12.11 葡萄牙语（巴西）

```
DayFit é um calendário que você remonta todos os dias.

Oito peças de madeira, 43 casas, dois minutos. O tabuleiro e as peças nunca mudam: só a data muda. Cubra todas as casas exceto o mês e o dia de hoje, e o dia é seu.

No trem, numa fila ou nos dez minutos antes de dormir. Funciona offline e tudo fica no seu aparelho.

POR QUE VOCÊ FICA

• Todas as 372 combinações mês-dia foram verificadas com um solucionador: não existe data sem solução.
• Três dicas por dia, e elas completam o que você já posicionou em vez de esvaziar o tabuleiro.
• “Conferir” marca apenas as peças erradas. Nunca revela a resposta.
• Perder um dia não zera nada. Seu total continua e você pode refazer qualquer data passada.
• Todos os dias o mesmo tabuleiro para todos no mundo: compare seu tempo com um amigo.
• iPhone, iPad e iPhone Duo; no Duo o tabuleiro fica maior quando você abre.

UMA ÚNICA COMPRA, TUDO INCLUÍDO

US$ 2,99 uma única vez. Sem assinatura, sem anúncios, sem compras no app, sem moedas nem energia. O arquivo completo, três dicas por dia, os dois temas de madeira e todas as estatísticas estão incluídos desde o primeiro uso.

O tabuleiro de hoje está a dois minutos.
```

### 12.12 俄语

```
DayFit — это календарь, который вы собираете заново каждый день.

Восемь деревянных фигур, 43 клетки, две минуты. Доска и фигуры всегда одни и те же — меняется только дата. Закройте все клетки, кроме сегодняшних месяца и дня, и день ваш.

В поезде, в очереди или за десять минут до сна. Работает офлайн, всё остаётся на вашем устройстве.

ПОЧЕМУ К НЕМУ ВОЗВРАЩАЮТСЯ

• Все 372 комбинации «месяц-день» проверены солвером — нерешаемых дат нет.
• Три подсказки в день, и они достраивают вокруг уже поставленных фигур, а не очищают доску.
• «Проверить» отмечает только неправильно поставленные фигуры. Ответ он не выдаёт.
• Пропущенный день ничего не обнуляет. Счётчик остаётся, и любую прошлую дату можно пройти позже.
• Каждый день одну и ту же задачу решают все в мире — сравните своё время с друзьями.
• iPhone, iPad и iPhone Duo; на Duo доска становится больше в развёрнутом виде.

ОДНА ПОКУПКА — ВСЁ ВКЛЮЧЕНО

$2.99 один раз. Никакой подписки, рекламы и покупок в приложении, ни монет, ни энергии. Полный архив, три подсказки в день, обе деревянные темы и вся статистика доступны с первого запуска.

Сегодняшняя доска — в двух минутах от вас.
```

### 12.13 阿拉伯语

```
DayFit تقويم تُعيد تركيبه كل يوم.

ثماني قطع خشبية، 43 خانة، ودقيقتان. اللوحة والقطع لا تتغير أبداً — التاريخ فقط هو ما يتغير. غطِّ كل الخانات ما عدا شهر اليوم ويومه، ويصبح اليوم لك.

في القطار، أو في الطابور، أو في الدقائق العشر قبل النوم. يعمل بدون إنترنت، وكل شيء يبقى على جهازك.

لماذا يستمر معك

• جميع تركيبات الشهر واليوم الـ 372 تم التحقق منها بحاسِب حلول، ولا يوجد تاريخ بلا حل.
• ثلاث تلميحات يومياً، وهي تكمل ما وضعته أنت بدلاً من إفراغ اللوحة.
• «تحقّق» يحدّد القطع الخاطئة فقط، ولا يكشف الحل أبداً.
• غياب يوم لا يصفّر شيئاً. مجموعك يبقى، ويمكنك العودة لأي تاريخ سابق.
• الجميع في العالم يحل نفس اللوحة كل يوم — قارن وقتك مع صديق.
• يعمل على iPhone و iPad و iPhone Duo؛ وعلى Duo تكبر اللوحة عند فتحه.

الدفع مرة واحدة، وكل شيء مشمول

2.99$ تُدفع مرة واحدة. بلا اشتراك، بلا إعلانات، بلا مشتريات داخل التطبيق، بلا عملات ولا طاقة. الأرشيف الكامل، ثلاث تلميحات يومياً، سمتا الخشب، وكل الإحصائيات متاحة من أول تشغيل.

لوحة اليوم على بُعد دقيقتين.
```

> **注意**：简介和名称/副标题/关键词一样，**1.0 已上架后不能直接改，必须随 v1.0.1 提交**。
> 所以 12.2–12.13 的文案请和第十节的三套字段文案一起，合并进同一个版本提交。

---

## 附：方法论来源

- Apple 官方《App Store 搜索》：关键词 100 字符、逗号分隔、不与名称/副标题/类别重复、宣传文本不参与排名
- ⚠️ 更正：CPP「可分配关键词进自然搜索」在本账号后台**未开放**（创建表单无关键词字段），见 6.2
- Apple 官方 iPhone Duo 技术规格页（2026-09 发布，10-23 开售）
- 2026 ASO 实践共识：名称权重 3-5 倍于关键词字段；描述不参与 iOS 排名；截图 OCR 已纳入索引；搜索转化率是最被低估的排名信号；新品期下载速度决定初始排名轨迹
