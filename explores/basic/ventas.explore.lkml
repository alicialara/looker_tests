include: "/views/basic/*.view"


explore: ventas {
  # Etiqueta amigable para este Explore
  label: "Ventas Análisis"

  # Descripción para guiar a los usuarios
  description: "Explora y analiza las ventas, incluyendo las categorías, fechas, países y tipos de tarjeta."

  # Visibilidad de este Explore
  hidden: no

  # Joins con tablas relacionadas
  join: categoria {
    relationship: many_to_one
    type: left_outer
    sql_on: ${ventas.id_categoria} = ${categoria.id_categoria} ;;
  }

  join: fecha {
    relationship: many_to_one
    type: left_outer
    sql_on: ${ventas.id_fecha} = ${fecha.id_fecha} ;;
  }

  join: pais {
    relationship: many_to_one
    type: left_outer
    sql_on: ${ventas.id_pais} = ${pais.id_pais} ;;
  }

  join: tipo_tarjeta {
    relationship: many_to_one
    type: left_outer
    sql_on: ${ventas.id_tipo_tarjeta} = ${tipo_tarjeta.id_tipo_tarjeta} ;;
  }

  # Filtro SQL global opcional
  # sql_always_where: ${ventas.algun_campo} = 'algún_valor' ;;
}
