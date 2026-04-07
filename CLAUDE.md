# CLAUDE.md

本文件为 Claude Code (claude.ai/code) 在此代码仓库中工作时提供指导。

## 项目概述

这是一个 Godot 4.x 2D 动作冒险游戏 (`tu_long_yong_shi`)。游戏采用像素美术风格，视口 480x270 缩放至 1920x1080。

## 运行与构建

- **用 Godot 打开**: 使用 `Godot_v4.5-stable_win64.exe`（配置在 `.vscode/settings.json`）
- **导出游戏**: 导出预设已配置为 Windows Desktop 平台，导出路径为 `../../../迅雷下载/tulong.exe`

## 核心架构

### Autoload 全局管理器

| 管理器 | 用途 |
|--------|------|
| `InputManager` | 集中处理输入，发送 `event_attack`、`event_interact`、`event_pause` 信号 |
| `UtilManager` | 工具函数：`get_normalized_dir()`、`get_dir_index()` |
| `LevelManager` | 场景切换，`load_new_level(path, door_id)`，追踪 `current_tilemap_bounds` |
| `PlayerManager` | 玩家单例，管理玩家实例、HP、生成位置 |
| `SaveManager` | 存档系统，JSON 格式保存到 `user://save.sav` |
| `PlayerHud` | 玩家状态/心形血条 UI |
| `SceneTransition` | 场景切换时的淡入淡出效果 |
| `PauseMenu` | 暂停菜单 |

### 角色系统 (Common/)

**基类** (`Common/Scripts/`):
- `CommonCharacter` - 抽象基类，继承 `CharacterBody2D`。提供 `hp`、`invulnerable`、`cardinal_direction`、`direction` 属性。方法：`pursuit_other_character()`、`set_direction()`、`update_animation()`、`being_hurted()`、`make_invulnerable()`
- `CommonStateMachine` - 状态机，管理 `states[]` 数组。处理 `event_attack` 和 `event_interact` 信号
- `CommonState` - 抽象状态类，包含 `enter()`、`exit()`、`_process_()`、`_physics_process_()` 方法，可选 `next_state` 属性用于状态转换
- `CommonVar` - 常量类：`AnimType.ACTION/EFFECT` 枚举、`CHARACTER_DIR` 方向数组

**玩家** (`Common/Components/Player/`):
- 继承 `CommonCharacter`，类名为 `Player`
- 使用 `PlayerStateMachine`，包含状态：`player_state_idle`、`player_state_walk`、`player_state_attack`、`player_state_stun`
- 操作：方向键移动，Z 攻击，F 互动，Esc 暂停

**敌人** (`Enemies/`):
- `Enemy` 继承 `CommonCharacter`，使用 `EnemyStateMachine`
- 敌人类型：`Goblin/`（哥布林）、`Slime/`（史莱姆）
- 视野检测通过 `vision_area.gd` 实现

### 战斗系统 (Common/Scenes/)

- `HitBox` (Area2D) - 造成伤害，通过 `value` 和 `hit_desc` 属性配置。无信号发射，调用 `_hurt_box.hit_valid(self)`
- `HurtBox` (Area2D) - 接收伤害，发送 `being_hurted(hit_box)` 信号
- 伤害流程：HitBox →（碰撞）→ HurtBox → `hit_valid()` → `being_hurted.emit()` → Character 的 `being_hurted()` 处理函数

### 物品系统

- `ItemData` (Resource) - 物品定义，包含 `name`、`description`、`texture`、`effects[]`
- `ItemEffect` - 物品效果基类（如 `ItemEffectHeal`）
- `SlotData` (Resource) - 单个物品槽，包含 `item_data` 和 `quantity`
- `InventoryData` (Resource) - 物品槽容器 `slots[]`。方法：`add_item()`、`get_save_data()`、`parse_save_data()`
- `ItemPickUp` - 世界中的可拾取物品，玩家走过即拾取

### 场景系统

- `LevelTranstion` (Area2D) - 场景间的传送门。属性：`level`（场景路径）、`id`（门标识）、`side`（LEFT/RIGHT/TOP/BOTTOM）、`size`
- `LevelManager.prev_door_id` - 用于场景切换后将玩家放置到正确的生成点
- 场景：`Levels/Area01/`（户外）、`Levels/Dungenon01/`（地下城）

### 可交互物体

- `TreasureChest` - 互动打开，存储 `ItemData`，使用 `PersistenDataHandler` 追踪是否已打开（跨存档持久化）
- `PersistenDataHandler` - 节点，通过路径命名在 `SaveManager.persistence[]` 中存储布尔值

### 物理层

```
层 1: Player（玩家）
层 2: InteractiveEle（可交互元素）
层 3: PlayerInteraction（玩家互动）
层 5: Walls（墙壁）
层 9: Enemy（敌人）
层 10: Plants（植物）
```

## 关键模式

### 状态机模式
状态是状态机的 `Node` 子节点。每个状态实现 `enter()`、`exit()`、`_process_()`、`_physics_process_()`。在 `_process_()` 中返回 `next_state` 或 `null` 来切换状态。

### 物品/效果模式
物品拥有 `effects: Array[ItemEffect]`。`ItemData.use()` 遍历并调用每个效果的 `e.use()`。

### 存档数据路径
`SaveManager.add_persistent_value(value)` / `check_persistent_value(value)` - 存储任意布尔标记，跨存档持久化，例如"某处的宝箱已打开"。

### 动画命名规范
动画遵循 `{状态}_{方向}` 模式，方向值为 "down"、"up" 或 "side"（来自 `get_anim_direction()`）。