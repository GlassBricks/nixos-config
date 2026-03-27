# Backup Commands

Repository: `rclone:gdrive:restic-backup`
pw file: `~/.config/restic/password`

All commands below assume:

```bash
export RESTIC_REPOSITORY="rclone:gdrive:restic-backup"
export RESTIC_PASSWORD_FILE="$HOME/.config/restic/password"
```

## Setup (one-time)

```bash
rclone config            # create remote named "gdrive", type "drive"
mkdir -p ~/.config/restic
head -c 32 /dev/urandom | base64 > ~/.config/restic/password
chmod 600 ~/.config/restic/password
```

## Service

```bash
sudo systemctl start restic-backups-documents   # run now
sudo systemctl status restic-backups-documents   # check status
journalctl -u restic-backups-documents -e        # view logs
```

## Snapshots

```bash
restic snapshots          # list all
restic snapshots --latest 5
restic diff <id1> <id2>   # compare two snapshots
```

## Browse and Restore

```bash
restic ls latest                              # list files in latest snapshot
restic mount /mnt/restore                     # browse as filesystem (ctrl-c to unmount)
restic restore latest --target /tmp/restore   # restore everything
restic restore latest --target /tmp/restore --include "path/to/file"  # restore specific path
```

## Maintenance

```bash
restic check              # verify repo integrity
restic prune              # remove unreferenced data (auto-runs after backup via pruneOpts)
restic stats              # repo size
```
