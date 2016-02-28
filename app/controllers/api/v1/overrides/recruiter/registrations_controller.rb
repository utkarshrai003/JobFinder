class Api::V1::Overrides::Recruiter::RegistrationsController < DeviseTokenAuth::RegistrationsController

def create
    @resource = resource_class.new(sign_up_params)

    p = sign_up_params[:provider]
    valid_provider = p and (p.is?(:twitter) or p.is?(:facebook))

    if !valid_provider
      @resource.provider = "email"
    end

    # honor devise configuration for case_insensitive_keys
    if resource_class.case_insensitive_keys.include?(:email)
      @resource.email = sign_up_params[:email].downcase
    else
      @resource.email = sign_up_params[:email]
    end

    # overriding create
    # adding role-id , company-id

    company_name = @resource.email[/@(.*?)\./m, 1]
    company_exists = Company.find_by(code: "#{company_name}")
    @resource.company = company_exists

    if company_exists.blank?
      Company.create(name: "#{company_name}" , code: "#{company_name}")
      @resource.role = Role.find_by(:name => "admin")
    else 
      @resource.role = Role.find_by(:name => "recruiter")
    end

    # finished
    
    begin
      # override email confirmation, must be sent manually from ctrl
     resource_class.skip_callback("create", :after, :send_on_create_confirmation_instructions)
      if @resource.save
        yield @resource if block_given?

          @client_id = SecureRandom.urlsafe_base64(nil, false)
          @token     = SecureRandom.urlsafe_base64(nil, false)

          @resource.tokens[@client_id] = {
            token: BCrypt::Password.create(@token),
            expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
          }

          @resource.save!

          update_auth_header

        render json: {
          status: 'success',
          data:   @resource.as_json
        }
      else
        clean_up_passwords @resource
        render json: {
          status: 'error',
          data:   @resource.as_json,
          errors: @resource.errors.to_hash.merge(full_messages: @resource.errors.full_messages)
        }, status: 403
      end
    rescue ActiveRecord::RecordNotUnique
      clean_up_passwords @resource
      render json: {
        status: 'error',
        data:   @resource.as_json,
        errors: ["An account already exists for #{@resource.email}"]
      }, status: 403
    end
  end

  def update
    if @resource

      if @resource.update_attributes(account_update_params)
        yield @resource if block_given?

        # We are doing this because the front end expects a property 'image' on the user
        # that returns the url irrespective of whether it came from facebook, twitter or
        # was uploaded.
        if @resource.avatar?
          @resource.image = @resource.avatar.thumb.url
          @resource.save validate: false
        end
        render json: {
          status: 'success',
          data:   UserDetailsSerializer.new(@resource, { root: false })
        }
      else
        render json: {
          status: 'error',
          errors: @resource.errors.to_hash.merge(full_messages: @resource.errors.full_messages)
        }, status: 403
      end
    else
      render json: {
        status: 'error',
        errors: ["User not found."]
      }, status: 404
    end
  end

  def destroy
    if @resource
      @resource.destroy
      yield @resource if block_given?

      render json: {
        status: 'success',
        message: "Account with uid #{@resource.uid} has been destroyed."
      }
    else
      render json: {
        status: 'error',
        errors: ["Unable to locate account for destruction."]
      }, status: 404
    end
  end

  def sign_up_params
    params.permit(devise_parameter_sanitizer.for(:sign_up).push(:name))
  end

  def account_update_params
    params.permit(devise_parameter_sanitizer.for(:account_update))
  end

  private

  def validate_sign_up_params
    validate_post_data sign_up_params, 'Please submit proper sign up data in request body.'
  end

  def validate_account_update_params
    validate_post_data account_update_params, 'Please submit proper account update data in request body.'
  end

  def validate_post_data which, message
    render json: {
       status: 'error',
       errors: [message]
    }, status: :unprocessable_entity if which.empty?
  end
end    









