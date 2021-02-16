view: training_data {
  derived_table: {
    #persist_for: "0 second"
    sql: SELECT
    AS STRUCT CAST(submission_date AS TIMESTAMP) AS submission_date,
    COUNT(*) AS dau
  FROM
    mozdata.telemetry.clients_daily clients_daily
  WHERE
    submission_date > '2019-01-01'
    AND sample_id = 52
    AND {% condition training_data.country %} clients_daily.country {% endcondition %}
    AND {% condition training_data.cpu_model %} clients_daily.cpu_model {% endcondition %}
    AND {% condition training_data.distribution_id %} clients_daily.distribution_id {% endcondition %}
    AND {% condition training_data.locale %} clients_daily.locale {% endcondition %}
    AND {% condition training_data.os %} clients_daily.os {% endcondition %}
    AND {% condition training_data.os_version %} clients_daily.os_version {% endcondition %}
    AND {% condition training_data.channel %} clients_daily.channel {% endcondition %}
  GROUP BY
    submission_date ;;
  }

  dimension: submission_date {
    type: date
    hidden: yes
  }

  filter: country {
    type: string
    suggest_explore: clients_daily_suggest
    suggest_dimension: clients_daily_suggest.country
  }

  filter: cpu_model {
    type: string
    suggest_explore: clients_daily_suggest
    suggest_dimension: clients_daily_suggest.cpu_model
  }

  filter: distribution_id {
    type: string
    suggest_explore: clients_daily_suggest
    suggest_dimension: clients_daily_suggest.distribution_id
  }

  filter: locale {
    type: string
    suggest_explore: clients_daily_suggest
    suggest_dimension: clients_daily_suggest.locale
  }

  filter: os {
    type: string
    suggest_explore: clients_daily_suggest
    suggest_dimension: clients_daily_suggest.os
  }

  filter: os_version {
    type: string
    suggest_explore: clients_daily_suggest
    suggest_dimension: clients_daily_suggest.os
  }

  filter: channel {
    type: string
    suggest_explore: clients_daily_suggest
    suggest_dimension: clients_daily_suggest.channel
  }

  measure: dau {
    type: sum
    sql: ${TABLE}.dau * 100 ;;
  }

  measure: days_of_use {
    type: running_total
    sql: ${dau} ;;
  }
}

view: dau_model {
  derived_table: {
    persist_for: "1 second"
    sql_create:
    DECLARE current_conditions STRING DEFAULT ARRAY_TO_STRING(REGEXP_EXTRACT_ALL("""
      {% condition training_data.country %} clients_daily.country {% endcondition %}
      {% condition training_data.cpu_model %} clients_daily.cpu_model {% endcondition %}
      {% condition training_data.distribution_id %} clients_daily.distribution_id {% endcondition %}
      {% condition training_data.locale %} clients_daily.locale {% endcondition %}
      {% condition training_data.os %} clients_daily.os {% endcondition %}
      {% condition training_data.os_version %} clients_daily.os_version {% endcondition %}
      {% condition training_data.channel %} clients_daily.channel {% endcondition %}
      """, r"(\(.* = '.*'\))"), '');

    DECLARE row_count INT64;

    CREATE TABLE IF NOT EXISTS
      mozdata.analysis.dou_forecasts
    AS
      SELECT
        CAST(NULL AS TIMESTAMP) AS submission_date,
        CAST(NULL AS FLOAT64) AS dau_forecast,
        CAST(NULL AS STRING) AS conditions
      FROM
        mozdata.telemetry.clients_daily
      WHERE
        FALSE;

    SET row_count = (
      SELECT COUNT(*)
      FROM mozdata.analysis.dou_forecasts
      WHERE conditions = current_conditions);

    IF row_count = 0 THEN
      -- Create model
      CREATE OR REPLACE MODEL
      ${SQL_TABLE_NAME} OPTIONS(
        model_type='ARIMA',
        time_series_data_col='dau',
        time_series_timestamp_col='submission_date'
      ) AS
      SELECT
        *
      FROM
        ${training_data.SQL_TABLE_NAME}
      WHERE
        submission_date < '2021-01-01';

      -- Load table
      INSERT INTO mozdata.analysis.dou_forecasts
      SELECT
        forecast_timestamp AS submission_date,
        forecast_value AS dau_forecast,
        current_conditions AS conditions
      FROM
        ML.FORECAST(MODEL ${SQL_TABLE_NAME},
          STRUCT(365 AS horizon,
          0.1 AS confidence_level));
    END IF;;
  }
}

view: prediction {
  derived_table: {
    #persist_for: "1 second"
    sql:
    SELECT
      submission_date,
      dau_forecast,
    FROM
      mozdata.analysis.dou_forecasts
    WHERE -- Also requires ${dau_model.SQL_TABLE_NAME}
      conditions = ARRAY_TO_STRING(REGEXP_EXTRACT_ALL("""
      {% condition training_data.country %} clients_daily.country {% endcondition %}
      {% condition training_data.cpu_model %} clients_daily.cpu_model {% endcondition %}
      {% condition training_data.distribution_id %} clients_daily.distribution_id {% endcondition %}
      {% condition training_data.locale %} clients_daily.locale {% endcondition %}
      {% condition training_data.os %} clients_daily.os {% endcondition %}
      {% condition training_data.os_version %} clients_daily.os_version {% endcondition %}
      {% condition training_data.channel %} clients_daily.channel {% endcondition %}
      """, r"(\(.* = '.*'\))"), '');;
  }

  dimension: submission_date {
    type: date
  }

  measure: dau_forecast {
    type: sum
    sql: ${TABLE}.dau_forecast * 100 ;;
  }

  measure: dau_target {
    type: sum
    sql: ${TABLE}.dau_forecast * 1.05 * 100 ;;
  }

  measure: days_of_use_forecast {
    type: running_total
    sql: ${dau_forecast} ;;
  }

  measure: days_of_use_target {
    type: running_total
    sql: ${dau_target} ;;
  }
}
