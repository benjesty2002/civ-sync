import os
import platform
from time import sleep


DEFAULT_PATHS={
    "S3": "civ6-saves",
    "Windows": "civ6-saves",
    "Darwin": "~/Library/Application\ Support/Sid\ Meier\\'s\ Civilization\ VI/Saves",
}

def run_command(command):
    print(command)
    os.system(command)

class S3SyncManager:
    def __init__(self, local_path: str = "CIV_LOCAL_SAVES", s3_path: str = "CIV_S3_SAVES") -> None:
        self.local_path = os.environ.get(local_path, local_path)
        self.s3_path = os.environ.get(s3_path, s3_path)

    def sync_up(self):
        run_command(f"aws s3 sync {self.local_path} s3://{self.s3_path}")

    def sync_down(self):
        run_command(f"aws s3 sync s3://{self.s3_path} {self.local_path}")

    def sync(self):
        self.sync_up()
        self.sync_down()
    
    def sleep(self):
        interval = int(os.environ.get("CIV_SAVE_POLL_INTERVAL", 60))
        print(f"Sleeping for {interval} seconds")
        sleep(interval)
        

if __name__ == "__main__":
    local_path = os.environ.get("CIV_LOCAL_SAVES", DEFAULT_PATHS[platform.system()])
    s3_path = os.environ.get("CIV_S3_SAVES", DEFAULT_PATHS["S3"])
    ssm = S3SyncManager(local_path=local_path, s3_path=s3_path)
    while True:
        try:
            ssm.sync()
            ssm.sleep()
        except:
            print("Sync failed")
            ssm.sleep()
