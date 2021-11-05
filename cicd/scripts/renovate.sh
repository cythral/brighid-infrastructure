#!/bin/bash

decrypt()
{
    ciphertext=$1
    tempfile=$(mktemp)

    echo $ciphertext | base64 --decode > $tempfile
    echo $(aws kms decrypt --ciphertext-blob fileb://$tempfile --query Plaintext --output text | base64 --decode)
    rm $tempfile
}

CWD=$(dirname ${BASH_SOURCE[0]:-0})
ENCRYPTED_GITHUB_TOKEN=$1

export RENOVATE_TOKEN=$(decrypt $ENCRYPTED_GITHUB_TOKEN)
export LOG_LEVEL=debug

renovate \
    --binary-source docker \
    --docker-user root \
    --autodiscover \
    --automerge \
    --git-author "Brighid <52382196+brighid-bot@users.noreply.github.com>"