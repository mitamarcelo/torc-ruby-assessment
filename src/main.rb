# Require repository files
%w[exempt_repository_interface exempt_repository
   receipt_repository_interface receipt_repository]
  .each { |file| require "./src/infrastructure/repository/#{file}.rb" }
# Require controller files
require './src/application/controller/tax_calculator_controller'

exempt_repository = ExemptRepository.new
receipt_repository = ReceiptRepository.new

tax_calculator_controller = TaxCalculatorController.new(exempt_repository, receipt_repository)

basket = []
File.open('input').each { |row| basket << row }

tax_calculator_controller.generate_receipt(basket)
