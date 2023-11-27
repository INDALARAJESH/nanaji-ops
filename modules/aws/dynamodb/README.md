### General

* Description: A module to help create DynamoDB Table
* Created By: Allen Dantes, Sebastien Plisson
* Module Dependencies: `None`

![aws-dynamodb](https://github.com/ChowNow/ops-tf-modules/workflows/aws-dynamodb/badge.svg)

### Usage

```

module "dynamodb" {
  source          = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/dynamodb?ref=aws-dynamodb-v2.0.5"

  name            = "${var.service}-dynamodb-${var.env}"
  env             = var.env
  hash_key        = "key"
  service         = var.service
  attribute_list = [
    {
      name  = "attribute"
      type  = "S"
    }
  ]
}

```

#### Inputs

| Variable Name                   | Description                                  | Options                                           |  Type   | Required? | Notes        |
| ------------------------------- | ------------------------------------------   | ------------------------------------------------- | ------- | --------- | ------------ |
| service                         | Name of service                              | N/A                                               | string  | Yes       | N/A          |
| env                             | environment/stage                            | uat,qa,stg,prod,ncp                               | string  | Yes       | N/A          |
| billing_mode                    | Controls billing for read/write throughput   | PROVISIONED or PAY_PER_REQUEST                    | string  | No        | N/A          |
| autoscaling_enabled             | Controls whether or not to enable autoscaling| (Default: false)                                  | boolean | No        | N/A          |
| autoscale_read_target_value     | The target percentage of read units          | (Default: 70 when PROVISIONED/autoscaling_enabled)| string  | No        | N/A          |
| autoscale_min_read_capacity     | The min number of read units for this table  | (Default: 20 when PROVISIONED)                    | string  | No        | N/A          |
| autoscale_max_read_capacity     | The max number of read units for this table  | (Default: 50 when PROVISIONED/autoscaling_enabled)| string  | No        | N/A          |
| autoscale_write_target_value    | The target percentage of write units         | (Default: 70 when PROVISIONED/autoscaling_enabled)| string  | No        | N/A          |
| autoscale_min_write_capacity    | The min number of write units for this table | (Default: 20 when PROVISIONED)                    | string  | No        | N/A          |
| autoscale_max_write_capacity    | The max number of write units for this table | (Default: 50 when PROVISIONED/autoscaling_enabled)| string  | No        | N/A          |
| hash_key                        | The name of the hash key in the index        | (ex. CompanyID)                                   | string  | Yes       | N/A          |
| range_key                       | The name of the range key                    | (Default: *blank*)                                | string  | No        | N/A          |
| attribute_list                  | Table attribute list                         | (ex. CompanyId type S)                            | list    | Yes       | N/A          |
| enable_streams                  | Enable log streams                           | (Default: true)                                   | boolean | No        | N/A          |
| stream_view_type                | Stream view type                             | (Default: NEW_AND_OLD_IMAGES)                     | string  | No        | N/A          |
| enable_encryption               | Enable encryption                            | (Default: true)                                   | boolean | No        | N/A          |
| enable_point_in_time_recovery   | Enable Recovery                              | (Default: false)                                  | boolean | No        | N/A          |
| ttl_name                        | TTL Name                                     | (Default: *blank*)                                | string  | No        | N/A          |
| ttl_enabled                     | Enabled TTL                                  | (Default: false)                                  | boolean | No        | N/A          |
| global_secondary_index          | Secondary index attributes                   |                                                   | list    |  No       |              |

#### Outputs

none

#### Notes
