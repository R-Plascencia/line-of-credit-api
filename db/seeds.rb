# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create({
        :first_name => 'Raul', 
        :last_name => 'Plascencia', 
        :email => 'raul@admin.com',
        :password => 'abc123'
})
user = User.create({
        :first_name => 'Tom', 
        :last_name => 'Hanks', 
        :email => 'tom@admin.com',
        :password => 'abc123'
})
user = User.create({
        :first_name => 'Mickey', 
        :last_name => 'Mouse', 
        :email => 'mickey@admin.com',
        :password => 'abc123'
})

line = CreditLine.create({
    :name => 'Test Line 1',
    :apr => 0.25,
    :credit_limit => 250,
    :user_id => User.find(1).id
})
line = CreditLine.create({
    :name => 'Test Line 2',
    :apr => 0.35,
    :credit_limit => 500,
    :user_id => User.find(2).id
})
line = CreditLine.create({
    :name => 'Test Line 3',
    :apr => 0.10,
    :credit_limit => 100,
    :user_id => User.find(3).id
})

pmt = Payment.new({
    :credit_line_id => CreditLine.find(1).id,
    :amount => 50
})
pmt.new_bal = CreditLine.find(1).principal_bal - pmt.amount
pmt.save

