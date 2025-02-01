include: "/views/base/fecha.view"

view: +fecha {
  # Añade dimensiones derivadas o medidas personalizadas aquí

  # Ejemplo: Nueva dimensión que concatena Año y Mes
  dimension: year_month {
    type: string
    sql: CONCAT(${anyo}, '-', LPAD(${mes}, 2, '0')) ;;
    description: "Año y Mes concatenados (YYYY-MM)."
  }

  # Ejemplo: Nueva medida para contar días únicos
  measure: unique_days_count {
    type: count_distinct
    sql: ${dia} ;;
    description: "Número de días únicos."
  }

  # Puedes agregar filtros predefinidos si es necesario
  # sql_always_where: ${anyo} >= 2020 ;;
}
