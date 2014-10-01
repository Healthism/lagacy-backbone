_.mixin
  pluralize: (int, singular, options = {}) ->
    int = parseInt(int)
    amount = if options.amount_class then "<span class='#{options.amount_class}'>#{int}</span>" else int
    if int == 1 then amount+' '+singular else amount+' '+(if options.plural_word then options.plural_word else singular+'s')