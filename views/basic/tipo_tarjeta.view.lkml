include: "/views/base/tipo_tarjeta.view"

view: +tipo_tarjeta {
  # Extensión de la vista base tipo_tarjeta
  # Aquí puedes añadir medidas o dimensiones personalizadas.

  # Ejemplo: Nueva dimensión que convierte la descripción a mayúsculas
  dimension: tipo_tarjeta_uppercase {
    type: string
    sql: UPPER(${desc_tipo_tarjeta}) ;;
    description: "Descripción del tipo de tarjeta en mayúsculas."
  }

  # Ejemplo: Nueva medida que cuenta los tipos únicos de tarjeta
  measure: unique_card_types_count {
    type: count_distinct
    sql: ${id_tipo_tarjeta} ;;
    description: "Número total de tipos únicos de tarjeta."
  }
}
