view: events_daily_v1 {
  sql_table_name: `mozdata.tmp.messaging_system_events_daily_v1`
  ;;

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
    sql: {% condition date %} CAST(cohort_analysis.submission_date AS TIMESTAMP) {% endcondition %} ;;
  }

  dimension: submission_date {
    type: date
    sql: CAST(${TABLE}.submission_date AS TIMESTAMP) ;;
  }
}
