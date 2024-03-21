require 'rails_helper'
FactoryBot.define do
  factory :ruby_label, class: Label do
    name { "ruby" }
  end

  factory :css_label, class: Label do
    name { "css" }
  end

  factory :physon_label, class: Label do
    name { "physon" }
  end
end