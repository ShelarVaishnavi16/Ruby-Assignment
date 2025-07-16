class Calculator
    VALID_OPERATORS = %i[+ - * / % **].freeze
  
    def initialize(operand1, operand2, operator)
      @operand1 = operand1
      @operand2 = operand2
      @operator = operator.to_sym
    end
  
    def calculate
      return "Error: Unexpected operator '#{@operator}'" unless VALID_OPERATORS.include?(@operator)
  
      if division_by_zero?
        "Error: Zero division error."
      else
        @operand1.send(@operator, @operand2)
      end
    end
  
    private
  
    def division_by_zero?
      [:/, :%].include?(@operator) && @operand2 == 0
    end
  end
  

  begin
    print "Enter first number: "
    operand1 = Float(gets.chomp)
  
    print "Enter second number: "
    operand2 = Float(gets.chomp)
  
    print "Enter operator (+, -, , /, %, *): "
    operator = gets.chomp
  
    calculator = Calculator.new(operand1, operand2, operator)
    result = calculator.calculate
    puts "Result: #{result}"
  rescue ArgumentError
    puts "Error: Please enter valid numeric values."
  rescue => e
    puts "#{e.message}"
  end