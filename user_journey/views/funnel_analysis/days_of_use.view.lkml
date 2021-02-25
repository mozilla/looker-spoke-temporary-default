view: days_of_use {
  derived_table:{
    sql:
      SELECT
        *
      FROM
        `moz-fx-data-shared-prod`.search.search_clients_last_seen AS clients_last_seen
      WHERE
        {% condition funnel_analysis.date %} CAST(DATE_SUB(clients_last_seen.submission_date, INTERVAL 56 DAY) AS TIMESTAMP) {% endcondition %}
        OR clients_last_seen.submission_date = DATE_SUB(current_date, INTERVAL 2 DAY);;
  }

  dimension: submission_date {
    type: date
    sql: ${TABLE}.submission_date ;;
    hidden: yes
  }

  dimension: client_id {
    type: string
    sql: ${TABLE}.client_id ;;
    hidden: yes
  }

  dimension: sample_id {
    type: string
    sql: ${TABLE}.sample_id ;;
    hidden: yes
  }

  dimension: day_diff_funnels {
    type: number
    sql:  DATE_DIFF(${TABLE}.submission_date, ${funnel_analysis.submission_date}, DAY);;
    hidden: yes
  }

  dimension: number_of_bytes {
    description: "The number of bytes to include our relevant period"
    type: number
    sql:  CAST(CEILING(-1 * ${day_diff_funnels} / 8) AS INT64);;
    hidden: yes
  }

  dimension: bit_offset {
    description: "The number of bits included at the beginning if ${number_of_bytes} that are not included in our window"
    type: number
    sql: MOD((8 * CAST(CEIL(${day_diff_funnels} / 8) AS INT64) - ${day_diff_funnels}), 8) ;;
    hidden: yes
  }

  dimension: days_seen_bytes {
    type: string
    sql: SUBSTR(${TABLE}.days_seen_bytes, ${number_of_bytes}) ;;
    hidden: yes
  }

  dimension: days_seen_bytes_56_reversed {
    type: string
    sql: REVERSED(SUBSTR(${days_seen_bytes} << ${bit_offset}, -7)) ;;
  }

  dimension: days_seen_bits_56 {
    type: string
    sql: IF(${day_diff_funnels} >= 56, REVERSED(SUBSTR(${days_seen_bytes}, -7)) & b'\xFF\xFF\xFF\xFF\xFF\xFF\xFF', NULL) ;;
    hidden: yes
  }

  dimension: days_seen_bits_28 {
    type: string
    sql: IF(${day_diff_funnels} >= 28, SUBSTR(${TABLE}.days_seen_bytes, -4) & b'\x0F\xFF\xFF\xFF', NULL) ;;
    hidden: yes
  }

  dimension: days_seen_bits_14 {
    type: string
    sql: IF(${day_diff_funnels} >= 14, SUBSTR(${TABLE}.days_seen_bytes, -2) & b'\x3F\xFF', NULL) ;;
    hidden: yes
  }

  dimension: days_seen_bits_7 {
    type: string
    sql: IF(${day_diff_funnels} >= 7, SUBSTR(${TABLE}.days_seen_bytes, -1) & b'\x7F', NULL) ;;
    hidden: yes
  }

  dimension: days_of_use_56 {
    type: number
    sql: BIT_COUNT(${days_seen_bits_56}) ;;
    hidden: yes
  }

  dimension: days_of_use_28 {
    type: number
    sql: BIT_COUNT(${days_seen_bits_28}) ;;
    hidden: yes
  }

  dimension: days_of_use_14 {
    type: number
    sql: BIT_COUNT(${days_seen_bits_14}) ;;
    hidden: yes
  }

  dimension: days_of_use_7 {
    type: number
    sql: BIT_COUNT(${days_seen_bits_7}) ;;
    hidden: yes
  }

  measure: 56_day_total_days_of_use {
    type: sum
    sql: ${days_of_use_56} ;;
  }

  measure: 56_day_avg_days_of_use {
    type: average
    sql: ${days_of_use_56} ;;
  }

  measure: 28_day_total_days_of_use {
    type: sum
    sql: ${days_of_use_28} ;;
  }

  measure: 28_day_avg_days_of_use {
    type: average
    sql: ${days_of_use_28} ;;
  }

  measure: 14_day_total_days_of_use {
    type: sum
    sql: ${days_of_use_14} ;;
  }

  measure: 14_day_avg_days_of_use {
    type: average
    sql: ${days_of_use_14} ;;
  }

  measure: 7_day_total_days_of_use {
    label: " 7 Day Total Days of Use"
    type: sum
    sql: ${days_of_use_7} ;;
  }

  measure: 7_day_avg_days_of_use {
    label: " 7 Day Avg Days of Use"
    type: average
    sql: ${days_of_use_7} ;;
  }
}
