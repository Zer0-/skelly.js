#js_templates
#js_template_name
#js_template_fieldname
#js_template_fieldtype
#   setattr          #set attribute with the name js_template_fieldname of this elem to given value
#   append           #append given elem to contents
#   replace          #replace the elem with elem
#   replace_content  #replace elem contents with elem
#   fillmany         #given an array of values, copy the template and fill it with a value for each value in the array.
#   toggle           #if fill_data[name] != True then we remove this element.
#   addclass         #add class fill_data[name] if fill_data[name] to the element

templates = {}

zip = () ->
    lengthArray = (arr.length for arr in arguments)
    length = Math.min(lengthArray...)
    for i in [0...length]
        arr[i] for arr in arguments

template_append = (field_elem, field_name, fill_data) ->
    field_elem.append fill_data[field_name]

template_set_attr = (field_elem, field_name, fill_data) ->
    field_elem.attr field_name, fill_data[field_name]

template_fillmany = (field_elem, field_name, fill_data) ->
    for content in fill_data[field_name]
        field_template = field_elem.clone()
        field_template.append content
        field_elem.after field_template
    field_elem.remove()

template_toggle = (field_elem, field_name, fill_data) ->
    if not fill_data[field_name]
        field_elem.remove()

template_addclass = (field_elem, field_name, fill_data) ->
    field_elem.addClass fill_data[field_name]

fill_fns = 
    append: template_append
    setattr: template_set_attr
    fillmany: template_fillmany
    addclass: template_addclass
    toggle: template_toggle

from_template = (template_name, fill_data) ->
    template = templates[template_name]
    if not template
        throw "template #{template_name} doesn't exist."
    template = template.clone()
    selector = $('[data-js_template_fieldname][data-js_template_fieldtype]', template)
    if (template.attr "data-js_template_fieldname")? and (template.attr 'data-js_template_fieldtype')?
        selector = selector.addBack()
    selector.each ->
        field = $ @
        names = field.data('js_template_fieldname').split ','
        names = $.map names, $.trim
        actions = field.data('js_template_fieldtype').split ','
        actions = $.map actions, $.trim
        for [name, action] in zip names, actions
            fn = fill_fns[action]
            if not fn
                continue
            fn field, name, fill_data
    return template

$(document).ready ->
    $('.js-templates [data-js_template_name]').each ->
        elem = $ @
        name = elem.data "js_template_name"
        templates[name] = elem

window.from_template = from_template
