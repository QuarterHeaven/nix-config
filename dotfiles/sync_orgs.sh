#!/bin/bash

# 定义目录路径
# DIR_CLOUDDOCS="/Users/takaobsid/Library/Mobile Documents/com~apple~CloudDocs/orgs"
DIR_CLOUDDOCS="/Users/takaobsid/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/orgs"
DIR_ONEDRIVE="/Users/takaobsid/Library/CloudStorage/OneDrive-MSFT/orgs"

# rsync 参数
RSYNC_OPTS="-azP --exclude '.*/' --exclude '.*' --exclude 'tmp/'"

# 同步函数：从 CloudDocs 到 OneDrive
sync_cloud_to_onedrive() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Syncing CloudDocs to OneDrive..."
    rsync $RSYNC_OPTS "$DIR_CLOUDDOCS/" "$DIR_ONEDRIVE/"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Sync from CloudDocs to OneDrive completed."
}

# 同步函数：从 OneDrive 到 CloudDocs
sync_onedrive_to_cloud() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Syncing OneDrive to CloudDocs..."
    rsync $RSYNC_OPTS "$DIR_ONEDRIVE/" "$DIR_CLOUDDOCS/"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Sync from OneDrive to CloudDocs completed."
}

# 初始同步（可选）
# sync_cloud_to_onedrive
# sync_onedrive_to_cloud

# 使用 fswatch 监控目录变化
/run/current-system/sw/bin/fswatch -0 -r "$DIR_CLOUDDOCS" "$DIR_ONEDRIVE" | while IFS= read -r -d "" event
do
    echo "$(timestamp) - Detected change: $event" >> /tmp/syncorgs.out

    # 获取事件发生的路径
    EVENT_PATH=$(echo "$event" | awk '{print $1}')

    # 使用 case 语句进行通配符匹配
    case "$event" in
        "$DIR_CLOUDDOCS"/*)
            echo "$(timestamp) - Change detected in CloudDocs." >> /tmp/syncorgs.out
            sync_cloud_to_onedrive
            ;;
        "$DIR_ONEDRIVE"/*)
            echo "$(timestamp) - Change detected in OneDrive." >> /tmp/syncorgs.out
            sync_onedrive_to_cloud
            ;;
        *)
            echo "$(timestamp) - Change detected in unknown path: $event" >> /tmp/syncorgs.out
            ;;
    esac
done
