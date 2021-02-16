view: events_daily {
  sql_table_name: `mozdata.tmp.messaging_system_events_daily_v1`
    ;;

  dimension: client_id_day {
    type: string
    sql: CONCAT(client_id, CAST(submission_date AS STRING)) ;;
    primary_key: yes
  }

  dimension: addon_version {
    type: string
    sql: ${TABLE}.addon_version ;;
  }

  dimension: app_version {
    type: string
    sql: ${TABLE}.app_version ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: client_id {
    type: string
    sql: ${TABLE}.client_id ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: events {
    type: string
    sql: ${TABLE}.events ;;
  }

  dimension: experiments {
    hidden: yes
    sql: ${TABLE}.experiments ;;
  }

  dimension: locale {
    type: string
    sql: ${TABLE}.locale ;;
  }

  dimension: normalized_channel {
    type: string
    sql: ${TABLE}.normalized_channel ;;
  }

  dimension: os {
    type: string
    sql: ${TABLE}.os ;;
  }

  dimension: sample_id {
    type: number
    sql: ${TABLE}.sample_id ;;
  }

  dimension: subdivision1 {
    type: string
    sql: ${TABLE}.subdivision1 ;;
  }

  filter: date {
    type: date
    sql: {% condition date %} CAST(funnel_analysis.submission_date AS TIMESTAMP) {% endcondition %} ;;
  }

  dimension: submission_date {
    type: date
    sql: CAST(${TABLE}.submission_date AS TIMESTAMP) ;;
  }

  dimension: completed_event_1 {
    type: yesno
    sql:  REGEXP_CONTAINS(${TABLE}.events, mozfun.event_analysis.create_funnel_regex([
            ${event_1.match_string}],
            True)) ;;
  }

  dimension: completed_event_2 {
    type: yesno
    sql:  REGEXP_CONTAINS(${TABLE}.events,
            mozfun.event_analysis.create_funnel_regex([
              ${event_1.match_string},
              ${event_2.match_string}],
            True)) ;;
  }

  dimension: completed_event_3 {
    type: yesno
    sql:  REGEXP_CONTAINS(${TABLE}.events,
            mozfun.event_analysis.create_funnel_regex([
              ${event_1.match_string},
              ${event_2.match_string},
              ${event_3.match_string}],
            True)) ;;
  }

  dimension: completed_event_4 {
    type: yesno
    sql:  REGEXP_CONTAINS(${TABLE}.events,
            mozfun.event_analysis.create_funnel_regex([
              ${event_1.match_string},
              ${event_2.match_string},
              ${event_3.match_string},
              ${event_4.match_string}],
            True)) ;;
  }

  dimension: completed_all_funnel_steps {
    type: yesno
    sql: {% if event_4.message_id._is_filtered %}
          ${completed_event_4}
          {% elsif event_3.message_id.is_filtered %}
          ${completed_event_3}
          {% elsif event_2.message_id.is_filtered %}
          ${completed_event_2}
          {% elsif event_1.message_id.is_filtered %}
          ${completed_event_1}

          {% endif %};;
  }

  measure: total_user_days {
    type: count
    hidden: yes
  }

  measure: count_user_days_event1 {
    label: "Count Completed Step 1"
    type: count

    filters: {
      field: completed_event_1
      value: "yes"
    }
  }

  measure: count_user_days_event2 {
    label: "Count Completed Step 2"
    type: count
    description: "Only includes user days which also completed event 1"

    filters: {
      field: completed_event_2
      value: "yes"
    }
  }

  measure: count_user_days_event3 {
    label: "Count Completed Step 3"
    type: count
    description: "Only includes user days which also completed up to event 2"

    filters: {
      field: completed_event_3
      value: "yes"
    }
  }

  measure: count_user_days_event4 {
    label: "Count Completed Step 4"
    type: count
    description: "Only includes user days which also completed up to event 3"

    filters: {
      field: completed_event_4
      value: "yes"
    }
  }

  measure: fraction_user_days_event1 {
    label: "Fraction Completed Step 1"
    sql: SAFE_DIVIDE(${count_user_days_event1}, ${count_user_days_event1}) ;;
    type: number
  }

  measure: fraction_user_days_event2 {
    label: "Fraction Completed Step 2"
    sql: SAFE_DIVIDE(${count_user_days_event2}, ${count_user_days_event1}) ;;
    type: number
  }

  measure: fraction_user_days_event3 {
    label: "Fraction Completed Step 3"
    sql: SAFE_DIVIDE(${count_user_days_event3}, ${count_user_days_event1}) ;;
    type: number
  }

  measure: fraction_user_days_event4 {
    label: "Fraction Completed Step 4"
    sql: SAFE_DIVIDE(${count_user_days_event4}, ${count_user_days_event1}) ;;
    type: number
  }
}

view: events_daily_experiments {
  dimension: experiment {
    type: string
    sql: ${TABLE}.key ;;
    primary_key: yes
  }

  dimension: branch {
    type: string
    sql: ${TABLE}.value ;;
  }
}
