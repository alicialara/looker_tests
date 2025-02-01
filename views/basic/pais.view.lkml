include: "/views/base/pais.view"

view: +pais {
  # Añade dimensiones o medidas personalizadas aquí

  # Ejemplo: Nueva dimensión que concatena descripción y ubicación geográfica
  dimension: pais_geo_desc {
    type: string
    sql: ${desc_pais};;
    description: "Descripción del país."
  }

  # Ejemplo: Nueva medida para contar países únicos
  measure: unique_countries_count {
    type: count_distinct
    sql: ${id_pais} ;;
    description: "Número total de países únicos."
  }

  # Ejemplo: Filtro global opcional
  # sql_always_where: ${geo_pais} IS NOT NULL ;;
}
