#
# Symbolize Keys functionality
#
class Hash
  def symbolize_keys
    inject({}) do |result, (key, v)|
      key = key.to_sym rescue key

      if v.is_a?(Hash)
        result[key] = v.symbolize_keys
      else
        result[key] = v
      end

      result
    end
  end

  def symbolize_keys!
    self.replace symbolize_keys
  end
end



