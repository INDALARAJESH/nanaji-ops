module "sns_email_stevin" {
  source         = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sns/email-subscription?ref=aws-sns-email-subscription-v2.0.0"
  sns_topic_name = "stevin_alert"
  email          = "stevin.chacko@chownow.com"
}

module "sns_email_josh" {
  source         = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sns/email-subscription?ref=aws-sns-email-subscription-v2.0.0"
  sns_topic_name = "joshc_alert"
  email          = "josh.chapman@chownow.com"
}

module "sns_email_jordan" {
  source         = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sns/email-subscription?ref=aws-sns-email-subscription-v2.0.0"
  sns_topic_name = "jordam_alert"
  email          = "jordan.moritz@chownow.com"
}

module "sns_email_dataeng_team_alert_stevin" {
  source         = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sns/email-subscription?ref=aws-sns-email-subscription-v2.0.0"
  sns_topic_name = "dataeng_team_alert"
  email          = "stevin.chacko@chownow.com"
}

module "sns_email_data_eng_alert_josh" {
  source         = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sns/email-subscription?ref=aws-sns-email-subscription-v2.0.0"
  sns_topic_name = "dataeng_team_alert"
  email          = "josh.chapman@chownow.com"
}

module "sns_email_dataeng_team_alert_jordan" {
  source         = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sns/email-subscription?ref=aws-sns-email-subscription-v2.0.0"
  sns_topic_name = "dataeng_team_alert"
  email          = "jordan.moritz@chownow.com"
}
