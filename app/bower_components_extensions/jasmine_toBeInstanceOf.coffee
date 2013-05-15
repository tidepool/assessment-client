if jasmine && jasmine.Matchers
  jasmine.Matchers.prototype.toBeInstanceOf = (klass) ->
    this.actual instanceof klass
