# Define the database connection for this model.

connection: "formacion_analytics_2025_test"

# Include all view and explore files for the project.
include: "/views/basic/*.view.lkml"
include: "/explores/basic/*.explore"

# Define the default caching policy.
datagroup: arquitectura_default_datagroup {
  sql_trigger: SELECT MAX(updated_at) FROM etl_log;;
  max_cache_age: "1 hour"
}

# Persist cache for all Explores in this model.
persist_with: arquitectura_default_datagroup
