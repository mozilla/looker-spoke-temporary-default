view: core_clients_daily {
  sql_table_name: `mozdata-nonprod.telemetry.core_clients_daily`
    ;;

  dimension: app_build_id {
    type: string
    sql: ${TABLE}.app_build_id ;;
  }

  dimension: app_name {
    type: string
    sql: ${TABLE}.app_name ;;
  }

  dimension: arch {
    type: string
    sql: ${TABLE}.arch ;;
  }

  dimension: bug_1501329_affected {
    type: yesno
    sql: ${TABLE}.bug_1501329_affected ;;
  }

  dimension: campaign {
    type: string
    sql: ${TABLE}.campaign ;;
  }

  dimension: campaign_id {
    type: string
    sql: ${TABLE}.campaign_id ;;
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

  dimension: default_browser {
    type: yesno
    sql: ${TABLE}.default_browser ;;
  }

  dimension: default_search {
    type: string
    sql: ${TABLE}.default_search ;;
  }

  dimension: device {
    type: string
    sql: ${TABLE}.device ;;
  }

  dimension: distribution_id {
    type: string
    sql: ${TABLE}.distribution_id ;;
  }

  dimension: durations {
    type: number
    sql: ${TABLE}.durations ;;
  }

  dimension: flash_usage {
    type: number
    sql: ${TABLE}.flash_usage ;;
  }

  dimension: locale {
    type: string
    sql: ${TABLE}.locale ;;
  }

  dimension: metadata_app_version {
    type: string
    sql: ${TABLE}.metadata_app_version ;;
  }

  dimension: normalized_channel {
    type: string
    sql: ${TABLE}.normalized_channel ;;
  }

  dimension: os {
    type: string
    sql: ${TABLE}.os ;;
  }

  dimension: osversion {
    type: string
    sql: ${TABLE}.osversion ;;
  }

  dimension_group: profile {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.profile_date ;;
  }

  dimension: sessions {
    type: number
    sql: ${TABLE}.sessions ;;
  }

  dimension: show_tracker_stats_share {
    type: yesno
    sql: ${TABLE}.show_tracker_stats_share ;;
  }

  dimension_group: submission {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.submission_date ;;
  }

  measure: count {
    type: count
    drill_fields: [app_name]
  }
}
