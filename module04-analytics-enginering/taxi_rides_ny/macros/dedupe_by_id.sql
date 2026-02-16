{% macro dedupe_by_id(model_name, id_column) %}
  select
      {{ id_column }},
      {% for col in adapter.get_columns_in_relation(ref(model_name)) %}
        {% if col.name.lower() != id_column.lower() %}
          any_value({{ col.name }}) as {{ col.name }}{% if not loop.last %},{% endif %}
        {% endif %}
      {% endfor %}
  from {{ ref(model_name) }}
  group by 1
{% endmacro %}