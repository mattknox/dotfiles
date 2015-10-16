ActiveRecord::Base.logger = Logger.new STDOUT  if Object.const_defined? "ActiveRecord::Base"

class Object
  def own_methods
    (self.methods.sort - Object.instance_methods).inspect
  end
end
