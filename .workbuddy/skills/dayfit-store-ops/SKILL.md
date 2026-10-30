---
name: dayfit-store-ops
description: 操作 DayFit（Apple ID 6826873520，iOS 日历拼图，已上架）的 App Store Connect 后台时使用。覆盖改本地化文本、创建/提交 App 内活动、编辑精选提名、改销售供应范围、排查字段是否锁死，以及 ASC 后台脚本自动化的实战手法（日期控件怎么点、SPA 白屏怎么破、切语种要等多久）。关键词：App Store Connect、ASC、App 内活动、提名、供应范围、ASO、关键词、副标题、推广文本。
---

# DayFit App Store Connect 后台操作

## 环境

```bash
# ego-browser（用户已登录 ASC：磊 赵 / Lei Zhao）
export PATH="$HOME/.local/bin:$PATH"   # gh 装在这里
ego-browser nodejs <<'EOF' ... EOF
```

task space：先 `await useOrCreateTaskSpace(2)`（名 `DayFit ASC 优化执行`，agent 拥有）。

## 页面 URL 速查（App ID 6826873520）

| 页面 | URL |
|---|---|
| App 信息 | `/apps/6826873520/distribution/info` |
| 版本（推广文本在这里改） | `/apps/6826873520/distribution/ios/version/deliverable` |
| App 内活动列表 | `/apps/6826873520/distribution/events` |
| **活动详情** | `/apps/6826873520/distribution/events/<id>` ⚠️ 没有 `details/` 段，带 `details/` 会报错页 |
| App 审核提交详情 | `/apps/6826873520/distribution/reviewsubmissions/details/<uuid>` |
| 编辑精选提名 | `/apps/6826873520/distribution/nominations` |
| 价格与销售范围 | `/apps/6826873520/distribution/pricing` |
| 供应范围管理 | `/apps/6826873520/distribution/pricing/availability` |

## 已验证可用的自动化手法

### 1. 文本输入框写入（React 受控组件）

```js
const setter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set
setter.call(el, '内容')
el.dispatchEvent(new Event('input',  { bubbles: true }))
el.dispatchEvent(new Event('change', { bubbles: true }))
el.dispatchEvent(new Event('blur',   { bubbles: true }))
```
textarea 用 `HTMLTextAreaElement.prototype`。

### 2. 可写的日期输入框（placeholder = 请选择…）

**可以直接写文本**，React 会接住并本地化重排：

```js
setter.call(el, '2026-11-01 08:00')   // 输出 "2026年11月1日 上午 8:00"
```
字段名形如 `territorySchedules[0].eventStart` / `eventEnd` / `publishStart`。

### 3. readonly 日历弹层（如提名的 `draft-publish-date`）

输入框 `readonly`，键入无效；日历格子的合成点击、CDP 真实鼠标点击**都会被 react-aria 的 usePress 屏蔽**。
**唯一可行解法：直接调 React fiber 上的 onClick。**

```js
const b = [...document.querySelectorAll('button[aria-label]')]
  .find(b => b.getAttribute('aria-label').startsWith('2026-10-31'))  // aria-label 是完整 ISO 日期
const cur = b[Object.keys(b).find(k => k.startsWith('__react'))]
let f = cur
for (let i = 0; i < 4; i++) {              // ⚠️ 只到 depth 3
  const p = f.memoizedProps || f.pendingProps
  if (p && typeof p.onClick === 'function')
    p.onClick({ target: b, currentTarget: b, preventDefault(){}, stopPropagation(){}, nativeEvent: {} })
  f = f.return
}
```

> **坑**：禁用的日期（过去日期，`props.disabled === true`）往 depth 4 调会抛
> `RangeError: Invalid time value` 并**崩掉整个弹层**（已填内容全丢）。
> 只调 depth 0–3 即可选中可用日期。点之前先读 `props.disabled` 确认日期可选。

### 4. 卡片 / 列表行点击（打开详情）

完整指针事件链有效：

```js
const el = document.elementFromPoint(cx, cy) || target
const o = { bubbles: true, cancelable: true, view: window, clientX: cx, clientY: cy, button: 0 }
el.dispatchEvent(new PointerEvent('pointerdown', o))
el.dispatchEvent(new MouseEvent('mousedown', o))
el.dispatchEvent(new PointerEvent('pointerup', o))
el.dispatchEvent(new MouseEvent('mouseup', o))
el.dispatchEvent(new MouseEvent('click', o))
```

### 5. 复选框

`el.click()` 有效，但**组件会重渲染导致旧 DOM 引用失效**——`click()` 后必须在**同一次 js 调用里**
重新 `querySelector` 再读 `checked`，跨 evaluate 读会拿到 `null`。

### 6. SPA 白屏

async 页面经常只渲染出侧边栏。`location.reload()` + `wait 15–18s`，必要时 `scrollBy(300)` 再滚回来触发渲染。
页面渲染完成标志：`document.body.innerText` 行数明显变多（几十行 → 上百行）。

## 已知约束（别再浪费时间）

- **1.0 已上架 → 名称/副标题/关键词/简介全部 disabled**，页面顶部有原文提示。
  上架后唯一能即时改的文本字段是**推广文本**（版本页「推广文本 → 编辑」，按语种逐个保存）。
- **副标题没有编辑入口**，不用找了。
- **主要语言**在已上架状态无编辑入口，只能随新版本改。
- **CPP（自定产品页面）本账号下没有关键词字段**，不参与自然搜索，只作广告落地页。
- **提名的发布日期只能选今天及以后**（过去日期全部 disabled）。
- **切语种后必须 `wait ≥ 11s`**，且打开编辑弹层后要**回读当前值**确认语种，否则会写串（曾发生西/意/英三语串写）。
- 活动详情的**深层链接是必填**（`id="deepLink"`），不填无法提交审核。
- 提交活动：点「添加以供审核」是下拉菜单 → 选「iOS 提交草稿」→ 再点「提交以供审核」。
- ASC 列表里可能残留一个空的 iOS 提交草稿（0 个项目），无害，不用管。

## 当前进行中的项目

- 活动「木质拼图30天连续挑战」：⏳ 等待审核，提交 ID `4cbc8a02-40c3-4f09-9aaf-845acf170439`
- 提名「DayFit 新品上线首发提名」：✅ 已提交，提名 ID `718c7812-62a8-4ae0-b7df-b4bcc3a6c85e`
- 越南供应范围：⏳ 移除中（"正在处理为不可用"，24h 生效）

下一次接手先看 `docs/aso/NEXT-STEPS.md`。
