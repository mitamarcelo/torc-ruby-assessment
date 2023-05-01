class TaxCalculatorController
  attr_accessor :exempt_repository, :receipt_repository

  def initialize(exempt_repository, receipt_repository)
    self.exempt_repository = exempt_repository
    self.receipt_repository = receipt_repository
    self.exempt_repository.fetch_exempt_list
  end

  def generate_receipt(basket)
    lines = []
    total_tax = 0.0
    total_value = 0.0
    basket.each do |item|
      product, value, tax = calculate_item_tax(item)
      lines << "#{product}: #{number_to_s(value)}"
      total_tax += tax
      total_value += value
    end
    receipt_repository.export_receipt lines + ["Sales Taxes: #{number_to_s(total_tax)}", "Total: #{number_to_s(total_value)}"]
  end

  private

  def calculate_item_tax(item)
    split_item = item.split(' ')
    quantity = split_item.first.to_i
    price_cents = (split_item.last.to_f * 100).round
    product = split_item[0..-3].join(' ').downcase # Remove 'at ${price}' from the end
    tax_value = calculate_tax_value(product, price_cents)
    total_tax = ((tax_value * quantity) / 100.0).round(2)
    total_value = total_tax + ((price_cents * quantity) / 100.0).round(2)
    [product, total_value, total_tax]
  end

  def exempt?(product)
    exempt_repository.exempt_list.each do |key_word|
      return true if product.include?(key_word)
    end
    false
  end

  def imported?(product)
    product.include?('imported')
  end

  def round_nearest_multiple_of_five(value)
    5 * ((value + 4) / 5)
  end

  def calculate_tax_value(product, price)
    tax_rate = exempt?(product) ? 0.0 : 0.1
    tax_rate += 0.05 if imported?(product)
    round_nearest_multiple_of_five((price * tax_rate).round)
  end

  def number_to_s(number)
    '%.2f' % number.round(2)
  end
end
