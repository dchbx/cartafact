# frozen_string_literal: true

module Api
  module V1
    # Controller exposing the document API.
    class DocumentsController < ApplicationController
      # query for documents. Returns an array.
      def index
        authorization_information = verify_authorization_headers_present
        return nil unless authorization_information

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
        return nil unless authorization_information

        result = ::Cartafact::Entities::Operations::Documents::Show.call(
          authorization: authorization_information,
          id: params[:id]
        )
        if result.success?
          render :json => result.value!, status: :ok
        else
          render :blank => true, status: 404
        end
      end

      def create
        authorization_information = verify_authorization_headers_present
        return nil unless authorization_information

        result = ::Cartafact::Entities::Operations::Documents::Create.call(create_params)
        if result.success?
          render :json => result.value!, status: :created
        else
          render :json => result.failure, status: "422"
        end
      end
      
      include ActionController::Live
      def download
        authorization_information = verify_authorization_headers_present
        return nil unless authorization_information

        result = ::Cartafact::Entities::Operations::Documents::Download.call(
          authorization: authorization_information,
          id: params[:id]
        )
        if result.success?
          begin
            document = result.value!
            disposition = ActionDispatch::Http::ContentDisposition.format(disposition: "attachment", filename: document.file.original_filename)
            response.headers["Last-Modified"] = document.updated_at.httpdate.to_s
            response.headers["Content-Disposition"] = disposition
            response.headers['Content-Type'] = document.download_mime_type
            response.headers["Cache-Control"] = "no-cache"
            file = document.file
            file.open do
              while (data = file.read(4096))
                response.stream.write data
              end
            end
          ensure
            response.stream.close
          end
        else
          render :blank => true, status: 404
        end
      end

      private

      def create_params
        params.require(:document)
        params.permit(:content)
        JSON.parse(params[:document]).to_h.merge(path: params[:content])
      end

      def verify_authorization_headers_present
        # req_identity = "X-RequestingIdentity"
        # req_identity_signature = "X-RequestingIdentitySignature"
        req_identity = request.headers["HTTP_X_REQUESTINGIDENTITY"]
        req_identity_signature = request.headers["HTTP_X_REQUESTINGIDENTITYSIGNATURE"]
        validation = Cartafact::Operations::ValidateResourceIdentitySignature.call(
          requesting_identity_header: req_identity,
          requesting_identity_signature_header: req_identity_signature
        )
        unless validation.success?
          render status: 403, json: { error: "not_authorized" }
          return nil
        end
        validation.value!
      end
    end
  end
end
