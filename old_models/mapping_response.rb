require 'base64'

class MappingResponse
  include Mongoid::Document
  include Mongoid::Timestamps

  field :marshaled_data, type: Binary

  belongs_to :parent,   class_name: "MappingResponse", inverse_of: :children
  has_many   :children, class_name: "MappingResponse", inverse_of: :parent
  has_one    :card,     class_name: "DataCard", inverse_of: :response
  belongs_to :request,  class_name: "MappingRequest", inverse_of: :responses

  def data
    # Yes, it has to go through Base64 cuz mongoid sucks with encoding
    # checkings. Performance loss is not too high, though.
    @data ||= Marshal.load(Base64.decode64(self.marshaled_data))
  end

  def data=(data_to_marshal)
    @data = nil
    self.marshaled_data = Base64.encode64(Marshal.dump(data_to_marshal))
  end

  def update!
    self.request.perform!(self)
  end
end
