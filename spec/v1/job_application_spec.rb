require 'rails_helper'

RSpec.describe Api::V1::JobApplicationsController , :type => :controller do

  before(:each) do
    @applicant = FactoryGirl.create(:applicant)
    @job_application1 = @applicant.job_applications.create(:job_id => 1)
    @job_application2 = @applicant.job_applications.create(:job_id => 2)
    @job_application3 = FactoryGirl.create(:applicant).job_applications.create(:job_id => 3)
    @job = FactoryGirl.create(:job)
  end

  def stub_authorization
    allow(request.env['warden']).to receive(:authenticate_applicant!).and_return(true)
    allow(controller).to receive(:current_applicant).and_return(@applicant)
  end

  describe "get #index" do
    context "when applicant is authorized"
      before do
        stub_authorization
      end

      it "allows authorized applicants only" do
        get :index
        expect(response.status).to eq(200)
      end

      it "should give only current applicant's job applications" do
        get :index
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1000)
        expect(json["body"].all? {|x| x["applicant"]["id"] == @applicant.id}).to eq(true)        
      end
  end  

  describe "post #create" do

    context "when applicant is authorized" do
      before do
        stub_authorization
      end

      it "can apply for a given job" do
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

      it "cannot apply for job that doesn't exists" do
        post :create , :id => nil
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json["code"]).to eq(1200)
      end

      it "cannot apply twice for the same job" do
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

    context "when user is unauthorized" do
      it "should not allow unauthenticated applicant" do
        post :create , :id => "#{@job.id}"
        expect(response.status).to eq(401)
      end
    end
  end  

  describe "get #show" do 
    
    context "when applicant is authorized" do
      before do
        stub_authorization
      end

      it "allows authenticated applicant only" do
        get :show , :id => "#{@job.id}"
        expect(response.status).to eq(200)
      end

      it "should give applicant his resource only" do
        get :show , :id => "#{@job_application1.id}"
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1000)
      end

      it "should not give applicant someone else resource" do
        get :show , :id => "#{@job_application3.id}"
        json = JSON.parse(response.body)
        expect(response.status).to eq(401)        
      end
    end

    context "when applicant is unauthorized" do      
      it "doesn't allows unauthenticated applicant" do
        get :show , :id => "#{@job.id}"
        expect(response.status).to eq(401)
    end
    end
	end

end