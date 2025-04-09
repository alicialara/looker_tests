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
