require './src/infrastructure/repository/receipt_repository_interface'

class ReceiptRepositoryMock < ReceiptRepositoryInterface
  def export_receipt(lines)
    lines
  end
end
