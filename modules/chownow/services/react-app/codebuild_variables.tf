variable "codebuild_source_location" {
  description = "Source repo for codebuild"
  default     = "https://github.com/ChowNow/chownow-web.git"
}

variable "codebuild_buildspec_path" {
  description = "Path to buildspec"
}

variable "codebuild_image" {
  # Front end started out on Ubuntu
  description = "Codebuild container image"
  default     = "aws/codebuild/standard:7.0"
}

variable "codebuild_environment_variables" {
  description = "Additional vars, to be merged with standard ones"
}
