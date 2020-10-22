# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  before(:each) do
    now = Time.zone.now
    @product = Product.create!({
                                 url: 'https://hamrobazaar.com/i123-test-valid.html',
                                 title: 'Test Title',
                                 price: 'Rs 4000',
                                 description: 'This is description',
                                 mobile_number: '980909090',
                                 expires_at: now + 1.weeks,
                                 created_at: now,
                                 updated_at: now
                               })
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: {}, as: :json
      expect(response).to be_successful
    end

    it 'should list acconunt categories' do
      get :index, params: {}, as: :json
      parsed_body = JSON.parse response.body
      expect(parsed_body['data'].count).to eq(1)
    end
  end

  describe 'GET search' do
    context 'Url not pn database' do
      it 'returns a success response' do
        get :search, params: { search: 'https://hamrobazaar.com/hamro_bazar1.html' }, as: :json
        expect(response).to be_successful
      end

      it 'creates a new product' do
        expect do
          get :search, params: { search: 'https://hamrobazaar.com/hamro_bazar1.html' }, as: :json
        end.to change(Product, :count).by(1)
      end
    end

    context 'Invalid Search Url' do
      it 'should return invalid url response' do
        get :search, params: { search: 'https://hamro.com/hamro_bazar1.html' }, as: :json
        parsed_body = JSON.parse response.body
        expect(parsed_body['message']).to eq('Url must be a hamro bazar ad url')
      end
    end

    context 'Url already on data base' do
      it 'returns a success response' do
        get :search, params: { search: 'https://hamrobazaar.com/i123-test-valid.html' }, as: :json
        expect(response).to be_successful
      end

      it 'does not create a new product' do
        expect do
          get :search, params: { search: 'https://hamrobazaar.com/i123-test-valid.html' }, as: :json
        end.to change(Product, :count).by(0)
      end
    end

    context 'prouduct Expired' do
      before(:each) do
        @product.update(expires_at: Time.zone.now - 1.days)
      end

      it 'returns a success response' do
        get :search, params: { search: 'https://hamrobazaar.com/i123-test-valid.html' }, as: :json
        expect(response).to be_successful
      end

      it 'should enqueue job' do
        ActiveJob::Base.queue_adapter = :test
        expect do
          get :search, params: { search: 'https://hamrobazaar.com/i123-test-valid.html' }, as: :json
        end.to have_enqueued_job
      end
    end
  end
end
