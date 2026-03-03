#!/bin/bash
# 每日学习总结定时任务
# 每天晚上12点运行，提取技术知识和经验教训

WORKSPACE="/root/.openclaw/workspace"
MEMORY_FILE="$WORKSPACE/MEMORY.md"
TODAY=$(date +%Y-%m-%d)
LOG_FILE="$WORKSPACE/memory/$TODAY.md"
SUMMARY_FILE="$WORKSPACE/memory/daily_summary_$TODAY.md"

# 确保目录存在
mkdir -p "$WORKSPACE/memory"

echo "=== 每日学习总结 - $TODAY ===" > "$SUMMARY_FILE"
echo "" >> "$SUMMARY_FILE"

# 检查今日日志是否存在
if [ ! -f "$LOG_FILE" ]; then
    echo "📝 今日日志文件不存在，创建空文件" >> "$SUMMARY_FILE"
    touch "$LOG_FILE"
fi

# 提取今日的技术知识点
echo "## 🔍 技术知识点" >> "$SUMMARY_FILE"
grep -i -E "(技术|安装|配置|解决|问题|错误|成功)" "$LOG_FILE" 2>/dev/null | head -20 >> "$SUMMARY_FILE"
echo "" >> "$SUMMARY_FILE"

# 提取经验教训
echo "## 💡 经验教训" >> "$SUMMARY_FILE"
grep -i -E "(教训|注意|重要|记住|避免)" "$LOG_FILE" 2>/dev/null | head -10 >> "$SUMMARY_FILE"
echo "" >> "$SUMMARY_FILE"

# 提取重要操作
echo "## 🛠️ 重要操作" >> "$SUMMARY_FILE"
grep -i -E "(安装|配置|命令|创建|删除)" "$LOG_FILE" 2>/dev/null | head -15 >> "$SUMMARY_FILE"
echo "" >> "$SUMMARY_FILE"

# 总结今日新增的技能/工具
echo "## 🎯 新增能力" >> "$SUMMARY_FILE"
grep -i -E "(技能|工具|已安装|配置成功)" "$LOG_FILE" 2>/dev/null | head -10 >> "$SUMMARY_FILE"
echo "" >> "$SUMMARY_FILE"

# 添加到 MEMORY.md
if [ -f "$MEMORY_FILE" ]; then
    echo "" >> "$MEMORY_FILE"
    echo "## 📅 $TODAY - 每日更新" >> "$MEMORY_FILE"
    echo "- 新增技能/工具: $(grep -c '已安装' "$LOG_FILE" 2>/dev/null || echo 0) 个" >> "$MEMORY_FILE"
    echo "- 技术要点: $(grep -c '技术' "$LOG_FILE" 2>/dev/null || echo 0) 条" >> "$MEMORY_FILE"
    echo "- 经验教训: $(grep -c '教训' "$LOG_FILE" 2>/dev/null || echo 0) 条" >> "$MEMORY_FILE"
fi

echo "✅ 每日学习总结完成: $SUMMARY_FILE" >> "$SUMMARY_FILE"

# 输出结果
cat "$SUMMARY_FILE"
