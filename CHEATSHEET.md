# Bash Toolbox Cheatsheet

## Purpose
Quick reminder of what each tool is for and when to use it.

- `backup_dir.sh`  
  Use when you need a fast, timestamped archive backup of a directory.

- `rotate_logs.sh`  
  Use when log files grow continuously and you want compressed retention.

- `json_pretty.sh`  
  Use when JSON output is minified/hard to read and needs formatting.

- `ping_sweep.sh`  
  Use when checking host reachability across a small subnet safely.

- `disk_report.sh`  
  Use when troubleshooting storage usage and identifying large folders/files.

## Fast examples

```bash
./bin/backup_dir.sh ./data ./backups
./bin/rotate_logs.sh ./logs 5
./bin/json_pretty.sh ./payload.json
./bin/ping_sweep.sh 10.0.0 1 10 0.2
./bin/disk_report.sh .
```
