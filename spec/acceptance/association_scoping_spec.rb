# frozen_string_literal: true

require 'acceptance/spec_helper'

describe 'Scoping association search calls by foreign keys', :live => true do
  describe 'for ActiveRecord indices' do
    it "limits results to those matching the foreign key" do
      pat       = User.create :name => 'Pat'
      melbourne = Article.create :title => 'Guide to Melbourne', :user => pat
      paul      = User.create :name => 'Paul'
      dublin    = Article.create :title => 'Guide to Dublin',    :user => paul
      index

      expect(pat.articles.search('Guide').to_a).to eq([melbourne])
    end

    it "limits id-only results to those matching the foreign key" do
      pat       = User.create :name => 'Pat'
      melbourne = Article.create :title => 'Guide to Melbourne', :user => pat
      paul      = User.create :name => 'Paul'
      dublin    = Article.create :title => 'Guide to Dublin',    :user => paul
      index

      expect(pat.articles.search_for_ids('Guide').to_a).to eq([melbourne.id])
    end
  end

  describe 'for real-time indices' do
    it "limits results to those matching the foreign key" do
      porsche = Manufacturer.create :name => 'Porsche'
      spyder = Car.create :name => '918 Spyder', :manufacturer => porsche

      audi = Manufacturer.create :name => 'Audi'
      r_eight = Car.create :name => 'R8 Spyder', :manufacturer => audi

      expect(porsche.cars.search('Spyder').to_a).to eq([spyder])
    end

    it "limits id-only results to those matching the foreign key" do
      porsche = Manufacturer.create :name => 'Porsche'
      spyder = Car.create :name => '918 Spyder', :manufacturer => porsche

      audi = Manufacturer.create :name => 'Audi'
      r_eight = Car.create :name => 'R8 Spyder', :manufacturer => audi

      expect(porsche.cars.search_for_ids('Spyder').to_a).to eq([spyder.id])
    end
  end

  describe 'with has_many :through associations' do
    it 'limits results to those matching the foreign key' do
      pancakes = Product.create :name => 'Low fat Pancakes'
      waffles  = Product.create :name => 'Low fat Waffles'

      food = Category.create :name => 'food'
      flat = Category.create :name => 'flat'

      pancakes.categories << food
      pancakes.categories << flat
      waffles.categories  << food

      expect(flat.products.search('Low').to_a).to eq([pancakes])
    end
  end
end
