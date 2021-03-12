view: mobile_usage_2021 {
  sql_table_name: `mozdata.telemetry.mobile_usage_2021`
    ;;

  dimension: app_name {
    type: string
    sql: ${TABLE}.app_name ;;
  }

  dimension: campaign {
    type: string
    sql: ${TABLE}.campaign ;;
  }

  dimension: canonical_app_name {
    type: string
    sql: ${TABLE}.canonical_app_name ;;
  }

  dimension: channel {
    type: string
    sql: ${TABLE}.channel ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: distribution_id {
    type: string
    sql: ${TABLE}.distribution_id ;;
  }

  dimension: id_bucket {
    type: number
    sql: ${TABLE}.id_bucket ;;
  }

  dimension: os {
    type: string
    sql: ${TABLE}.os ;;
  }

  dimension: date {
    type: date
    sql: ${TABLE}.submission_date ;;
  }

  measure: dau {
    type: sum
    sql: ${TABLE}.dau ;;
  }
  
  measure: wau {
    type: sum
    sql: ${TABLE}.wau ;;
  }

  measure: mau {
    type: sum
    sql: ${TABLE}.mau ;;
  }

  measure: cdou {
    type: sum
    sql: ${TABLE}.cdou ;;
  }

}
