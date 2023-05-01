class ReceiptRepository < ReceiptRepositoryInterface
  def export_receipt(lines)
    File.open("receipt.#{Time.now.to_i}", 'a') { |f| f.puts(lines) }
  end
end
