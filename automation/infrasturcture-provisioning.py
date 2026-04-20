import subprocess
import os
import sys
TERRAFORM_DIR = "./terraform"
def run(args):
    cmd = ["terraform"] + args
    print(f"Running: {' '.join(cmd)}")
    result = subprocess.run(cmd, cwd=TERRAFORM_DIR, text=True)
    if result.returncode != 0:
        print("Command failed!")
        sys.exit(1)
def init():
    run(["init"])
def validate():
    run(["validate"])
def plan():
    run(["plan", "-out=tfplan"])
def apply():
    run(["apply", "-auto-approve", "tfplan"])
def destroy():
    run(["destroy", "-auto-approve"])
def provision():
    init()
    validate()
    plan()
    apply()
    print("Done! Infrastructure provisioned.")
# ── Run ──────────────────────────────────
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python terraform_automation.py [provision|plan|apply|destroy|validate]")
        sys.exit(1)
    action = sys.argv[1]
    actions = {
        "provision": provision,
        "plan":      plan,
        "apply":     apply,
        "destroy":   destroy,
        "validate":  validate,
    }
if action not in actions:
        print(f"Unknown action: {action}")
        sys.exit(1)
actions[action]()
