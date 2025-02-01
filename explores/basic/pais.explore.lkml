include: "/views/basic/*.view"

explore: pais {
  # Etiqueta amigable para este Explore
  label: "País Análisis"

  # Descripción para guiar a los usuarios
  description: "Explora y analiza datos relacionados con países, incluyendo descripciones y ubicaciones geográficas."

  # Visibilidad de este Explore
  hidden: no

  # Joins con tablas relacionadas
  join: ventas {
    relationship: one_to_many
    type: left_outer
    sql_on: ${pais.id_pais} = ${ventas.id_pais} ;;
  }

  # Filtro SQL global opcional
  # sql_always_where: ${pais.algun_campo} = 'algún_valor' ;;
}
