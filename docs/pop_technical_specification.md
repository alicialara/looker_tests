# Especificación Técnica: Period-over-Period (PoP)

## Visión General

La funcionalidad Period-over-Period (PoP) permite comparar métricas entre diferentes períodos de tiempo de manera dinámica y configurable. Esta especificación técnica detalla la implementación, estructura y flujo de datos para esta funcionalidad dentro del proyecto ArquitecturaLookerAlicia.

## Arquitectura

La implementación de PoP se estructura en capas para maximizar la reutilización y mantenibilidad:

```
PoP/
│
├── pop.view.lkml                # Vista base con lógica fundamental de comparación
├── pop_parameters.view.lkml     # Parámetros de configuración y formato
└── Constantes en manifest.lkml  # Definiciones de formato y agrupación
```

### Vista Base: `pop.view.lkml`

Esta vista define la lógica core para comparaciones temporales mediante una extensión (`extension: required`) que debe ser implementada por otras vistas.

#### Componentes Clave:

1. **Filtro de Fechas Dinámico**:
   ```lookml
   filter: date_filter {
     view_label: "_PoP"
     label: "Date filter"
     description: "Use this date filter in combination with the timeframes dimension for dynamic date filtering"
     type: date
   }
   ```

2. **Cálculo de Intervalos y Períodos**:
   ```lookml
   dimension_group: filter_start_date {
     hidden: yes
     view_label: "_PoP"
     type: time
     timeframes: [raw, date, month]
     sql: CASE WHEN {% date_start date_filter %} IS NULL 
          THEN DATEADD(MONTH, -3, GETDATE()) 
          ELSE CAST({% date_start date_filter %} AS DATE) END;;
   }

   dimension_group: filter_end_date {
     hidden: yes
     view_label: "_PoP"
     type: time
     timeframes: [raw, date, month]
     sql: CASE WHEN {% date_end date_filter %} IS NULL 
          THEN GETDATE() 
          ELSE CAST({% date_end date_filter %} AS DATE) END;;
   }
   
   dimension: interval {
     hidden: yes
     view_label: "_PoP"
     type: number
     sql: DATEDIFF(DAY, ${filter_start_date_raw}, ${filter_end_date_raw});;
   }
   ```

3. **Definición de Períodos de Comparación**:
   ```lookml
   dimension_group: previous_start {
     hidden: yes
     view_label: "_PoP"
     type: time
     timeframes: [raw, date]
     sql: DATEADD(DAY, -${interval}, ${filter_start_date_raw});;
   }

   dimension_group: previous_year_start {
     hidden: yes
     view_label: "_PoP"
     type: time
     timeframes: [raw, date]
     sql: DATEADD(DAY, -365, ${filter_start_date_date});;
   }

   dimension_group: previous_year_end {
     hidden: yes
     view_label: "_PoP"
     type: time
     timeframes: [raw, date]
     sql: DATEADD(DAY, ${interval}, ${previous_year_start_date});;
   }
   ```

4. **Identificadores de Período**:
   ```lookml
   dimension: is_current_period {
     hidden: yes
     type: yesno
     sql: ${comparison_date_date} >= ${filter_start_date_date} 
          AND ${comparison_date_date} < ${filter_end_date_date};;
   }

   dimension: is_previous_period {
     hidden: yes
     type: yesno
     sql: ${comparison_date_date} >= ${previous_start_date} 
          AND ${comparison_date_date} < ${filter_start_date_date};;
   }

   dimension: is_previous_year {
     hidden: yes
     type: yesno
     sql: ${comparison_date_date} >= ${previous_year_start_date} 
          AND ${comparison_date_date} < ${previous_year_end_date};;
   }
   ```

