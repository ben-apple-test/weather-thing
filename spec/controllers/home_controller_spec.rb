require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #forecast" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          forecast_request: {
            street: "123 Main St",
            city: "Portland",
            state: "OR",
            zip_code: "97201"
          }
        }
      end

      it "returns http success" do
        get :forecast, params: valid_params
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          forecast_request: {
            street: "",
            city: "",
            state: "",
            zip_code: ""
          }
        }
      end

      it "renders index with errors" do
        get :forecast, params: invalid_params
        expect(response).to render_template(:index)
      end
    end
  end
end
