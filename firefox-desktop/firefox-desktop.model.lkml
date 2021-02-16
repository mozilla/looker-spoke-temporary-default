  connection: "telemetry"

include: "views/*.view.lkml"                # include all views in the views/ folder in this project

explore: client_counts {
  always_filter: {
    filters: [
      sample_id: "42",
      submission_date: "4 weeks",
    ]
  }
}

explore: clients_daily_suggest {
  hidden: yes
  from: clients_daily
  sql_always_where: submission_date > DATE_SUB(current_date, INTERVAL 3 DAY) AND sample_id = 84 ;;
  #sql_always_where: submission_date > '2016-12-13' AND sample_id = 52 ;;
}

explore: dau_by_country_2021 {}

explore: days_of_use_model {
  from: prediction
  join: training_data {
    type: left_outer
    sql_on: ${training_data.submission_date} = ${days_of_use_model.submission_date} ;;
    relationship: one_to_one
  }
  sql_always_where: (${training_data.submission_date} >= '2021-01-01' OR ${training_data.submission_date} IS NULL) ;;
}

explore: event_names {
  from: event_types_legacy
  hidden: yes
}

explore: funnel_analysis {
  from: events
  join: event_1 {
    view_label: "Funnel Event 1"
    from: event_types_legacy
    relationship: many_to_one
    type: cross
  }
  join: event_2 {
    view_label: "Funnel Event 2"
    from: event_types_legacy
    relationship: many_to_one
    type: cross
  }
  join: event_3 {
    view_label: "Funnel Event 3"
    from: event_types_legacy
    relationship: many_to_one
    type: cross
  }
  join: event_4 {
    view_label: "Funnel Event 4"
    from: event_types_legacy
    relationship: many_to_one
    type: cross
  }
  always_filter: {
    filters: [
      submission_date: "1 year",
      event_1.name: "",
      event_2.name: "",
      event_3.name: "",
      event_4.name: ""
    ]
  }
  sql_always_where: funnel_analysis.submission_date > "2010-01-01" ;;
}
