#!/usr/bin/env bash
# check_env.sh — 开发环境自检脚本
# Copyright (c) 2026 秦晓望. Released under the MIT License (see scripts/LICENSE).
# 用途：检查 Node.js / npm / git / Python / Docker 等基础环境是否就绪。
set -u

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

pass() { printf "${GREEN}✔ %s${NC}\n" "$1"; }
warn() { printf "${YELLOW}⚠ %s${NC}\n" "$1"; }
fail() { printf "${RED}✘ %s${NC}\n" "$1"; }

check_cmd() {
  local name="$1" min="$2"
  if command -v "$name" >/dev/null 2>&1; then
    local ver
    ver=$("$name" --version 2>/dev/null | head -n 1)
    pass "$name $ver"
  else
    fail "$name 未安装（要求 >= $min）"
  fi
}

echo "== 基础工具 =="
check_cmd git 2.30.0
check_cmd node 20.0.0
check_cmd npm 10.0.0
check_cmd python3 3.11.0
check_cmd docker 24.0.0

echo ""
echo "== Node 与 npm 一致性 =="
if command -v node >/dev/null 2>&1 && command -v npm >/dev/null 2>&1; then
  printf "  node %s / npm %s\n" "$(node -v)" "$(npm -v)"
fi

echo ""
echo "== 自检完成：如有 ✘ 项，请先安装对应工具再继续 =="
