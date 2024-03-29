#!/usr/bin/env bash
set +x

#TRIGGER_PIPELINES=(docker-node docker-ruby docker-fluentd docker-geoip docker-nginx docker-openjdk docker-prometheus docker-php)
RELEASE_NAME=$(buildkite-agent meta-data get release-name || echo "n/a")

# Define release hint for Github release
read -r -d '' release_hint << EOF
It’s common practice to prefix your version names with the letter v. Some good tag names might be v1.0 or v2.3.4.
If the tag isn’t meant for production use, add a pre-release version after the version name. Some good pre-release versions might be v0.2-alpha or v5.9-beta.3.
EOF

set -e


# Master banch before Github release
if [ "$RELEASE_NAME" == "n/a"  -a "$BUILDKITE_BRANCH" == 'master' ]; then
cat <<EOF
steps:
  - label: ':hammer: Run tests'
    command: bin/alpine tests --build
  - wait
  - block: ':github: Release'
    prompt: "Fill out the details for release"
    fields:
      - text: "Release name"
        key: "release-name"
        required: true
        hint: "$release_hint"
      - text: "Describe this release"
        key: "release-notes"
        required: false
        hint: "List of what's changed in this release"
      - select: "Release type"
        key: "release-type"
        default: "draft"
        options:
        - label: "Draft"
          value: "draft"
        - label: "Pre-release"
          value: "pre-release"
        - label: "Release"
          value: "release"
  - command: .buildkite/pipeline.sh | buildkite-agent pipeline upload
    label: ":pipeline: Setup pipeline"
EOF
exit 0
fi

# Master branch after Github release
if [ "$RELEASE_NAME" != "n/a" -a "$BUILDKITE_BRANCH" == 'master' ]; then
cat <<EOF
steps:
  - label: ':github: Release'
    command: .buildkite/release.sh
  - wait
  - label: ':docker: Release on Dockerhub'
    command: bin/alpine release
  - wait
EOF
#for TRIGGER_PIPELINE in ${TRIGGER_PIPELINES[@]}; do
#cat <<EOF
#  - trigger: "$TRIGGER_PIPELINE"
#    label: "Trigger pipeline $TRIGGER_PIPELINE"
#    async: true
#    build:
#      message: "Build triggered after releasing 'bandsintown/alpine' images ($RELEASE_NAME)"
#EOF
#done
exit 0
fi

# Pull Requests
cat <<EOF
steps:
  - label: ':hammer: Run tests'
    command: bin/alpine tests --build
EOF
