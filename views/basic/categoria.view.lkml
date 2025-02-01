# Incluir la definición base de la vista "categoria" desde la carpeta base

include: "/views/base/categoria.view"

# Extender la vista base "categoria"
# El prefijo "+" indica que estamos extendiendo la vista base existente y no creando una nueva.
view: +categoria {

  # Aquí puedes añadir dimensiones adicionales, medidas calculadas,
  # o lógica personalizada para extender la funcionalidad de la vista base.

  # Ejemplo: Agregar una nueva medida que calcule el número de categorías únicas (si aplica)
  measure: unique_categories_count {
    type: count_distinct
    sql: ${id_categoria} ;;
    description: "Número total de categorías únicas."
  }

  # Ejemplo: Agregar una nueva dimensión derivada
  dimension: categoria_uppercase {
    type: string
    sql: UPPER(${desc_categoria}) ;;
    description: "Descripción de la categoría en mayúsculas."
  }

  # Puedes agregar filtros predefinidos si es necesario
  # sql_always_where: ${some_field} = 'some_value' ;;
}
