# SAFETY FIRST - A tool for LV management

## Requirements

- Bash 4.x +
- CentOS 7+

## APIs

Interactive menu mode

- `make`
- `make list`
- `make backup`
- `make delete`
- `make restore`

Scripting mode (for more assistance run `--help`)

- `scripts/list.sh --origin <originName (optional)> --prefix <SNAP (optional)>` // Prefix defaults to 'SNAP'
- `scripts/backup.sh --target <volgroup/lvname> --size <500> --prefix <SNAP(optional)>` // Size in MB. Prefix defaults to 'SNAP'
- `scripts/delete.sh --name <volgroup/lvname (optional)> --history <"2015-01-01 00:00:00" (optional)>`
- `scripts/restore.sh --name <volgroup/SNAP_1234567_test>`
