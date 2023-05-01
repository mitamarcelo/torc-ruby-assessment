class ExemptRepositoryInterface
  attr_accessor :exempt_list

  def initialize
    self.exempt_list = []
  end

  def fetch_exempt_list
    raise 'Method not implemented!'
  end
end
