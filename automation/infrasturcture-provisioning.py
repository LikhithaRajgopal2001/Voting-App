import subprocess

def deploy_infra():

    print("Initializing Terraform...")
    subprocess.run(["terraform", "init"])

    print("Validating Terraform files...")
    subprocess.run(["terraform", "validate"])

    print("Planning infrastructure changes...")
    subprocess.run(["terraform", "plan"])

    print("Applying infrastructure...")
    subprocess.run(["terraform", "apply", "-auto-approve"])

deploy_infra()