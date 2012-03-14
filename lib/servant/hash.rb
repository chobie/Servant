class Hash
  def rmerge(target)
    result = self.clone

    if target.kind_of?(Hash)
      target.each do |key, value|
        if value.kind_of?(Hash) then
          if result[key] == nil then
            result[key] = {}
          end
          
          result[key] = result[key].rmerge(value)
        else
          result[key] = (value != nil) ? value.clone : nil
        end
      end
      
    else
      raise ArgumentError('specified variable does not Hash instance')
    end
    
    return result
  end
end
