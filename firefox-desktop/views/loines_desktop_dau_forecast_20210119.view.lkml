view: loines_desktop_dau_forecast_20210119 {
  sql_table_name: `mozdata.analysis.loines_desktop_dau_forecast_2021-01-19`
    ;;

  dimension: date {
    type: date
    sql: ${TABLE}.ds ;;
  }

  measure: dau_forecast {
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.dau_forecast ;;
  }

  measure: dau_forecast_lower {
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.dau_forecast_lower ;;
  }

  measure: dau_forecast_plus5 {
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.dau_forecast_plus5 ;;
  }

  measure: cumulative_forecast_plus5 {
    type: running_total
    value_format: "#,##0"
    sql: ${dau_forecast_plus5} ;;
  }

  measure: recent_cumulative_forecast_plus5 {
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.dau_forecast_plus5  ;;
  }

  measure: dau_forecast_upper {
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.dau_forecast_upper ;;
  }

  measure: dau_new_profiles_actual {
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.dau_new_profiles_actual ;;
  }

  measure: yhat_cumulative {
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.yhat_cumulative ;;
  }

  measure: recent_yhat_cumulative {
    type: max
    value_format: "#,##0"
    sql: ${TABLE}.yhat_cumulative ;;
  }

  measure: yhat_lower_cumulative {
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.yhat_lower_cumulative ;;
  }

  measure: recent_yhat_lower_cumulative {
    type: max
    value_format: "#,##0"
    sql: ${TABLE}.yhat_lower_cumulative ;;
  }

  measure: yhat_upper_cumulative {
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.yhat_upper_cumulative ;;
  }

  measure: recent_yhat_upper_cumulative {
    type: max
    value_format: "#,##0"
    sql: ${TABLE}.yhat_upper_cumulative ;;
  }

}
