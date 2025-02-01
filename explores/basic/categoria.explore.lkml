include: "/views/basic/*.view"

# Explore for the Categoria view.

# Hago los joins en basic porque son comunes a TODOS los casos (no son joins específicos de un punto de vista)

explore: categoria {
  # A user-friendly label for this Explore
  label: "Category Analysis"

  # A description to guide users
  description: "Explore and analyze categories, including their descriptions and IDs."

  # Visibility setting
  hidden: no

  # Join with related tables if needed (adjust the joins as necessary)
  join: ventas {
    relationship: one_to_many
    type: left_outer
    sql_on: ${categoria.id_categoria} = ${ventas.id_categoria} ;;
  }

  # Add other joins if related to Fecha, Pais, or Tipo Tarjeta tables
  join: fecha {
    relationship: one_to_many
    type: left_outer
    sql_on: ${ventas.id_fecha} = ${fecha.id_fecha} ;;
  }

  join: pais {
    relationship: one_to_many
    type: left_outer
    sql_on: ${ventas.id_pais} = ${pais.id_pais} ;;
  }

  join: tipo_tarjeta {
    relationship: one_to_many
    type: left_outer
    sql_on: ${ventas.id_tipo_tarjeta} = ${tipo_tarjeta.id_tipo_tarjeta} ;;
  }

  # Optional: You can specify any SQL filters to apply to this Explore
  # En el caso de tener un punto de vista (no en el basic) se puede hacer un explore que filtre por defecto cierto valor, columnas o tengan joins específicos. Para los filtros, se puede usar lo siguiente:
  # sql_always_where: ${categoria.some_column} = 'some_value' ;;
}
