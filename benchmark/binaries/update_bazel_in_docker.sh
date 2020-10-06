#!/usr/bin/env bash

set -o nounset
set -o pipefail
set -o errexit

sudo apt install --yes curl gnupg
curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor > bazel.gpg
sudo mv bazel.gpg /etc/apt/trusted.gpg.d/
echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list

sudo apt update && sudo apt install --yes bazel 

export PATH="/usr/bin/bazel:${PATH}"
sudo mv /usr/local/bin/bazel /usr/local/bin/bazel.bak
bash 