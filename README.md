skelly.js
=========

needs jquery

#### Template elements are elements inside anything with a "js-templates" class

```html
<div class="js-templates" style="display: none;"></div>
```

Will do in a pinch.

#### A Template element is anythig with a data-js_template_name attribute
```html
<div class="js-templates" style="display: none;">
    <article data-js_template_name="preview_comment">
    </article>
</div>
```

Template elements are accessed by the `from_template` function.
```
> console.log(from_template('my_post'));
  [article, prevObject: jQuery.fn.jQuery.init[1], context: article,
              jquery: "2.0.3", constructor: function, init: function…]
```

As you see we're returned a jquery element. Right now it doesn't do much, it is a copy of the original:
```
> console.log(from_template('my_post')[0]);
  <article data-js_template_name="my_post"></article>
```

#### Templates can have fields, different fields do different things

##### The fillmany field is copied and filled with content as needed:

```html
<div class="js-templates" style="display: none;">
    <article data-js_template_name="my_post">
        <p data-js_template_fieldname="paragraphs" data-js_template_fieldtype="fillmany"></p>
    </article>
</div>
```
```
> console.log(from_template('my_post', {'paragraphs': ['a', 'b', 3]})[0]);
  <article data-js_template_name="my_post">
    <p data-js_template_fieldname="paragraphs" data-js_template_fieldtype="fillmany">a</p>
    <p data-js_template_fieldname="paragraphs" data-js_template_fieldtype="fillmany">b</p>
    <p data-js_template_fieldname="paragraphs" data-js_template_fieldtype="fillmany">3</p>
  </article>
```

note that each field must have a data-js_template_fieldtype and data-js_template_fieldname
attribute

##### addclass adds the given class name to that field element:
```html
<div class="js-templates" style="display: none;">
    <article data-js_template_name="my_post"
        data-js_template_fieldname="ispreview"
        data-js_template_fieldtype="addclass">
    </article>
</div>
```
```
> console.log(from_template('my_post', {'ispreview': 'preview'})[0]);
  <article data-js_template_name="my_post"data-js_template_fieldname="ispreview"
                      data-js_template_fieldtype="addclass" class="preview"></article>
```

#### Fields can be of more than one type

So we have something like this:

```html
<div class="js-templates" style="display: none;">
    <article data-js_template_name="my_post">
        <a data-js_template_fieldtype="append, toggle"
            data-js_template_fieldname="img_content, has_image"></a>
    </article>
</div>
```
```
> var img = $('<img src="a.jpg" alt="mah_image" />')
> console.log(from_template('my_post', {
    'img_content': img,
    'has_image': true
  })[0]);
  <article data-js_template_name="my_post">
    <a data-js_template_fieldtype="append, toggle" data-js_template_fieldname="img_content, has_image">
      <img src="a.jpg" alt="mah_image">
    </a>
  </article>
  
> console.log(from_template('my_post', {
    'img_content': '',
    'has_image': false
  })[0]);
  <article data-js_template_name="my_post"></article>
    
```

Note that the field name corresponds to the field type in the same position, so here
`img_content` is of type `append` and `has_image` is of type `toggle`.

##### toggle removes the field if given the value false.
##### append appends a given jquery element to that field
##### setattr adds an attribute, determined by field name, with a given value
Setattr is special in a way because the given data-js_template_fieldname is significant here:
it is the attribute that will be added to the element.
