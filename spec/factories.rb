FactoryBot.define do
    sequence :email do |n|
        "email#{n}@factory.com"
    end

    sequence :amount do |n|
        n
    end

    factory :user do
      first_name 'John'
      last_name  'Doe'
      email
      password 'abc123'
    end

    factory :credit_line do
        name 'Test name'
        apr 0.25
        credit_limit 1000
        user_id 1
    end

    factory :payment do
        amount
        credit_line_id 1
    end

    factory :withdrawal do
        amount
        credit_line_id 1
    end

end