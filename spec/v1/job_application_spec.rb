require 'rails_helper'

RSpec.describe Api::V1::JobApplicationsController , :type => :controller do

  before(:each) do
    @applicant = FactoryGirl.create(:applicant)
    @job = FactoryGirl.create(:job)
    #@applicant = double(:applicant)

  end

  describe "get #show" do 
    
    context "authorized" do

      before do
        allow(request.env['warden']).to receive(:authenticate_applicant!).and_return(true)
        allow(controller).to receive(:current_applicant).and_return(@applicant)
      end

      it "allows authenticated applicant only" do
        get :show , :id => 1
        expect(response.status).to eq(200)
      end
    end

    it "doesn't allows unauthenticated applicant" do
      get :show , :id => 1
      expect(response.status).to eq(401)
    end

	end

  describe "post #create" do
    context "authorized" do

      before do
        allow(request.env['warden']).to receive(:authenticate_applicant!).and_return(true)
        allow(controller).to receive(:current_applicant).and_return(@applicant)
      end

      it "should create job application for given job" do
        post :create , :id => "#{@job.id}"
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json["code"]).to eq(1000)
      end

      it "should belong to the applicant" do
        post :create , :id => "#{@job.id}"
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1000)
        expect(json["body"]["applicant"]["id"]).to eq(@applicant.id)
      end

      it "cannot be applied for job that does not exists" do
        post :create , :id => nil
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json["code"]).to eq(1200)
      end

      it "cannot be applied twice for the same job" do
        @applicant.job_applications.create(:job_id => @job.id)
        post :create , :id => "#{@job.id}"
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json["code"]).to eq(1300)        
      end

      it "should have status as 'pending' during creation" do
        post :create , :id => "#{@job.id}"
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1000)
        expect(json["body"]["status"]).to eq("pending")
      end


    end

      it "should not allow unauthenticated applicant" do
        post :create , :id => 1
        expect(response.status).to eq(401)
      end
  end

end