5. **Dimensión de Etiquetado de Períodos**:
   ```lookml
   dimension: timeframes {
     view_label: "_PoP"
     label: "Timeframes"
     type: string
     case: {
       when: {
         sql: ${is_current_period} = 1;;
         label: "Periodo actual"
       }
       when: {
         sql: ${is_previous_period} = 1;;
         label: "Periodo anterior"
       }
       when: {
         sql: ${is_previous_year} = 1;;
         label: "Año anterior"
       }
       else: "Not in time period"
     }
   }
   ```

### Parámetros: `pop_parameters.view.lkml`

Esta vista define los parámetros de configuración que controlan el comportamiento de la visualización:

```lookml
view: pop_parameters {
  parameter: tipo_variacion {
    view_label: "_PoP"
    type: unquoted
    default_value: "relativa"
    allowed_value: {
      label: "Relativa"
      value: "relativa"
    }
    allowed_value: {
      label: "Absoluta"
      value: "absoluta"
    }
  }

  parameter: pretty_format {
    view_label: "_PoP"
    type: unquoted
    default_value: "no"
    allowed_value: {
      label: "Yes"
      value: "yes"
    }
    allowed_value: {
      label: "No"
      value: "no"
    }
  }
}
```

### Constantes de Formato: `manifest.lkml`

Las constantes definen los formatos visuales y etiquetas para las medidas PoP:

```lookml
constant: variacion_format {
  value: "
  {% if pop_parameters.tipo_variacion._parameter_value == 'relativa' %}
    {% if pop_parameters.pretty_format._parameter_value == 'yes' %}
      {% if value > 0 %}
        <p style=\"color:#5f9524\">▲ {{rendered_value}}%</p>
      {% elsif value < 0 %}
        <p style=\"color:#9b4e49\">▼ {{rendered_value}}%</p>
      {% else %}
        <p style=\"color: black\">{{rendered_value}}%</p>
      {% endif %}
    {% else %}
      {% if value > 0 %}
        {{rendered_value}}%
      {% elsif value < 0 %}
        {{rendered_value}}%
      {% else %}
        {{rendered_value}}%
      {% endif %}
    {% endif %}
  {% else %}
    ...
  {% endif %}"
}
```

## Implementación Técnica

### Extensión en Vistas

Para implementar PoP en una vista específica:

1. **Extender la Vista Base**:
   ```lookml
   view: +ventas {
     extends: [pop]
     ...
   }
   ```

2. **Definir Dimensión de Fecha de Comparación**:
   ```lookml
   dimension_group: comparison_date {
     type: time
     hidden: yes
     timeframes: [raw, date]
     sql: (SELECT fecha FROM dbo.d_fecha WHERE id_fecha = ${TABLE}.id_fecha) ;;
   }
   ```

3. **Crear Medidas Filtradas por Período**:
   ```lookml
   measure: ventas_current_period {
     group_label: "@{current_measures}"
     label: "Total ventas (periodo actual)"
     type: sum
     sql:
       CASE
         WHEN ${fecha.fecha_date} >= ${filter_start_date_date}
         AND ${fecha.fecha_date} < ${filter_end_date_date}
         THEN ${ventas}
         ELSE NULL
       END ;;
     value_format_name: decimal_0
   }

   measure: ventas_previous_period {
     group_label: "@{prev_year_measures}"
     label: "Total ventas (período anterior)"
     type: sum
     sql:
       CASE
         WHEN ${fecha.fecha_date} >= ${previous_start_date}
         AND ${fecha.fecha_date} < ${filter_start_date_date}
         THEN ${ventas}
         ELSE NULL
       END ;;
     value_format_name: decimal_0
   }
   ```

4. **Implementar Medidas de Variación**:
   ```lookml
   measure: ventas_variacion_interperiodo {
     group_label: "@{interperiod_variations}"
     label: "Variación ventas entre períodos"
     type: number
     sql: ${ventas_current_period} - ${ventas_previous_period} ;;
     html: @{variacion_format} ;;
     value_format_name: decimal_0
   }

   measure: ventas_variacion_interperiodo_percent {
     group_label: "@{interperiod_variations}"
     label: "Variación % ventas entre períodos"
     type: number
     sql: CASE 
          WHEN ${ventas_previous_period} = 0 THEN NULL
          ELSE (${ventas_current_period} - ${ventas_previous_period}) / NULLIF(${ventas_previous_period}, 0) * 100
          END ;;
     html: @{variacion_format} ;;
     value_format_name: decimal_2
   }
   ```

