{
  "title": "Restaurant Search ETL - ${local_env}",
  "description": "Dashboard for restaurant search etl resources",
  "widgets": [
    {
      "id": 7446456330636892,
      "definition": {
        "title": "Restaurant Search ETL Events",
        "type": "group",
        "show_title": true,
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 5530099399369498,
            "definition": {
              "title": "Event Counter: ${restaurants_event_name}",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "search": {
                        "query": "topic:${restaurants_event_name}"
                      },
                      "data_source": "events",
                      "compute": {
                        "aggregation": "count"
                      },
                      "name": "query1",
                      "indexes": [
                        "*"
                      ],
                      "group_by": []
                    }
                  ]
                }
              ],
              "autoscale": true,
              "precision": 2
            },
            "layout": {
              "x": 1,
              "y": 0,
              "width": 2,
              "height": 2
            }
          }
        ]
      },
      "layout": {
        "x": 0,
        "y": 0,
        "width": 6,
        "height": 3
      }
    },
    {
      "id": 2813242757055476,
      "definition": {
        "title": "Restaurant Search ETL Fetch Lambda",
        "type": "group",
        "show_title": true,
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 2437416842968322,
            "definition": {
              "title": "Succeeded",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">",
                      "palette": "white_on_green",
                      "value": 0
                    },
                    {
                      "comparator": "<",
                      "palette": "white_on_gray",
                      "value": 1
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "sum:aws.states.lambda_functions_succeeded{lambdafunctionarn:${etl_fetch_lambda_arn}}.as_count()",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "sum"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 0,
              "y": 0,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 3663311930076490,
            "definition": {
              "title": "Scheduled",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "white_on_gray",
                      "value": 0
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "sum:aws.states.lambda_functions_scheduled{lambdafunctionarn:${etl_fetch_lambda_arn}}.as_count()",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "sum"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 1,
              "y": 0,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 8288731597214692,
            "definition": {
              "title": "Started",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "white_on_gray",
                      "value": 0
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "sum:aws.states.lambda_functions_started{lambdafunctionarn:${etl_fetch_lambda_arn}}.as_count()",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "sum"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 2,
              "y": 0,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 285163438678972,
            "definition": {
              "title": "Failed",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">",
                      "palette": "white_on_red",
                      "value": 0
                    },
                    {
                      "comparator": "<",
                      "palette": "white_on_green",
                      "value": 1
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "sum:aws.states.lambda_functions_failed{lambdafunctionarn:${etl_fetch_lambda_arn}}.as_count()",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "sum"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 3,
              "y": 0,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 8552068296481348,
            "definition": {
              "title": "Timed out",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">",
                      "palette": "white_on_red",
                      "value": 0
                    },
                    {
                      "comparator": "<",
                      "palette": "white_on_green",
                      "value": 1
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "sum:aws.states.lambda_functions_timed_out{lambdafunctionarn:${etl_fetch_lambda_arn}}.as_count()",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "sum"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 4,
              "y": 0,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 7460125438011228,
            "definition": {
              "title": "Slowest",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "white_on_red",
                      "value": 0
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "max:aws.lambda.enhanced.duration{functionname:${etl_fetch_lambda_name}}",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "max"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "precision": 2
            },
            "layout": {
              "x": 0,
              "y": 1,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 5238674788018514,
            "definition": {
              "title": "Fastest",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "white_on_green",
                      "value": 0
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "min:aws.lambda.enhanced.duration{functionname:${etl_fetch_lambda_name}}",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "min"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "precision": 2
            },
            "layout": {
              "x": 1,
              "y": 1,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 704194829555610,
            "definition": {
              "title": "Average",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "white_on_gray",
                      "value": 0
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "avg:aws.lambda.enhanced.duration{functionname:${etl_fetch_lambda_name}}",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "avg"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 2,
              "y": 1,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 4755655456241598,
            "definition": {
              "title": "Max memory",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "white_on_red",
                      "value": 0
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "max:aws.lambda.enhanced.max_memory_used{functionname:${etl_fetch_lambda_name}}",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "max"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "precision": 2
            },
            "layout": {
              "x": 3,
              "y": 1,
              "width": 1,
              "height": 1
            }
          }
        ]
      },
      "layout": {
        "x": 6,
        "y": 0,
        "width": 6,
        "height": 3
      }
    },
    {
      "id": 3990914497676596,
      "definition": {
        "title": "Restaurant Search ETL Kickoff Lambda",
        "type": "group",
        "show_title": true,
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 2681148181782442,
            "definition": {
              "title": "Invocations",
              "title_size": "16",
              "title_align": "left",
              "time": {},
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">",
                      "palette": "white_on_green",
                      "value": 0
                    },
                    {
                      "comparator": "<",
                      "palette": "white_on_gray",
                      "value": 1
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "sum:aws.lambda.invocations{functionname:${etl_kickoff_lambda_name}}.as_count()",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "sum"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 0,
              "y": 0,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 3969033134219306,
            "definition": {
              "title": "Errors",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">",
                      "palette": "white_on_red",
                      "value": 0
                    },
                    {
                      "comparator": "<",
                      "palette": "white_on_green",
                      "value": 1
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "sum:aws.lambda.errors{functionname:${etl_kickoff_lambda_name}}.as_count()",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "sum"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 1,
              "y": 0,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 7407037898218426,
            "definition": {
              "title": "Throttled",
              "title_size": "16",
              "title_align": "left",
              "time": {},
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">",
                      "palette": "white_on_red",
                      "value": 0
                    },
                    {
                      "comparator": "<",
                      "palette": "white_on_green",
                      "value": 1
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "sum:aws.lambda.throttles{functionname:${etl_kickoff_lambda_name}}.as_count()",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "sum"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 2,
              "y": 0,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 3894242647602130,
            "definition": {
              "title": "Max memory",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "white_on_red",
                      "value": 0
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "max:aws.lambda.enhanced.max_memory_used{functionname:${etl_kickoff_lambda_name}}",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "max"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "precision": 2
            },
            "layout": {
              "x": 3,
              "y": 0,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 730035450174410,
            "definition": {
              "title": "Slowest",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "white_on_red",
                      "value": 0
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "max:aws.lambda.enhanced.duration{functionname:${etl_kickoff_lambda_name}}",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "max"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "precision": 2
            },
            "layout": {
              "x": 0,
              "y": 1,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 6772205438592950,
            "definition": {
              "title": "Fastest",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "white_on_green",
                      "value": 0
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "min:aws.lambda.enhanced.duration{functionname:${etl_kickoff_lambda_name}}",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "min"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "precision": 2
            },
            "layout": {
              "x": 1,
              "y": 1,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 6487658077986170,
            "definition": {
              "title": "Average",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "white_on_gray",
                      "value": 0
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "avg:aws.lambda.enhanced.duration{functionname:${etl_kickoff_lambda_name}}",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "avg"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 2,
              "y": 1,
              "width": 1,
              "height": 1
            }
          }
        ]
      },
      "layout": {
        "x": 0,
        "y": 0,
        "width": 6,
        "height": 3
      }
    },
    {
      "id": 2085499220290088,
      "definition": {
        "title": "Restaurant Search ETL Insert Lambda",
        "type": "group",
        "show_title": true,
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 743329447554894,
            "definition": {
              "title": "Succeeded",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">",
                      "palette": "white_on_green",
                      "value": 0
                    },
                    {
                      "comparator": "<",
                      "palette": "white_on_gray",
                      "value": 1
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "sum:aws.states.lambda_functions_succeeded{lambdafunctionarn:${etl_insert_lambda_arn}}.as_count()",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "sum"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 0,
              "y": 0,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 2188312749349562,
            "definition": {
              "title": "Scheduled",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "white_on_gray",
                      "value": 0
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "sum:aws.states.lambda_functions_scheduled{lambdafunctionarn:${etl_insert_lambda_arn}}.as_count()",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "sum"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 1,
              "y": 0,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 1224706744590546,
            "definition": {
              "title": "Started",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "white_on_gray",
                      "value": 0
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "sum:aws.states.lambda_functions_started{lambdafunctionarn:${etl_insert_lambda_arn}}.as_count()",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "sum"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 2,
              "y": 0,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 8634681614752100,
            "definition": {
              "title": "Failed",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">",
                      "palette": "white_on_red",
                      "value": 0
                    },
                    {
                      "comparator": "<",
                      "palette": "white_on_green",
                      "value": 1
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "sum:aws.states.lambda_functions_failed{lambdafunctionarn:${etl_insert_lambda_arn}}.as_count()",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "sum"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 3,
              "y": 0,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 2557239757485626,
            "definition": {
              "title": "Timed out",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">",
                      "palette": "white_on_red",
                      "value": 0
                    },
                    {
                      "comparator": "<",
                      "palette": "white_on_green",
                      "value": 1
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "sum:aws.states.lambda_functions_timed_out{lambdafunctionarn:${etl_insert_lambda_arn}}.as_count()",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "sum"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 4,
              "y": 0,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 336993596745824,
            "definition": {
              "title": "Slowest",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "white_on_red",
                      "value": 0
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "max:aws.lambda.enhanced.duration{functionname:${etl_insert_lambda_name}}",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "max"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "precision": 2
            },
            "layout": {
              "x": 0,
              "y": 1,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 2303405994458230,
            "definition": {
              "title": "Fastest",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "white_on_green",
                      "value": 0
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "min:aws.lambda.enhanced.duration{functionname:${etl_insert_lambda_name}}",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "min"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "precision": 2
            },
            "layout": {
              "x": 1,
              "y": 1,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 7642268923338254,
            "definition": {
              "title": "Average",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "white_on_gray",
                      "value": 0
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "avg:aws.lambda.enhanced.duration{functionname:${etl_insert_lambda_name}}",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "avg"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 2,
              "y": 1,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 2917174849746856,
            "definition": {
              "title": "Max memory",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "white_on_red",
                      "value": 0
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "max:aws.lambda.enhanced.max_memory_used{functionname:${etl_insert_lambda_name}}",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "max"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "precision": 2
            },
            "layout": {
              "x": 3,
              "y": 1,
              "width": 1,
              "height": 1
            }
          }
        ]
      },
      "layout": {
        "x": 6,
        "y": 0,
        "width": 6,
        "height": 3
      }
    },
    {
      "id": 7711330417447504,
      "definition": {
        "title": "Restaurant Search ETL State Machine",
        "type": "group",
        "show_title": true,
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 2301468599761670,
            "definition": {
              "title": "Succeeded",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "white_on_green",
                      "value": 0
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "sum:aws.states.executions_succeeded{statemachinearn:${etl_state_machine_arn}}.as_count()",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "sum"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "precision": 2
            },
            "layout": {
              "x": 0,
              "y": 0,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 6542749817183750,
            "definition": {
              "title": "Started",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "white_on_gray",
                      "value": 0
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "sum:aws.states.executions_started{statemachinearn:${etl_state_machine_arn}}.as_count()",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "sum"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 1,
              "y": 0,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 2155627447757410,
            "definition": {
              "title": "Failed",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "q": "sum:aws.states.executions_failed{statemachinearn:${etl_state_machine_arn}}.as_count()",
                  "aggregator": "sum",
                  "conditional_formats": [
                    {
                      "comparator": ">",
                      "palette": "white_on_red",
                      "value": 0
                    },
                    {
                      "comparator": "<",
                      "palette": "white_on_green",
                      "value": 1
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 2,
              "y": 0,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 2977435489352527,
            "definition": {
              "title": "Aborted",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">",
                      "palette": "white_on_red",
                      "value": 0
                    },
                    {
                      "comparator": "<",
                      "palette": "white_on_green",
                      "value": 1
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "sum:aws.states.executions_aborted{statemachinearn:${etl_state_machine_arn}}.as_count()",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "sum"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 3,
              "y": 0,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 3653081362279680,
            "definition": {
              "title": "Throttled",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "q": "sum:aws.states.execution_throttled{statemachinearn:${etl_state_machine_arn}}.as_count()",
                  "aggregator": "sum",
                  "conditional_formats": [
                    {
                      "comparator": ">",
                      "palette": "white_on_red",
                      "value": 0
                    },
                    {
                      "comparator": "<",
                      "palette": "white_on_green",
                      "value": 1
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 4,
              "y": 0,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 3513842216022160,
            "definition": {
              "title": "Slowest",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "white_on_red",
                      "value": 0
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "max:aws.states.execution_time.maximum{statemachinearn:${etl_state_machine_arn}}",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "max"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 0,
              "y": 1,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 5825570266681326,
            "definition": {
              "title": "Fastest",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "white_on_green",
                      "value": 0
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "min:aws.states.execution_time.minimum{statemachinearn:${etl_state_machine_arn}}",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "min"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 1,
              "y": 1,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 1626274870576400,
            "definition": {
              "title": "Average",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "white_on_gray",
                      "value": 0
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "avg:aws.states.execution_time{statemachinearn:${etl_state_machine_arn}}",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "avg"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 2,
              "y": 1,
              "width": 1,
              "height": 1
            }
          }
        ]
      },
      "layout": {
        "x": 0,
        "y": 0,
        "width": 6,
        "height": 3
      }
    },
    {
      "id": 5240635418692608,
      "definition": {
        "title": "Restaurant Search ETL Delete Lambda",
        "type": "group",
        "show_title": true,
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 857432107119408,
            "definition": {
              "title": "Succeeded",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">",
                      "palette": "white_on_green",
                      "value": 0
                    },
                    {
                      "comparator": "<",
                      "palette": "white_on_gray",
                      "value": 1
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "sum:aws.states.lambda_functions_succeeded{lambdafunctionarn:${etl_delete_lambda_arn}}.as_count()",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "sum"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 0,
              "y": 0,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 5759897086337402,
            "definition": {
              "title": "Scheduled",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "white_on_gray",
                      "value": 0
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "sum:aws.states.lambda_functions_scheduled{lambdafunctionarn:${etl_delete_lambda_arn}}.as_count()",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "sum"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 1,
              "y": 0,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 979765390254144,
            "definition": {
              "title": "Started",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "white_on_gray",
                      "value": 0
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "sum:aws.states.lambda_functions_started{lambdafunctionarn:${etl_delete_lambda_arn}}.as_count()",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "sum"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 2,
              "y": 0,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 2024438748505610,
            "definition": {
              "title": "Failed",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">",
                      "palette": "white_on_red",
                      "value": 0
                    },
                    {
                      "comparator": "<",
                      "palette": "white_on_green",
                      "value": 1
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "sum:aws.states.lambda_functions_failed{lambdafunctionarn:${etl_delete_lambda_arn}}.as_count()",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "sum"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 3,
              "y": 0,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 1112107952287174,
            "definition": {
              "title": "Timed out",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">",
                      "palette": "white_on_red",
                      "value": 0
                    },
                    {
                      "comparator": "<",
                      "palette": "white_on_green",
                      "value": 1
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "sum:aws.states.lambda_functions_timed_out{lambdafunctionarn:${etl_delete_lambda_arn}}.as_count()",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "sum"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 4,
              "y": 0,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 1858385183039892,
            "definition": {
              "title": "Slowest",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "white_on_red",
                      "value": 0
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "max:aws.lambda.enhanced.duration{functionname:${etl_delete_lambda_name}}",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "max"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "precision": 2
            },
            "layout": {
              "x": 0,
              "y": 1,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 1812582603399024,
            "definition": {
              "title": "Fastest",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "white_on_green",
                      "value": 0
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "min:aws.lambda.enhanced.duration{functionname:${etl_delete_lambda_name}}",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "min"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "precision": 2
            },
            "layout": {
              "x": 1,
              "y": 1,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 1848563805452276,
            "definition": {
              "title": "Average",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "white_on_gray",
                      "value": 0
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "avg:aws.lambda.enhanced.duration{functionname:${etl_delete_lambda_name}}",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "avg"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_links": [],
              "precision": 2
            },
            "layout": {
              "x": 2,
              "y": 1,
              "width": 1,
              "height": 1
            }
          },
          {
            "id": 2362713335027156,
            "definition": {
              "title": "Max memory",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "white_on_red",
                      "value": 0
                    }
                  ],
                  "response_format": "scalar",
                  "queries": [
                    {
                      "query": "max:aws.lambda.enhanced.max_memory_used{functionname:${etl_delete_lambda_name}}",
                      "data_source": "metrics",
                      "name": "query1",
                      "aggregator": "max"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "precision": 2
            },
            "layout": {
              "x": 3,
              "y": 1,
              "width": 1,
              "height": 1
            }
          }
        ]
      },
      "layout": {
        "x": 6,
        "y": 0,
        "width": 6,
        "height": 3
      }
    }
  ],
  "template_variables": [],
  "layout_type": "ordered",
  "is_read_only": false,
  "notify_list": [],
  "reflow_type": "fixed",
  "id": "x2b-8iq-bie"
}
