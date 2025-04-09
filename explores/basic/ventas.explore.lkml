include: "/views/basic/*.view"
include: "/views/shared/*.view"

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
    sql_on: ${ventas.id_fecha} = ${fecha.id_fecha} ;;
    relationship: many_to_one
    type: left_outer
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

  join: pop_parameters {

    view_label: "_PoP"
    sql:  ;;
    type: full_outer
    relationship: one_to_one
  }

  # Filtro SQL global opcional
  # sql_always_where: ${ventas.algun_campo} = 'algún_valor' ;;
}