### Configuración en Explores

Para activar PoP en un explore:

```lookml
explore: ventas {
  join: pop_parameters {
    view_label: "_PoP"
    sql:  ;;
    type: full_outer
    relationship: one_to_one
  }
}
```

## Flujo de Datos y Procesamiento

1. **Entrada de Datos**:
   - El usuario selecciona un rango de fechas mediante `date_filter`
   - El usuario configura `tipo_variacion` (absoluta/relativa) y `pretty_format` (yes/no)

2. **Procesamiento**:
   - Looker calcula los períodos de comparación:
     - Actual: basado en el filtro seleccionado
     - Anterior: intervalo igual antes del período actual
     - Año anterior: mismo intervalo un año atrás
   - Las dimensiones `is_current_period`, `is_previous_period` e `is_previous_year` clasifican los registros
   - Las medidas filtradas calculan agregados para cada período

3. **Salida y Visualización**:
   - Las medidas se organizan en grupos según constantes definidas
   - El formato se aplica dinámicamente según los parámetros seleccionados
   - El formato condicional muestra:
     - Colores (verde/rojo) según la dirección de la variación
     - Flechas (▲/▼) para incrementos/decrementos
     - Símbolos de unidad (%, €) según el tipo de medida

## Consideraciones Técnicas

1. **Rendimiento**:
   - Las operaciones CASE anidadas pueden impactar el rendimiento en conjuntos de datos grandes
   - Las comparaciones de fechas deben estar optimizadas a nivel SQL
   - Evitar cálculos redundantes o divisiones por cero (usando NULLIF)

2. **Mantenimiento**:
   - Cambios en la lógica de fechas deben aplicarse en `pop.view.lkml`
   - Formatos visuales pueden modificarse en las constantes de `manifest.lkml`
   - Nuevas vistas deben extender correctamente la vista base e implementar `comparison_date`

3. **Disponibilidad SQL**:
   - La implementación actual usa funciones SQL Server (DATEADD, DATEDIFF)
   - Para otros motores de bases de datos se requieren ajustes

## Ampliaciones Potenciales

1. **Implementación**:
   ```lookml
   # Para implementar períodos MTD/QTD/YTD
   dimension: is_current_mtd {
     type: yesno
     sql: ${comparison_date_date} >= DATE_TRUNC('month', ${filter_end_date_date}) 
          AND ${comparison_date_date} <= ${filter_end_date_date} ;;
   }
   
   # Para comparaciones múltiples (n períodos atrás)
   dimension: is_previous_period_n {
     type: yesno
     sql: ${comparison_date_date} >= DATEADD(DAY, -${interval} * ${n_periods}, ${filter_start_date_raw})
          AND ${comparison_date_date} < DATEADD(DAY, -${interval} * (${n_periods} - 1), ${filter_start_date_raw}) ;;
   }
   ```

2. **Optimización**:
   ```lookml
   # Uso de PDTs para cálculos complejos
   derived_table: {
     sql: SELECT 
            id_fecha,
            SUM(CASE WHEN fecha >= {% date_start date_filter %} AND fecha < {% date_end date_filter %}
                THEN ventas ELSE 0 END) as ventas_current,
            SUM(CASE WHEN fecha >= DATEADD(DAY, -${interval}, {% date_start date_filter %})
                AND fecha < {% date_start date_filter %}
                THEN ventas ELSE 0 END) as ventas_previous
          FROM tabla_ventas
          GROUP BY id_fecha ;;
     sql_trigger_value: SELECT CURRENT_DATE ;;
     indexes: ["id_fecha"]
   }
   