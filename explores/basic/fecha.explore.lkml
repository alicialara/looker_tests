include: "/views/basic/*.view"


explore: fecha {
  # Etiqueta amigable para este Explore
  label: "Fecha Análisis"

  # Descripción para guiar a los usuarios
  description: "Explora y analiza datos relacionados con fechas, incluyendo años, meses y días."

  # Visibilidad de este Explore
  hidden: no

  # Joins con tablas relacionadas
  join: ventas {
    relationship: one_to_many
    type: left_outer
    sql_on: ${fecha.id_fecha} = ${ventas.id_fecha} ;;
  }

  # Filtro SQL global opcional
  # sql_always_where: ${fecha.algun_campo} = 'algún_valor' ;;
}
