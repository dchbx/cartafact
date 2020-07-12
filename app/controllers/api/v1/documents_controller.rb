class Api::V1::DocumentsController < ApplicationController
  # query for documents. Returns an array.
  def index
    authorization_information = verify_authorization_headers_present
    unless authorization_information
      return nil
    end
    result = ::Cartafact::Entities::Operations::Documents::Where.call(authorization_information)
    if result.success?
      render :json => result.value!, status: :ok
    else
      render :json => [], status: :ok
    end
  end

  # finds document & renders it to client 
  def show
    authorization_information = verify_authorization_headers_present
    unless authorization_information
      return nil
    end
    result = ::Cartafact::Entities::Operations::Documents::Show.call({
      authorization: authorization_information,
      id: params[:id]
    })
    if result.success?
      render :json => result.value!, status: :ok
    else
      render :blank => true, status: 404
    end
  end

  def create
    authorization_information = verify_authorization_headers_present
    unless authorization_information
      return nil
    end
    result = ::Cartafact::Entities::Operations::Documents::Create.call(create_params)
    if result.success?
      render :json => result.value!, status: :created
    else
      render :json => result.failure, status: "422"
    end
  end

  def download
    authorization_information = verify_authorization_headers_present
    unless authorization_information
      return nil
    end
    result = ::Cartafact::Entities::Operations::Documents::Download.call({
      authorization: authorization_information,
      id: params[:id]
    })
    if result.success?
      document = result.value!
      send_data document.file.to_io, type: document.download_mime_type, filename: document.file.original_filename
    else
      render :blank => true, status: 404
    end
  end

  private

  def create_params
    params.require(:document).permit!
    params.permit(:content)
    params[:document].to_h.merge({path: params[:content]})
  end

  def verify_authorization_headers_present
    # req_identity = "X-RequestingIdentity"
    # req_identity_signature = "X-RequestingIdentitySignature"
    req_identity = request.headers["HTTP_X_REQUESTINGIDENTITY"]
    req_identity_signature = request.headers["HTTP_X_REQUESTINGIDENTITYSIGNATURE"]
    validation = Cartafact::Operations::ValidateResourceIdentitySignature.call(
      {
        requesting_identity_header: req_identity,
        requesting_identity_signature_header: req_identity_signature
      }
    )
    unless validation.success?
      render status: 403, json: {error: "not_authorized"}
      return nil
    end
    validation.value!
  end
end
