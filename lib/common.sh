#!/usr/bin/env bash
# Shared helpers for bash-toolbox CLI scripts.

TOOLBOX_VERSION="0.2.0"
TB_LOG_LEVEL="info"
TB_NO_COLOR=0

if [[ -t 1 ]]; then
  TB_COLOR_RED=$'\033[31m'
  TB_COLOR_YELLOW=$'\033[33m'
  TB_COLOR_GREEN=$'\033[32m'
  TB_COLOR_BLUE=$'\033[34m'
  TB_COLOR_RESET=$'\033[0m'
else
  TB_COLOR_RED=""
  TB_COLOR_YELLOW=""
  TB_COLOR_GREEN=""
  TB_COLOR_BLUE=""
  TB_COLOR_RESET=""
fi

_tb_color() {
  local code=$1
  shift
  if (( TB_NO_COLOR == 1 )); then
    printf '%s\n' "$*"
  else
    printf '%s%s%s\n' "$code" "$*" "$TB_COLOR_RESET"
  fi
}

log_debug() {
  [[ "$TB_LOG_LEVEL" == "debug" ]] || return 0
  _tb_color "$TB_COLOR_BLUE" "[DEBUG] $*" >&2
}

log_info() {
  [[ "$TB_LOG_LEVEL" == "quiet" ]] && return 0
  _tb_color "$TB_COLOR_GREEN" "[INFO] $*" >&2
}

log_warn() {
  _tb_color "$TB_COLOR_YELLOW" "[WARN] $*" >&2
}

log_error() {
  _tb_color "$TB_COLOR_RED" "[ERROR] $*" >&2
}

die() {
  log_error "$*"
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || die "Required command not found: $1"
}

tb_parse_common_flags() {
  export TB_SHOW_HELP=0
  TB_POSITIONAL=()
  while (($#)); do
    case "$1" in
      -h|--help)
        export TB_SHOW_HELP=1
        ;;
      -q|--quiet)
        TB_LOG_LEVEL="quiet"
        ;;
      -v|--verbose)
        TB_LOG_LEVEL="debug"
        ;;
      --no-color)
        TB_NO_COLOR=1
        ;;
      --version)
        printf 'bash-toolbox %s\n' "$TOOLBOX_VERSION"
        exit 0
        ;;
      --)
        shift
        while (($#)); do
          TB_POSITIONAL+=("$1")
          shift
        done
        break
        ;;
      -*)
        die "Unknown flag: $1"
        ;;
      *)
        TB_POSITIONAL+=("$1")
        ;;
    esac
    shift
  done
}
