# ArquitecturaLookerAlicia - Documentación

## Estructura del Proyecto

El proyecto **ArquitecturaLookerAlicia** es una implementación de LookML diseñada para analizar datos de ventas. La estructura del proyecto sigue las mejores prácticas de organización LookML y está diseñada para ser escalable y mantenible.

### Organización de Directorios

```
ArquitecturaLookerAlicia/
│
├── explores/            # Definiciones de explores (conjuntos de datos consultables)
│   ├── basic/           # Explores básicos para análisis estándar
│   └── sales/           # Explores específicos para análisis de ventas
│
├── views/               # Definiciones de vistas (tablas o conceptos de datos)
│   ├── base/            # Vistas base que se pueden extender
│   ├── basic/           # Vistas básicas utilizadas en explores
│   └── shared/          # Vistas compartidas (ej. funcionalidad PoP)
│
├── models/              # Definiciones de modelos (conexiones a BD y configuración)
│
├── docs/                # Documentación del proyecto
│
└── manifest.lkml        # Configuración del proyecto y constantes globales
```

## Componentes Principales

### Models

El modelo principal `arquitectura_looker_alicia.model.lkml` define:
- La conexión a la base de datos: `formacion_analytics_2025_test`
- La inclusión de vistas y explores
- Política de caché predeterminada
- Configuración de persistencia

### Views

Las vistas representan objetos de datos y están organizadas en:

1. **Vistas Base** (`/views/base/`): Contienen definiciones fundamentales que pueden extenderse
2. **Vistas Básicas** (`/views/basic/`): Vistas principales como:
   - `ventas.view.lkml`: Métricas y dimensiones de ventas
   - `categoria.view.lkml`: Información sobre categorías de productos
   - `fecha.view.lkml`: Dimensiones temporales para análisis
   - `pais.view.lkml`: Información geográfica
   - `tipo_tarjeta.view.lkml`: Tipos de tarjetas de pago
3. **Vistas Compartidas** (`/views/shared/`): Funcionalidades reutilizables como PoP

### Explores

Los explores son objetos consultables que combinan varias vistas:

- `ventas.explore.lkml`: Define el explore principal para análisis de ventas, incluyendo joins con dimensiones como categoría, fecha, país y tipo de tarjeta, así como la configuración PoP

## Análisis Period-over-Period (PoP)

### Estructura y Funcionamiento de PoP

El análisis Period-over-Period (PoP) es una funcionalidad clave implementada mediante varias capas:

1. **Vista Base `pop.view.lkml`**:
   - Define la lógica fundamental para comparaciones temporales
   - Incluye filtros de fechas dinámicos
   - Calcula intervalos entre períodos
   - Define dimensiones para identificar períodos (actual, anterior, año anterior)
   - Utiliza extensiones LookML para hacerse reutilizable

2. **Vista de Parámetros `pop_parameters.view.lkml`**:
   - Define parámetros de configuración para visualizaciones PoP:
     - `tipo_variacion`: Permite seleccionar entre variación relativa (%) o absoluta
     - `pretty_format`: Activa/desactiva el formato visual mejorado con colores e iconos

3. **Constantes en `manifest.lkml`**:
   - Define formatos de visualización para variaciones:
     - `variacion_format`: Formato estándar
     - `variacion_format_euros`: Formato con símbolo de euro
     - `variacion_format_inverse`: Formato con colores invertidos (útil para métricas donde negativo es positivo)
   - Define etiquetas agrupadas para visualizaciones:
     - Medidas actuales, período anterior, año anterior
     - Variaciones interanuales e interperíodo

4. **Implementación en la Vista de Ventas**:
   - Extiende `pop` mediante `extends: [pop]`
   - Define dimensiones temporales de comparación
   - Implementa medidas filtradas para diferentes períodos

### Flujo de Trabajo PoP

El análisis PoP funciona de la siguiente manera:

1. El usuario selecciona un rango de fechas mediante el filtro `date_filter`
2. El sistema calcula automáticamente:
   - Período actual (basado en el filtro)
   - Período anterior (mismo intervalo justo antes del período actual)
   - Período del año anterior (mismo intervalo un año antes)
3. Las medidas filtradas calculan valores para cada período
4. La visualización aplica formatos según los parámetros seleccionados

### Mejoras Potenciales para PoP

1. **Flexibilidad Mejorada**:
   - Implementar comparaciones personalizables (MTD, QTD, YTD)
   - Permitir definir períodos de comparación personalizados
   - Añadir soporte para múltiples períodos de comparación simultáneos

2. **Experiencia de Usuario**:
   - Crear dashboards predefinidos con visualizaciones PoP comunes
   - Mejorar las etiquetas y descripciones para facilitar la comprensión
   - Implementar tooltips explicativos para la interpretación de variaciones

3. **Rendimiento**:
   - Optimizar consultas SQL para reducir la complejidad
   - Implementar cálculos anticipados para comparaciones comunes
   - Considerar el uso de tablas derivadas para análisis complejos

4. **Extensibilidad**:
   - Crear una biblioteca más completa de formatos de visualización
   - Implementar soporte para más tipos de gráficos y visualizaciones
   - Añadir soporte para análisis estacionales y detección de anomalías

5. **Documentación y Formación**:
   - Desarrollar guías de uso específicas para PoP
   - Crear ejemplos y casos de uso documentados
   - Implementar dashboard de ejemplo con análisis PoP

## Buenas Prácticas Implementadas

- **Modularidad**: Separación clara de vistas, explores y modelos
- **Reutilización**: Uso de extensiones y vistas compartidas
- **Nomenclatura**: Convención de nombres coherente
- **Documentación**: Descripciones detalladas de campos y conceptos
- **Mantenibilidad**: Organización lógica en directorios funcionales 