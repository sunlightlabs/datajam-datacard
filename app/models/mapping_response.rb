require 'base64'

class MappingResponse
  include Mongoid::Document
  include Mongoid::Timestamps

  field :marshaled_data, type: Binary

  def data
    # Yes, it has to go through Base64 cuz mongoid sucks with encoding
    # checkings. Performance loss is not too high, though.
    @data ||= Marshal.load(Base64.decode64(self.marshaled_data))
  end

  def data=(data_to_marshal)
    @data = nil
    self.marshaled_data = Base64.encode64(Marshal.dump(data_to_marshal))
  end
end
