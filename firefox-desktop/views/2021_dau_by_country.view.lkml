view: dau_by_country_2021 {
  derived_table: {
    sql: SELECT country, submission_date, COUNT(*) AS count
      FROM mozdata.telemetry.clients_daily
      WHERE submission_date >= '2021-01-01'
      GROUP BY 1, 2
       ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: submission_date {
    type: date
    datatype: date
    sql: ${TABLE}.submission_date ;;
  }

  dimension: f0_ {
    type: number
    sql: ${TABLE}.f0_ ;;
  }

  measure: dau {
    type: sum
    sql: ${TABLE}.count ;;
  }

  set: detail {
    fields: [country, submission_date, f0_]
  }
}
