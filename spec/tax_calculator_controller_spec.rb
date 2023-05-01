require './src/application/controller/tax_calculator_controller'
require './spec/mocks/exempt_repository_mock'
require './spec/mocks/receipt_repository_mock'

describe TaxCalculatorController do
  before(:each) do
    exempt_repository = ExemptRepositoryMock.new
    receipt_repository = ReceiptRepositoryMock.new
    @tax_calculator_controller = TaxCalculatorController.new(exempt_repository, receipt_repository)
  end

  describe '.number_to_s' do
    context 'given number with less than 2 decimal places' do
      it 'returns number with 2 decimal places' do
        expect(@tax_calculator_controller.send(:number_to_s, 1.2)).to eq('1.20')
      end
    end
    context 'given number with more than 2 decimal places' do
      it 'returns rounded down number with 2 decimal places' do
        expect(@tax_calculator_controller.send(:number_to_s, 1.214)).to eq('1.21')
      end
      it 'returns rounded up number with 2 decimal places' do
        expect(@tax_calculator_controller.send(:number_to_s, 1.216)).to eq('1.22')
      end
    end
  end

  describe '.calculate_tax_value' do
    context 'given common product' do
      it 'returns tax amount with 10% of value' do
        expect(@tax_calculator_controller.send(:calculate_tax_value, 'common product', 100)).to eq(10)
      end

      it 'returns rounded tax amount with 10% of value' do
        expect(@tax_calculator_controller.send(:calculate_tax_value, 'common product', 90)).to eq(10)
      end
    end

    context 'given exempt product' do
      it 'returns zero' do
        expect(@tax_calculator_controller.send(:calculate_tax_value, 'common exempt product', 100)).to eq(0)
      end
    end

    context 'given imported product' do
      it 'returns tax amount with 15% of value' do
        expect(@tax_calculator_controller.send(:calculate_tax_value, 'imported common product', 100)).to eq(15)
      end
    end

    context 'given imported exempt product' do
      it 'returns tax amount with 5% of value' do
        expect(@tax_calculator_controller.send(:calculate_tax_value, 'imported exempt product', 100)).to eq(5)
      end
    end
  end

  describe '.calculate_item_tax' do
    context 'given item' do
      before(:all) do
        @item = '3 imported exempt product at 11.25'
      end
      it 'returns product description on the first element of an array' do
        product, = @tax_calculator_controller.send(:calculate_item_tax, @item)
        expect(product).to eq('3 imported exempt product')
      end

      it 'returns total value on the second element of an array' do
        _, total_value, = @tax_calculator_controller.send(:calculate_item_tax, @item)
        expect(total_value).to eq(35.55)
      end

      it 'returns total tax value on the last element of an array' do
        _, _, total_tax = @tax_calculator_controller.send(:calculate_item_tax, @item)
        expect(total_tax).to eq(1.8)
      end
    end
  end

  describe '.generate_receipt' do
    context 'given items' do
      before(:all) do
        @items = [
          '1 imported common product at 27.99',
          '3 imported exempt product at 11.25',
          '1 exempt product at 9.75',
          '1 common product at 18.99'
        ]
      end

      it 'returns an array with the 4 first elements as products' do
        expected = [
          '1 imported common product: 32.19',
          '3 imported exempt product: 35.55',
          '1 exempt product: 9.75',
          '1 common product: 20.89'
        ]
        expect(@tax_calculator_controller.generate_receipt(@items)[0..3]).to eq(expected)
      end

      it 'returns an array with the second last element as a sales taxes row' do
        expected = 'Sales Taxes: 7.90'
        expect(@tax_calculator_controller.generate_receipt(@items)[-2]).to eq(expected)
      end

      it 'returns an array with the last element as the Total row' do
        expected = 'Total: 98.38'
        expect(@tax_calculator_controller.generate_receipt(@items)[-1]).to eq(expected)
      end
    end
  end
end
