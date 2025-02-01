include: "/views/basic/*.view"

explore: tipo_tarjeta {
  # Etiqueta amigable para este Explore
  label: "Tipo de Tarjeta Análisis"

  # Descripción para guiar a los usuarios
  description: "Explora y analiza los tipos de tarjeta utilizados en las ventas."

  # Visibilidad de este Explore
  hidden: no

  # Filtro SQL global opcional
  # sql_always_where: ${tipo_tarjeta.algun_campo} = 'algún_valor' ;;
}
