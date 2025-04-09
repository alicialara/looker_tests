# PoP se utiliza para comparar periodos temporales. La mayor paranoia de Looker que va a ver hasta ahora. Good Luck !

view: pop {
  extension: required

  filter: date_filter {
    view_label: "_PoP"
    label: "Date filter"
    description: "Use this date filter in combination with the timeframes dimension for dynamic date filtering"
    type: date
  }

  set: pop_dimensions {
    fields: [
      comparison_raw,
      comparison_time,
      comparison_hour_of_day,
      fecha,
      comparison_day_of_week,
      comparison_day_of_week_index,
      comparison_day_of_month,
      comparison_day_of_year,
      comparison_week,
      comparison_week_of_year,
      comparison_month,
      comparison_month_name,
      comparison_month_num,
      comparison_quarter,
      comparison_year,
      date_filter,
      timeframes
    ]
  }

  dimension_group: filter_start_date {
    hidden: yes
    view_label: "_PoP"
    type: time
    timeframes: [raw, date, month]
    sql: CASE WHEN {% date_start date_filter %} IS NULL THEN DATEADD(MONTH, -3, GETDATE()) ELSE CAST({% date_start date_filter %} AS DATE) END;;
  }

  dimension_group: filter_end_date {
    hidden: yes
    view_label: "_PoP"
    type: time
    timeframes: [raw, date, month]
    sql: CASE WHEN {% date_end date_filter %} IS NULL THEN GETDATE() ELSE CAST({% date_end date_filter %} AS DATE) END;;
  }

  dimension: interval {
    hidden: yes
    view_label: "_PoP"
    type: number
    sql: DATEDIFF(DAY, ${filter_start_date_raw}, ${filter_end_date_raw});;
  }

  #start date of the previous period
  dimension_group: previous_start {
    hidden: yes
    view_label: "_PoP"
    type: time
    timeframes: [raw, date]
    sql: DATEADD(DAY, -${interval}, ${filter_start_date_raw});;
  }

  dimension_group: previous_year_start {
    hidden: yes
    view_label: "_PoP"
    type: time
    timeframes: [raw, date]
    sql: DATEADD(DAY, -365, ${filter_start_date_date});;
  }

  dimension_group: previous_year_end {
    hidden: yes
    view_label: "_PoP"
    type: time
    timeframes: [raw, date]
    sql: DATEADD(DAY, ${interval}, ${previous_year_start_date});;
  }

  dimension: timeframes {
    view_label: "_PoP"
    label: "Timeframes"
    type: string
    case: {
      when: {
        sql: ${is_current_period} = 1;;
        label: "Periodo actual"
      }
      when: {
        sql: ${is_previous_period} = 1;;
        label: "Periodo anterior"
      }
      when: {
        sql: ${is_previous_year} = 1;;
        label: "Año anterior"
      }
      else: "Not in time period"
    }
  }


  ## For filtered measures
  dimension: is_current_period {
    hidden: yes
    type: yesno
    sql: ${comparison_date_date} >= ${filter_start_date_date} AND ${comparison_date_date} < ${filter_end_date_date};;
  }

  dimension: is_previous_period {
    hidden: yes
    type: yesno
    sql: ${comparison_date_date} >= ${previous_start_date} AND ${comparison_date_date} < ${filter_start_date_date};;
  }

  dimension: is_previous_year {
    hidden: yes
    type: yesno
    sql: ${comparison_date_date} >= ${previous_year_start_date} AND ${comparison_date_date} < ${previous_year_end_date};;
  }
}
