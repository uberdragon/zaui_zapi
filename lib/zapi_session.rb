class ZapiSession

  def initialize session_hash:
    _generate hash: session_hash
  end

  def _generate hash:
    return nil unless hash.is_a? Hash
    hash.each do |k,v|
      self.instance_variable_set("@#{k}", v)  ## create and initialize an instance variable for this key/value pair
      self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})  ## create the getter that returns the instance variable
      self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})  ## create the setter that sets the instance variable
    end
    return self
  end

  def to_h
    hash = {}
    self.instance_variables.each do |var|
      sym = var.to_s.delete("@").to_sym
      hash[sym] = self.instance_variable_get(var)
    end

    hash
  end

end
