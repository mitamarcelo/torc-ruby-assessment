require './src/infrastructure/repository/exempt_repository_interface'

class ExemptRepositoryMock < ExemptRepositoryInterface
  def fetch_exempt_list
    self.exempt_list = ['exempt']
  end
end
