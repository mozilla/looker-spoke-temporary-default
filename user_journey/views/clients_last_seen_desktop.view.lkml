view: days_of_use_56 {
  derived_table:{
    sql: SELECT *
      FROM `moz-fx-data-shared-prod`.search.search_clients_last_seen AS clients_last_seen
      WHERE {% condition funnel_analysis.date %} CAST(DATE_SUB(clients_last_seen.submission_date, INTERVAL 56 DAY) AS TIMESTAMP) {% endcondition %}
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

  dimension: days_seen_bits_56 {
    type: string
    sql: SUBSTR(${TABLE}.days_seen_bytes, -7) & b'\xFF\xFF\xFF\xFF\xFF\xFF\xFF' ;;
    hidden: yes
  }

  dimension: days_seen_bits_28 {
    type: string
    sql: SUBSTR(${TABLE}.days_seen_bytes, -4) & b'\x0F\xFF\xFF\xFF' ;;
    hidden: yes
  }

  dimension: days_seen_bits_14 {
    type: string
    sql: SUBSTR(${TABLE}.days_seen_bytes, -2) & b'\x3F\xFF' ;;
    hidden: yes
  }

  dimension: days_seen_bits_7 {
    type: string
    sql: SUBSTR(${TABLE}.days_seen_bytes, -1) & b'\x7F' ;;
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
    type: sum
    sql: ${days_of_use_7} ;;
  }

  measure: 7_day_avg_days_of_use {
    type: average
    sql: ${days_of_use_7} ;;
  }
}

view: days_of_use_28 {
  derived_table:{
    sql: SELECT *
      FROM `moz-fx-data-shared-prod`.search.search_clients_last_seen AS clients_last_seen
      WHERE {% condition funnel_analysis.date %} CAST(DATE_SUB(clients_last_seen.submission_date, INTERVAL 28 DAY) AS TIMESTAMP) {% endcondition %};;
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

  dimension: days_of_use_28 {
    type: number
    sql: BIT_COUNT(SUBSTR(${TABLE}.days_seen_bytes, -4) & b'\x0F\xFF\xFF\xFF') ;;
    hidden: yes
  }

  measure: total_days_of_use {
    type: sum
    sql: ${days_of_use_28} ;;
  }

  measure: avg_days_of_use {
    type: average
    sql: ${days_of_use_28} ;;
  }
}

view: days_of_use_7 {
  derived_table:{
    sql: SELECT *
      FROM `moz-fx-data-shared-prod`.search.search_clients_last_seen AS clients_last_seen
      WHERE {% condition funnel_analysis.date %} CAST(DATE_SUB(clients_last_seen.submission_date, INTERVAL 7 DAY) AS TIMESTAMP) {% endcondition %};;
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

  dimension: days_seen_bits_7 {
    type: number
    sql: SUBSTR(${TABLE}.days_seen_bytes, -1) & b'\x7F' ;;
    hidden: yes
  }

  dimension: days_of_use_7 {
    type: number
    sql: BIT_COUNT(${days_seen_bits_7}) ;;
    hidden: yes
  }

  measure: total_days_of_use {
    type: sum
    sql: ${days_of_use_7} ;;
  }

  measure: avg_days_of_use {
    type: average
    sql: ${days_of_use_7} ;;
  }
}
