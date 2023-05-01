class ExemptRepository < ExemptRepositoryInterface
  def fetch_exempt_list
    File.open('./src/infrastructure/database/exempt_list').each { |row| exempt_list << row.strip }
  end
end
