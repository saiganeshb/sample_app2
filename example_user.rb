class User
  attr_accessor :name, :email

  def initialize(attributes = {})
    @name  = attributes[:name]
    @email = attributes[:email]
    @foo = 5
  end

  def formatted_email
    "#{@name} <#{@email} #{@foo}>"
  end
end
