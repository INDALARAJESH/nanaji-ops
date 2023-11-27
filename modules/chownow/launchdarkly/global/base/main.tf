module "chownow_reader_role" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/launchdarkly/role?ref=ld-role-v2.1.0"

  id          = "cn-reader"
  name        = "ChowNow Reader"
  description = "Base custom role that allows read only access"

  # https://docs.launchdarkly.com/home/members/example-policies#template-built-in-reader-role-replication
  policy_statements = [
    {
      "resources" : [
        "proj/*"
      ],
      "actions" : [
        "*"
      ],
      "effect" : "deny"
    },
    {
      "resources" : [
        "proj/*:env/*"
      ],
      "actions" : [
        "*"
      ],
      "effect" : "deny"
    },
    {
      "resources" : [
        "proj/*:metric/*"
      ],
      "actions" : [
        "*"
      ],
      "effect" : "deny"
    },
    {
      "resources" : [
        "proj/*:env/*:flag/*"
      ],
      "actions" : [
        "*"
      ],
      "effect" : "deny"
    },
    {
      "resources" : [
        "proj/*:env/*:segment/*"
      ],
      "actions" : [
        "*"
      ],
      "effect" : "deny"
    },
    {
      "resources" : [
        "proj/*:env/*:destination/*"
      ],
      "actions" : [
        "*"
      ],
      "effect" : "deny"
    },
    {
      "resources" : [
        "proj/*:env/*:user/*"
      ],
      "actions" : [
        "*"
      ],
      "effect" : "deny"
    },
    {
      "resources" : [
        "member/*"
      ],
      "actions" : [
        "*"
      ],
      "effect" : "deny"
    },
    {
      "resources" : [
        "member/*:token/*"
      ],
      "actions" : [
        "*"
      ],
      "effect" : "deny"
    },
    {
      "resources" : [
        "role/*"
      ],
      "actions" : [
        "*"
      ],
      "effect" : "deny"
    },
    {
      "resources" : [
        "integration/*"
      ],
      "actions" : [
        "*"
      ],
      "effect" : "deny"
    },
    {
      "resources" : [
        "webhook/*"
      ],
      "actions" : [
        "*"
      ],
      "effect" : "deny"
    },
    {
      "resources" : [
        "code-reference-repository/*"
      ],
      "actions" : [
        "*"
      ],
      "effect" : "deny"
    },
    {
      "resources" : [
        "acct"
      ],
      "actions" : [
        "*"
      ],
      "effect" : "deny"
    }
  ]
}

module "qa_non_prod_writer_role" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/launchdarkly/role?ref=ld-role-v2.1.0"

  id          = "qa-non-prod-writer"
  name        = "QA Non-Prod Writer"
  description = "Allows write access to all lower environments except production"

  policy_statements = [
    {
      "resources" : [
        "proj/*:env/production"
      ],
      "actions" : [
        "*"
      ],
      "effect" : "deny"
    },
    {
      "resources" : [
        "proj/*:metric/*"
      ],
      "actions" : [
        "*"
      ],
      "effect" : "deny"
    },
    {
      "resources" : [
        "proj/*:env/production:flag/*"
      ],
      "actions" : [
        "*"
      ],
      "effect" : "deny"
    },
    {
      "resources" : [
        "proj/*:env/production:segment/*"
      ],
      "actions" : [
        "*"
      ],
      "effect" : "deny"
    },
    {
      "resources" : [
        "proj/*:env/production:destination/*"
      ],
      "actions" : [
        "*"
      ],
      "effect" : "deny"
    },
    {
      "resources" : [
        "proj/*:env/production:user/*"
      ],
      "actions" : [
        "*"
      ],
      "effect" : "deny"
    },
    {
      "resources" : [
        "member/*"
      ],
      "actions" : [
        "*"
      ],
      "effect" : "deny"
    },
    {
      "resources" : [
        "member/*:token/*"
      ],
      "actions" : [
        "*"
      ],
      "effect" : "deny"
    },
    {
      "resources" : [
        "role/*"
      ],
      "actions" : [
        "*"
      ],
      "effect" : "deny"
    },
    {
      "resources" : [
        "integration/*"
      ],
      "actions" : [
        "*"
      ],
      "effect" : "deny"
    },
    {
      "resources" : [
        "webhook/*"
      ],
      "actions" : [
        "*"
      ],
      "effect" : "deny"
    },
    {
      "resources" : [
        "code-reference-repository/*"
      ],
      "actions" : [
        "*"
      ],
      "effect" : "deny"
    },
    {
      "resources" : [
        "acct"
      ],
      "actions" : [
        "*"
      ],
      "effect" : "deny"
    },
    {
      "resources" : [
        "proj/*:env/*:flag/*"
      ],
      "actions" : [
        "bypassRequiredApproval"
      ],
      "effect" : "deny"
    },
    # Base writer permissions below taken from:
    # https://docs.launchdarkly.com/home/members/example-policies#template-built-in-writer-role-replication
    {
      "effect" : "allow",
      "actions" : ["*"],
      "resources" : ["proj/*"]
    },
    {
      "effect" : "allow",
      "actions" : ["*"],
      "resources" : ["proj/*:env/*"]
    },
    {
      "effect" : "allow",
      "actions" : ["*"],
      "resources" : ["proj/*:metric/*"]
    },
    {
      "effect" : "allow",
      "actions" : ["*"],
      "resources" : ["proj/*:env/*:flag/*"]
    },
    {
      "effect" : "allow",
      "actions" : ["*"],
      "resources" : ["proj/*:env/*:segment/*"]
    },
    {
      "effect" : "allow",
      "actions" : ["*"],
      "resources" : ["proj/*:env/*:destination/*"]
    },
    {
      "effect" : "allow",
      "actions" : ["*"],
      "resources" : ["proj/*:env/*:user/*"]
    },
    {
      "effect" : "allow",
      "actions" : ["*"],
      "resources" : ["member/*:token/*"]
    },
    {
      "effect" : "allow",
      "actions" : ["*"],
      "resources" : ["integration/*"]
    },
    {
      "effect" : "allow",
      "actions" : ["*"],
      "resources" : ["webhook/*"]
    },
    {
      "effect" : "allow",
      "actions" : ["*"],
      "resources" : ["code-reference-repository/*"]
    }
  ]
}

