connection: "telemetry"

include: "/user_journey/views/*/*.view.lkml"                # include all views in the views/ folder in this project
include: "/user_journey/views/*.view.lkml"

explore: event_names {
  hidden: yes
  from: raw_event_types
}

explore: events_daily_sample {
  hidden: yes
  from: events_daily_v1
  sql_always_where:
    events_daily_sample.submission_date >= DATE_SUB(current_date, INTERVAL 7 DAY)
    AND events_daily_sample.sample_id = 42;;
}

explore: funnel_analysis {
  view_label: " User-Day Funnels"
  join: days_of_use {
    view_label: "Days of Use"
    relationship: one_to_one
    type: left_outer
    sql_on: ${funnel_analysis.sample_id} = ${days_of_use.sample_id}
        AND ${funnel_analysis.client_id} = ${days_of_use.client_id}
        AND (${funnel_analysis.submission_date} = DATE_SUB(${days_of_use.submission_date}, INTERVAL 56 DAY)
              OR (${days_of_use.submission_date} = DATE_SUB(current_date, INTERVAL 2 DAY)
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
  view_label: " User-Days"
  from: cohort
  join: message_ids {
    relationship: many_to_one
    type: cross
  }
  join: days_since_message {
    relationship: many_to_one
    type: cross
  }
  join: clients_last_seen {
    view_label: "Days of Use"
    relationship: one_to_one
    type: left_outer
    sql_on: ${cohort_analysis.sample_id} = ${clients_last_seen.sample_id}
        AND ${cohort_analysis.client_id} = ${clients_last_seen.client_id}
        AND (${cohort_analysis.submission_date} = DATE_SUB(${clients_last_seen.submission_date}, INTERVAL 56 DAY)
              OR (${clients_last_seen.submission_date} = DATE_SUB(current_date, INTERVAL 2 DAY)
                  AND DATE_ADD(${cohort_analysis.submission_date}, INTERVAL 56 DAY) >  DATE_SUB(current_date, INTERVAL 2 DAY)));;
  }
  sql_always_where: cohort_analysis.submission_date > "2010-01-01" ;;
  always_filter: {
    filters: [
      date: "2021-01-01",
      message_ids.message_event: "ABOUT^_WELCOME - IMPRESSION",
    ]
  }
}

explore: event_counts {
  from: onboarding_v1
  join: message_id_ranks {
    fields: [rank]
    type: inner
    relationship: many_to_one
    sql_on: ${event_counts.message_id} = ${message_id_ranks.message_id} ;;
  }

  always_filter: {
    filters: [
      submission_timestamp_date: "14 days",
    ]
  }
  sql_always_where: DATE(submission_timestamp) > '2020-01-01'
  ;;
}
