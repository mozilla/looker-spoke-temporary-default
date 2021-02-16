include: "events_daily_v1.view.lkml"

view: cohort_1 {
  extends: [events_daily_v1]

  dimension: completed_message_id_event {
    type: yesno
    sql:  REGEXP_CONTAINS(${TABLE}.events, mozfun.event_analysis.create_funnel_regex([
            ${message_ids.match_string}],
            True)) ;;
  }

  measure: total_user_days {
    type: count
    hidden: yes
  }

  measure: count_user_days_completed_message_id_event {
    label: "Count of User-Days"
    type: count

    filters: {
      field: completed_message_id_event
      value: "yes"
    }
  }
}

view: cohort_2 {
  extends: [events_daily_v1]

  dimension: completed_message_id_event {
    type: yesno
    sql:  REGEXP_CONTAINS(${TABLE}.events, mozfun.event_analysis.create_funnel_regex([
            ${message_ids.match_string}],
            True)) ;;
  }

  measure: total_user_days {
    type: count
    hidden: yes
  }

  measure: count_user_days_completed_message_id_event {
    label: "Count of User-Days"
    type: count

    filters: {
      field: completed_message_id_event
      value: "yes"
    }
  }
}

view: message_ids {
  derived_table: {
    sql:
      SELECT
        CONCAT(category, ' - ', event) AS message_event,
        mozfun.event_analysis.event_index_to_match_string(index) AS match_string,
      FROM
        `mozdata.tmp.messaging_system_event_types_v1` event_types
      WHERE
        {% condition message_ids.message_id %} event_types.category {% endcondition %}
        AND {% condition message_ids.event_type %} event_types.event {% endcondition %};;
  }

  filter: message_id {
    type: string
    suggest_explore: event_names
    suggest_dimension: event_names.category
  }

  filter: event_type {
    type: string
    suggest_explore: event_names
    suggest_dimension: event_names.event
  }

  dimension: message_event {
    type: string
    sql: ${TABLE}.message_event ;;
  }

  dimension: match_string {
    hidden: yes
    sql: ${TABLE}.match_string ;;
  }
}

# view: cohort_analysis {
#   # Or, you could make this view a derived table, like this:
#   derived_table: {
#     sql: SELECT
#         user_id as user_id
#         , COUNT(*) as lifetime_orders
#         , MAX(orders.created_at) as most_recent_purchase_at
#       FROM orders
#       GROUP BY user_id
#       ;;
#   }
#
#   # Define your dimensions and measures here, like this:
#   dimension: user_id {
#     description: "Unique ID for each user that has ordered"
#     type: number
#     sql: ${TABLE}.user_id ;;
#   }
#
#   dimension: lifetime_orders {
#     description: "The total number of orders for each user"
#     type: number
#     sql: ${TABLE}.lifetime_orders ;;
#   }
#
#   dimension_group: most_recent_purchase {
#     description: "The date when each user last ordered"
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${TABLE}.most_recent_purchase_at ;;
#   }
#
#   measure: total_lifetime_orders {
#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
# }
