require 'rails_helper'

describe RentalsController do
  let!(:rental) { create(:rental) }
  let!(:rental2) { create(:rental) }

  before(:each) do
    @current_user = create(:user)
    controller.instance_variable_set("@current_user", @current_user)
  end

  describe 'GET #index' do
    it 'populates an array of rentals' do
      get :index
      expect(assigns[:rentals]).to eq([rental, rental2])
    end
    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it 'assigns the requested rental to @rental' do
      get :show, id: rental
      expect(assigns[:rental]).to eq(rental)
    end
    it 'renders the :show template' do
      get :show, id: rental
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    it 'assigns a new rental to @rental' do
      get :new
      expect(assigns[:rental]).to be_a_new(Rental)
    end
    it 'renders the :new template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      context 'with accepting the disclaimer' do
        it 'saves the new rental in the database' do
          expect do
            post :create, rental: attributes_for(:new_rental), disclaimer: '1'
          end.to change(Rental, :count).by(1)
        end
        it 'redirects to the rental page' do
          post :create, rental: attributes_for(:new_rental), disclaimer: '1'
          expect(response).to redirect_to Rental.last
        end
      end
      
      context 'without accepting the disclaimer' do
        it 'does not save the new Rental in the database' do
          expect do
            post :create, rental: attributes_for(:new_rental)
          end.to_not change(Rental, :count)
        end
        it 're-renders the :new template' do
          post :create, rental: attributes_for(:new_rental)
          expect(response).to render_template :new
        end
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new Rental in the database' do
        expect do
          post :create, rental: attributes_for(:invalid_rental), disclaimer: '1'
        end.to_not change(Rental, :count)
      end
      it 're-renders the :new template' do
        post :create, rental: attributes_for(:invalid_rental), disclaimer: '1'
        expect(response).to render_template :new
      end
    end
  end

  # describe 'POST #destroy' do
  #   it 'deletes the rental from the database' do
  #     expect do
  #       delete :destroy, id: rental
  #     end.to change(Rental, :count).by(-1)
  #   end
  #   it 'redirects to the rentals index page' do
  #     delete :destroy, id: rental
  #     expect(response).to redirect_to rentals_url
  #   end
  # end
end
