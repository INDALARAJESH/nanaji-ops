{
  "title": "Restaurant Search DMS Migration - ${local_env}",
  "description": "## DMS replication metrics\n\n Restaurant Search ETL DMS replication monitoring dashboard",
  "widgets": [
    {
      "id": 6422872339015328,
      "definition": {
        "title": "Latency Metrics",
        "type": "group",
        "show_title": true,
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 461651916383352,
            "definition": {
              "title": "Total Average Latency for Replication Task",
              "title_size": "16",
              "title_align": "left",
              "time": {},
              "type": "query_value",
              "requests": [
                {
                  "response_format": "scalar",
                  "queries": [
                    {
                      "data_source": "metrics",
                      "name": "query1",
                      "query": "avg:aws.dms.cdclatency_source{$env,$service}",
                      "aggregator": "avg"
                    },
                    {
                      "data_source": "metrics",
                      "name": "query2",
                      "query": "avg:aws.dms.cdclatency_target{$env,$service}",
                      "aggregator": "avg"
                    }
                  ],
                  "formulas": [
                    {
                      "formula": "query1 + query2"
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
              "width": 3,
              "height": 2
            }
          },
          {
            "id": 1096114426084782,
            "definition": {
              "title": "Total Maximum Latency for Replication Task",
              "title_size": "16",
              "title_align": "left",
              "time": {},
              "type": "query_value",
              "requests": [
                {
                  "response_format": "scalar",
                  "queries": [
                    {
                      "data_source": "metrics",
                      "name": "query1",
                      "query": "max:aws.dms.cdclatency_source{$env,$service}",
                      "aggregator": "avg"
                    },
                    {
                      "data_source": "metrics",
                      "name": "query2",
                      "query": "max:aws.dms.cdclatency_target{$env,$service}",
                      "aggregator": "avg"
                    }
                  ],
                  "formulas": [
                    {
                      "formula": "query1 + query2"
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
              "width": 3,
              "height": 2
            }
          },
          {
            "id": 1073702087841946,
            "definition": {
              "title": "CDC Target Latency for Replication Task",
              "title_size": "16",
              "title_align": "left",
              "show_legend": true,
              "legend_layout": "auto",
              "legend_columns": [
                "avg",
                "min",
                "max",
                "value",
                "sum"
              ],
              "time": {},
              "type": "timeseries",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:aws.dms.cdclatency_target{$env,$service}",
                      "data_source": "metrics",
                      "name": "query1"
                    }
                  ],
                  "response_format": "timeseries",
                  "style": {
                    "palette": "green",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ]
            },
            "layout": {
              "x": 0,
              "y": 2,
              "width": 11,
              "height": 4
            }
          },
          {
            "id": 5774946007731344,
            "definition": {
              "title": "CDC Source Latency for Replication Task",
              "title_size": "16",
              "title_align": "left",
              "show_legend": true,
              "legend_layout": "auto",
              "legend_columns": [
                "avg",
                "min",
                "max",
                "value",
                "sum"
              ],
              "time": {},
              "type": "timeseries",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:aws.dms.cdclatency_source{$env,$service}",
                      "data_source": "metrics",
                      "name": "query1"
                    }
                  ],
                  "response_format": "timeseries",
                  "style": {
                    "palette": "red",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ]
            },
            "layout": {
              "x": 0,
              "y": 6,
              "width": 11,
              "height": 4
            }
          }
        ]
      },
      "layout": {
        "x": 0,
        "y": 0,
        "width": 12,
        "height": 1
      }
    },
    {
      "id": 6546640628161582,
      "definition": {
        "title": "Replication Instance Memory Usage",
        "type": "group",
        "show_title": true,
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 5173348159453192,
            "definition": {
              "title": "Max Memory Usage",
              "title_size": "16",
              "title_align": "left",
              "time": {},
              "type": "query_value",
              "requests": [
                {
                  "response_format": "scalar",
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "max:aws.dms.memory_usage{$env,$service}",
                      "aggregator": "avg"
                    }
                  ],
                  "formulas": [
                    {
                      "formula": "query1"
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
              "width": 2,
              "height": 2
            }
          },
          {
            "id": 1659432627661710,
            "definition": {
              "title": "Average Memory Usage",
              "title_size": "16",
              "title_align": "left",
              "time": {},
              "type": "query_value",
              "requests": [
                {
                  "response_format": "scalar",
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:aws.dms.memory_usage{$env,$service}",
                      "aggregator": "avg"
                    }
                  ],
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "precision": 2
            },
            "layout": {
              "x": 2,
              "y": 0,
              "width": 2,
              "height": 2
            }
          },
          {
            "id": 6871205389949000,
            "definition": {
                "title": "Task Memory Usage",
                "title_size": "16",
                "title_align": "left",
                "show_legend": true,
                "legend_layout": "auto",
                "legend_columns": [
                    "avg",
                    "min",
                    "max",
                    "value",
                    "sum"
                ],
                "type": "timeseries",
                "requests": [
                    {
                        "formulas": [
                            {
                                "formula": "query1"
                            }
                        ],
                        "response_format": "timeseries",
                        "queries": [
                            {
                                "query": "avg:aws.dms.memory_usage_bytes{$env,$service}",
                                "data_source": "metrics",
                                "name": "query1"
                            }
                        ],
                        "style": {
                            "palette": "cool",
                            "line_type": "solid",
                            "line_width": "normal"
                        },
                        "display_type": "line"
                    }
                ]
            },
            "layout": {
                "x": 4,
                "y": 0,
                "width": 4,
                "height": 2
            }
          },
          {
            "id": 7708320744272506,
            "definition": {
              "title": "Replication Instance Memory Usage Timeline",
              "title_size": "16",
              "title_align": "left",
              "show_legend": true,
              "legend_layout": "auto",
              "legend_columns": [
                "avg",
                "min",
                "max",
                "value",
                "sum"
              ],
              "time": {},
              "type": "timeseries",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:aws.dms.memory_usage{$env,$service}",
                      "data_source": "metrics",
                      "name": "query1"
                    }
                  ],
                  "response_format": "timeseries",
                  "style": {
                    "palette": "dog_classic",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ]
            },
            "layout": {
              "x": 0,
              "y": 2,
              "width": 11,
              "height": 5
            }
          },
          {
            "id": 1704978987846866,
            "definition": {
              "title": "Average CDC Changes in Memory and in Disk for Replication Task",
              "title_size": "16",
              "title_align": "left",
              "show_legend": true,
              "legend_layout": "auto",
              "legend_columns": [
                "avg",
                "min",
                "max",
                "value",
                "sum"
              ],
              "time": {},
              "type": "timeseries",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    },
                    {
                      "formula": "query2"
                    },
                    {
                      "formula": "query3"
                    },
                    {
                      "formula": "query4"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:aws.dms.cdcchanges_memory_target{$env,$service}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:aws.dms.cdcchanges_disk_target{$env,$service}"
                    },
                    {
                      "name": "query3",
                      "data_source": "metrics",
                      "query": "avg:aws.dms.cdcchanges_disk_source{$env,$service}"
                    },
                    {
                      "name": "query4",
                      "data_source": "metrics",
                      "query": "avg:aws.dms.cdcchanges_memory_source{$env,$service}"
                    }
                  ],
                  "response_format": "timeseries",
                  "style": {
                    "palette": "orange",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ]
            },
            "layout": {
              "x": 0,
              "y": 7,
              "width": 11,
              "height": 4
            }
          }
        ]
      },
      "layout": {
        "x": 0,
        "y": 1,
        "width": 12,
        "height": 1
      }
    },
    {
      "id": 7319252631643944,
      "definition": {
        "title": "CPU Utilization",
        "type": "group",
        "show_title": true,
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 2371615228272556,
            "definition": {
              "title": "Replication Instance CPU Utilization",
              "title_size": "16",
              "title_align": "left",
              "show_legend": true,
              "legend_layout": "auto",
              "legend_columns": [
                "avg",
                "min",
                "max",
                "value",
                "sum"
              ],
              "time": {},
              "type": "timeseries",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:aws.dms.cpuutilization{$env,$service}"
                    }
                  ],
                  "response_format": "timeseries",
                  "style": {
                    "palette": "cool",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ]
            },
            "layout": {
              "x": 0,
              "y": 0,
              "width": 11,
              "height": 4
            }
          },
          {
            "id": 4934434514645812,
            "definition": {
              "title": "Replication Task CPU Utilization",
              "title_size": "16",
              "title_align": "left",
              "show_legend": true,
              "legend_layout": "auto",
              "legend_columns": [
                "avg",
                "min",
                "max",
                "value",
                "sum"
              ],
              "time": {},
              "type": "timeseries",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:aws.dms.cpuutilization{$env,$service}"
                    }
                  ],
                  "response_format": "timeseries",
                  "style": {
                    "palette": "cool",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ]
            },
            "layout": {
              "x": 0,
              "y": 4,
              "width": 11,
              "height": 4
            }
          }
        ]
      },
      "layout": {
        "x": 0,
        "y": 2,
        "width": 12,
        "height": 1
      }
    }
  ],
  "template_variables": [
      {
          "name": "env",
          "prefix": "env",
          "available_values": [
              "uatload",
              "dev",
              "ncp",
              "prod",
              "qa",
              "stg",
              "uat"
          ],
          "default": "prod"
      },
      {
          "name": "service",
          "prefix": "service",
          "available_values": [
              "restaurant-search-dm"
          ],
          "default": "restaurant-search-dm"
      }
  ],
  "layout_type": "ordered",
  "is_read_only": false,
  "notify_list": [],
  "reflow_type": "fixed",
  "id": "3gh-dby-64d"
}