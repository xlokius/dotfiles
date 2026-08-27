#!/bin/zsh
# ============================================================
# Custom MOTD - Arch Linux
# ============================================================
# Colores
RESET='\033[0m'
BOLD='\033[1m'
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
RED='\033[31m'
GRAY='\033[90m'

# Información básica
HOSTNAME=$(cat /etc/hostname 2>/dev/null || echo "unknown")
KERNEL=$(uname -r)
ARCH=$(uname -m)
UPTIME=$(uptime -p)

# CPU
CPU_MODEL=$(lscpu | awk -F: '/Model name/ {gsub(/^[ \t]+/, "", $2); print $2; exit}')
CPU_CORES=$(nproc)

# Temperatura CPU
if command -v sensors >/dev/null 2>&1; then
  TEMP=$(sensors 2>/dev/null | grep -m1 -oP '(?<=Package id 0:)\s*\+\K[0-9.]+')
  [ -n "$TEMP" ] && TEMP="${TEMP}°C" || TEMP="N/A"
else
  TEMP="N/A"
fi

# RAM
MEM_TOTAL=$(free -h | awk '/^Mem:/ {print $2}')
MEM_USED=$(free -h | awk '/^Mem:/ {print $3}')
MEM_PERCENT=$(free | awk '/^Mem:/ {printf "%.0f", ($3/$2)*100}')

# Swap
SWAP_TOTAL=$(free -h | awk '/^Swap:/ {print $2}')
SWAP_USED=$(free -h | awk '/^Swap:/ {print $3}')

# Disco raíz
DISK=$(df -h / | awk 'NR==2 {print $3 " used / " $2 " (" $5 ")"}')

# IP
IP=$(ip -4 route get 1.1.1.1 2>/dev/null | awk '{print $7; exit}')
[ -z "$IP" ] && IP="N/A"

# Load
LOAD=$(awk '{print $1 " " $2 " " $3}' /proc/loadavg)

# Procesos
PROCESSES=$(ps -e --no-headers | wc -l)

# Fecha
DATE=$(date '+%a %d %b %Y %H:%M:%S %Z')

# Docker
if command -v docker >/dev/null 2>&1; then
  DOCKER_RUNNING=$(docker ps -q 2>/dev/null | wc -l)
  DOCKER_TOTAL=$(docker ps -aq 2>/dev/null | wc -l)
else
  DOCKER_RUNNING="N/A"
  DOCKER_TOTAL="N/A"
fi

# Actualizaciones disponibles
if command -v checkupdates >/dev/null 2>&1; then
  UPDATES=$(checkupdates 2>/dev/null | wc -l)
else
  UPDATES="?"
fi

# ============================================================
# Output
# ============================================================
echo
echo -e "${BOLD}${CYAN}Welcome to Arch Linux${RESET} ${GRAY}(${KERNEL} ${ARCH})${RESET}"
echo
echo -e "${BOLD} System information as of ${DATE}${RESET}"
echo
echo -e " ${CYAN}System:${RESET}      ${HOSTNAME}"
echo -e " ${CYAN}Uptime:${RESET}      ${UPTIME}"
echo -e " ${CYAN}Load:${RESET}        ${LOAD}"
echo -e " ${CYAN}Processes:${RESET}   ${PROCESSES}"
echo -e " ${CYAN}Temp:${RESET}        ${TEMP}"
echo -e " ${CYAN}Disk:${RESET}        ${DISK}"
echo -e " ${CYAN}Memory:${RESET}      ${MEM_USED} / ${MEM_TOTAL} (${MEM_PERCENT}%)"
echo -e " ${CYAN}Swap:${RESET}        ${SWAP_USED} / ${SWAP_TOTAL}"
echo -e " ${CYAN}IPv4:${RESET}        ${IP}"
echo
echo -e " ${CYAN}CPU:${RESET}         ${CPU_MODEL}"
echo -e " ${CYAN}CPU cores:${RESET}   ${CPU_CORES}"
echo -e " ${CYAN}Docker:${RESET}      ${DOCKER_RUNNING} running / ${DOCKER_TOTAL} total"
echo -e " ${CYAN}Updates:${RESET}     ${UPDATES} available"
echo
