connection: "telemetry"

include: "/user_journey/views/*.view.lkml"                # include all views in the views/ folder in this project

explore: event_names {
  from: raw_event_types
  hidden: yes
}

explore: page {
  from: raw_event_types
  sql_always_where: property_name = 'page' ;;
  hidden: yes
}

explore: funnel_analysis {
  view_label: " User-Day Funnels"
  from: events_daily
  join: days_of_use_56 {
    view_label: "Days of Use"
    relationship: one_to_one
    type: left_outer
    sql_on: ${funnel_analysis.sample_id} = ${days_of_use_56.sample_id}
        AND ${funnel_analysis.client_id} = ${days_of_use_56.client_id}
        AND (${funnel_analysis.submission_date} = DATE_SUB(${days_of_use_56.submission_date}, INTERVAL 56 DAY)
              OR (${days_of_use_56.submission_date} = DATE_SUB(current_date, INTERVAL 2 DAY)
                  AND DATE_ADD(${funnel_analysis.submission_date}, INTERVAL 56 DAY) >  DATE_SUB(current_date, INTERVAL 2 DAY)));;
  }
  join: event_1 {
    #view_label: "Funnel Event 1"
    relationship: many_to_one
    type: cross
  }
  join: event_2 {
    #view_label: "Funnel Event 1"
    relationship: many_to_one
    type: cross
  }
  join: event_3 {
    #view_label: "Funnel Event 1"
    relationship: many_to_one
    type: cross
  }
  join: event_4 {
    #view_label: "Funnel Event 1"
    relationship: many_to_one
    type: cross
  }
  join: events_daily_experiments {
    relationship: one_to_many
    #type: left_outer
    sql: LEFT OUTER JOIN UNNEST(experiments) AS events_daily_experiments;;
  }
  always_filter: {
    filters: [
      date: "2021-01-01",
      # Caret tells Looker to use "Is Equal To" matching rather than "Matches (advanced)"
      event_1.message_id: "ABOUT^_WELCOME",
      event_1.event_type: "IMPRESSION",
    ]
  }
  sql_always_where: funnel_analysis.submission_date > "2010-01-01" ;;
}

explore: cohort_analysis {
  view_label: " Cohort 1"
  from: cohort_1
  join: message_ids {
    relationship: many_to_one
    type: cross
  }
  sql_always_where: cohort_analysis.submission_date > "2010-01-01" ;;
  always_filter: {
    filters: [
      date: "2021-01-01",
      message_ids.message_id: "ABOUT^_WELCOME",
      message_ids.event_type: "IMPRESSION",
    ]
  }
}
