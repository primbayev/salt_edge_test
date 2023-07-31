FactoryBot.define do
  factory(:user) do
    password = Faker::Internet.password

    email { Faker::Internet.email }
    password { password }
    password_confirmation { password }
  end

  factory :customer do
    user

    identifier { user.email }
  end

  factory :connection do
    customer

    provider_id { Faker::IDNumber.valid }

    bank_name = Faker::Bank.name
    provider_code { bank_name&.parameterize(separator: '_') }
    provider_name { bank_name }

    status { 'active' }
  end

  factory :account do
    connection

    currency_code { 'EUR' }
    nature { 'credit' }
    name { Faker::Lorem.paragraph }
  end

  factory :transaction do
    account

    made_on { Faker::Date.backward }
    category { 'shopping' }
    description { Faker::Lorem.paragraph }
    status { 'posted' }
    duplicated { false }
    amount { Faker::Number.decimal }
    currency_code { 'EUR' }
  end
end
