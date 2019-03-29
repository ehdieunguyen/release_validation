workflow "ValidateChangelog" {
  on = "pull_request"
  resolves = ["Check Changlog"]
}

action "Check Changlog" {
  uses = "docker://dieunb/release_testing:latest"
  secrets = ["GITHUB_TOKEN"]
}
