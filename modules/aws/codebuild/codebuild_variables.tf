variable "codebuild_description" {
  description = "CodeBuild project description"
}

variable "codebuild_timeout" {
  description = "CodeBuild build timeout"
  default     = "15"
}

variable "codebuild_artifact_type" {
  description = "CodeBuild Artifact Type (NO_ARTIFACTS|S3)" # NO_ARTIFACTS OR S3
  default     = "NO_ARTIFACTS"
}

variable "codebuild_artifact_location" {
  description = "CodeBuild Artifact Location (only for S3)"
  default     = ""
}

variable "codebuild_artifact_override_artifact_name" {
  description = "Use semantic versioning for artifacts? (This is required for React-app deployments)"
  default     = false
}

variable "codebuild_artifact_encryption_disabled" {
  description = "Disable encryption? Encryption on (default) breaks static sites"
  default     = false
}

variable "codebuild_compute_type" {
  description = "CodeBuild Instance Size" # SMALL, MEDIUM, LARGE, 2XLARGE
  default     = "BUILD_GENERAL1_SMALL"
}

variable "codebuild_image" {
  description = "CodeBuild Image"
  default     = "aws/codebuild/amazonlinux2-x86_64-standard:2.0"
}

variable "codebuild_environment_variables" {
  description = "CodeBuild environment variables"
}

variable "codebuild_log_retention" {
  description = "Cloudwatch codebuild log retention"
  default     = "30"
}

variable "codebuild_source" {
  description = "Codebuild source" #CODECOMMIT, CODEPIPELINE, GITHUB, GITHUB_ENTERPRISE, BITBUCKET, S3 or NO_SOURCE
  default     = "CODEBUILD"
}

variable "codebuild_source_location" {
  description = "Location of source" # The location of the source code from git or s3
  default     = ""
}

variable "codebuild_buildspec_path" {
  default = ""
}

variable "aux_iam_policy" {
  description = "auxiliary rendered codebuild iam policy"
  default     = ""
}