module "limited_admin_role" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/launchdarkly/role?ref=ld-role-v2.1.0"

  id          = "limited-admin"
  name        = "Limited Admin"
  description = "Limited admin access to manage most resources, team memberships, and individual role attachment to users"

  policy_statements = [
    {
      "effect" : "deny",
      "actions" : [
        "updateDescription",
        "createRole",
        "updatePolicy",
        "updateName",
        "updateBasePermissions",
        "deleteRole"
      ],
      "resources" : ["role/*"]
    },
    {
      "effect" : "deny",
      "actions" : [
        "createMember",
        "deleteMember",
      ],
      "resources" : ["member/*"]
    },
    {
      "effect" : "deny",
      "actions" : ["*"],
      "resources" : ["acct"]
    },
    {
      "effect" : "deny",
      "actions" : [
        "createTeam",
        "deleteTeam",
        "updateTeamDescription",
        "updateTeamName"
      ],
      "resources" : ["team/*"]
    },
    # Base admin permissions below taken from:
    # https://docs.launchdarkly.com/home/members/example-policies#built-in-admin-role
    {
      "effect" : "allow",
      "actions" : ["*"],
      "resources" : ["proj/*"]
    },
    {
      "effect" : "allow",
      "actions" : ["*"],
      "resources" : ["proj/*:env/*"]
    },
    {
      "effect" : "allow",
      "actions" : ["*"],
      "resources" : ["proj/*:metric/*"]
    },
    {
      "effect" : "allow",
      "actions" : ["*"],
      "resources" : ["member/*"]
    },
    {
      "effect" : "allow",
      "actions" : ["*"],
      "resources" : ["team/*"]
    },
    {
      "effect" : "allow",
      "actions" : ["*"],
      "resources" : ["member/*:token/*"]
    },
    {
      "effect" : "allow",
      "actions" : ["*"],
      "resources" : ["role/*"]
    },
    {
      "effect" : "allow",
      "actions" : ["*"],
      "resources" : ["proj/*:env/*:flag/*"]
    },
    {
      "effect" : "allow",
      "actions" : ["*"],
      "resources" : ["integration/*"]
    },
    {
      "effect" : "allow",
      "actions" : ["*"],
      "resources" : ["proj/*:env/*:segment/*"]
    },
    {
      "effect" : "allow",
      "actions" : ["*"],
      "resources" : ["webhook/*"]
    },
    {
      "effect" : "allow",
      "actions" : ["*"],
      "resources" : ["proj/*:context-kind/*"]
    },
    {
      "effect" : "allow",
      "actions" : ["*"],
      "resources" : ["code-reference-repository/*"]
    },
    {
      "effect" : "allow",
      "actions" : ["*"],
      "resources" : ["proj/*:env/*:destination/*"]
    },
    {
      "effect" : "allow",
      "actions" : ["*"],
      "resources" : ["acct"]
    }
  ]
}

module "flag_linker_role" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/launchdarkly/role?ref=ld-role-v2.1.0"

  id          = "flag-linker"
  name        = "Flag Linker"
  description = "Allows linking and unlinking of LD flags to JIRA tickets"

  policy_statements = [
    {
      "effect" : "allow",
      "resources" : [
        "proj/*:env/*:flag/*"
      ],
      "actions" : [
        "createFlagLink",
        "updateFlagLink",
        "deleteFlagLink",
        "updateFlagCustomProperties"
      ]
    }
  ]
}

resource "launchdarkly_team" "qa" {
  key         = "qa"
  name        = "QA"
  description = "QA team"

  lifecycle {
    ignore_changes = [member_ids, maintainers, custom_role_keys]
  }
}

resource "launchdarkly_team" "eng_leads" {
  key         = "eng-leads"
  name        = "Engineering Leads"
  description = "Engineering leads that can manage team memberships and have limited admin access"

  lifecycle {
    ignore_changes = [member_ids, maintainers, custom_role_keys]
  }
}
