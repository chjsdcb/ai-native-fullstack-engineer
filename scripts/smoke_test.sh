#!/usr/bin/env bash
# smoke_test.sh — 冒烟测试：项目启动后执行基础健康检查
# Copyright (c) 2026 秦晓望. Released under the MIT License (see scripts/LICENSE).
# 用法：./smoke_test.sh [BASE_URL]   （默认 http://localhost:3000）
set -uo pipefail

BASE_URL="${1:-http://localhost:3000}"
TIMEOUT="${TIMEOUT:-5}"

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

pass_count=0
fail_count=0

check_url() {
  local path="$1" expect="${2:-200}"
  local code
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time "$TIMEOUT" "$BASE_URL$path" 2>/dev/null || echo "000")
  if [ "$code" = "$expect" ]; then
    printf "${GREEN}✔ %s → %s${NC}\n" "$path" "$code"
    pass_count=$((pass_count + 1))
  else
    printf "${RED}✘ %s → %s（期望 %s）${NC}\n" "$path" "$code" "$expect"
    fail_count=$((fail_count + 1))
  fi
}

echo "== 冒烟测试: $BASE_URL =="
check_url "/" 200
check_url "/api/health" 200
check_url "/api/docs" 200

echo ""
if [ "$fail_count" -eq 0 ]; then
  printf "${GREEN}✔ 全部通过（%s 项）${NC}\n" "$pass_count"
  exit 0
else
  printf "${RED}✘ %s 项失败，请检查服务日志${NC}\n" "$fail_count"
  exit 1
fi
