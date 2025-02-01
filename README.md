<h1><span style="color:#2d7eea">README - Your LookML Project</span></h1>

<h2><span style="color:#2d7eea">LookML Overview</span></h2>

LookML is a data modeling language for describing dimensions, fields, aggregates and relationships based on SQL.

LookML is powerful because it:

- **Is all about reusability**: Most data analysis requires the same work to be done over and over again. You extract
raw data, prepare it, deliver an analysis... and then are never able touse any of that work again. This is hugely
inefficient, since the next analysis often involves many of the same steps. With LookML, once you define a
dimension or a measure, you continue to build on it, rather than having to rewrite it again and again.
- **Empowers end users**:  The data model that data analysts and developers create in LookML condenses and
encapsulates the complexity of SQL, it and lets analysts get the knowledge about what their data means out of
their heads so others can use it. This enables non-technical users to do their jobs &mdash; building dashboards,
drilling to row-level detail, and accessing complex metrics &mdash; without having to worry about what’s behind the curtain.
- **Allows for data governance**: By defining business metrics in LookML, you can ensure that Looker is always a
credible single source of truth.

The Looker application uses a model written in LookML to construct SQL queries against a particular database that
business analysts can [Explore](https://cloud.google.com/looker/docs/r/exploring-data) on. For an overview on the basics of LookML, see [What is LookML?](https://cloud.google.com/looker/docs/r/what-is-lookml)

<h2><span style="color:#2d7eea">Learn to Speak Looker</span></h2>

A LookML project is a collection of LookML files that describes a set of related [views](https://cloud.google.com/looker/docs/r/terms/view-file), [models](https://cloud.google.com/looker/docs/r/terms/model-file), and [Explores](https://cloud.google.com/looker/docs/r/terms/explore).
- A [view](https://cloud.google.com/looker/docs/r/terms/view-file) (.view files) contains information about how to access or calculate information from each table (or
across multiple joined tables). Here you’ll typically define the view, its dimensions and measures, and its field sets.
- A [model](https://cloud.google.com/looker/docs/r/terms/model-file) (.model file) contains information about which tables to use and how they should be joined together.
Here you’ll typically define the model, its Explores, and its joins.
- An [Explore](https://cloud.google.com/looker/docs/r/terms/explore) is the starting point for business users to query data, and it is the end result of the LookML you are
writing. To see the Explores in this project, select an Explore from the Explore menu.

<h2><span style="color:#2d7eea">Exploring Data</span></h2>

Ad-hoc data discovery is one of Looker’s most powerful and unique features. As you evaluate use cases for your
trial, consider what business areas you would like to explore. Open the Explore menu in the main navigation to see
the Explores you are building.

<h2><span style="color:#2d7eea">The Development Workflow</span></h2>

To support a multi-developer environment, Looker is integrated with Git for version control. Follow [these directions](https://cloud.google.com/looker/docs/r/develop/git-setup)
to set up Git for your project. To edit LookML, expand the Develop drop-down and toggle on [Development Mode](https://cloud.google.com/looker/docs/r/terms/dev-mode). In
Development Mode, changes you make to the LookML model exist only in your account until you commit the
changes and push them to your production model.

<h2><span style="color:#2d7eea">Additional Resources</span></h2>

To learn more about LookML and how to develop visit:
- [Looker User Guide](https://looker.com/guide)
- [Looker Help Center](https://help.looker.com)
- [Looker University](https://training.looker.com/)


1. views/base
Propósito: Esta carpeta generalmente se utiliza para definir vistas fundamentales o "base" que representan tablas directamente de la base de datos. Estas vistas no suelen tener muchas transformaciones o lógica adicional. Sirven como el punto de partida para construir otras vistas o Explores.

Uso típico:

Representación directa de las tablas en tu base de datos.
Contienen las dimensiones básicas y medidas directamente relacionadas con las columnas de las tablas.
Suelen ser reutilizadas en otras vistas o Explores mediante joins.

2. views/basic
Propósito: Esta carpeta se utiliza para vistas más específicas o derivadas que agregan lógica adicional sobre las vistas base. Aquí puedes incluir cálculos, transformaciones, filtros predefinidos o combinaciones de varias vistas base. Estas vistas son más orientadas a un caso de uso específico.

Uso típico:

Extensión de las vistas base para incluir métricas calculadas o medidas específicas.
Vistas que no representan una tabla directa, sino una combinación o transformación lógica de las tablas base.
Pueden incluir dimensiones y medidas personalizadas que tienen sentido para un análisis específico.

¿Por qué separar base y basic?
Claridad y Mantenimiento:

Tener vistas base permite un punto de referencia claro para las tablas de origen, lo que facilita mantener sincronización con la base de datos.
Las vistas basic pueden ser más complejas, pero al separarlas se evita que la lógica compleja se mezcle con la definición base.
Reutilización:

Las vistas base pueden ser reutilizadas en varios casos de uso sin duplicar definiciones.
Las vistas basic permiten adaptar lógica a casos específicos sin modificar las vistas base.
Escalabilidad:

Este enfoque hace que tu proyecto sea más escalable, ya que puedes agregar lógica compleja en basic sin afectar las definiciones básicas en base.
