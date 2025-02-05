include: "/views/base/ventas.view"

view: +ventas {
  # Extensión de la vista base "ventas"
  # Aquí puedes añadir dimensiones y medidas adicionales para enriquecer los análisis.

  dimension: id_categoria {
    type: number
    hidden: yes
    sql: ${TABLE}.id_categoria ;;
  }

  dimension: id_categoria2 {
    type: number
    hidden: yes
    sql: ${TABLE}.id_categoria ;;
  }

  # Nueva dimensión: Año derivado de la fecha (si hay un campo de fecha relacionado)
  dimension: venta_year {
    type: number
    sql: EXTRACT(YEAR FROM ${id_fecha}) ;;
    description: "Año derivado del campo ID Fecha."
  }

  # Nueva medida: Ingresos totales
  measure: total_sales {
    type: sum
    sql: ${ventas} ;;
    description: "Ingresos totales de las ventas."
  }

  # Nueva medida: Ventas promedio por transacción
  measure: average_sales {
    type: average
    sql: ${ventas} ;;
    description: "Promedio de ventas por transacción."
  }

  # Nueva medida: Total de categorías únicas en las ventas
  measure: unique_categories_count {
    type: count_distinct
    sql: ${id_categoria} ;;
    description: "Número total de categorías únicas en las ventas."
  }

  # Nueva dimensión: Clasificación de ventas
  dimension: sales_classification {
    type: string
    sql: CASE
      WHEN ${ventas} < 100 THEN 'Bajas'
      WHEN ${ventas} BETWEEN 100 AND 500 THEN 'Medias'
      ELSE 'Altas'
    END ;;
    description: "Clasificación de las ventas según el monto (Bajas, Medias, Altas)."
  }

  # Ejemplo de filtro global (opcional): Solo ventas mayores a cero
  # sql_always_where: ${ventas} > 0 ;;
}
