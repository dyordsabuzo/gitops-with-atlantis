resource "aws_ecr_repository" "ecr" {
  name = "ps-custom-atlantis"
}

resource "docker_registry_image" "image" {
  name = "${aws_ecr_repository.ecr.repository_url}:${data.external.command.result.sha}"

  build {
    context = "${path.cwd}/"
  }
}
