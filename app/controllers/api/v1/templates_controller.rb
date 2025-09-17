class Api::V1::TemplatesController < Api::BaseController
  # GET /api/v1/template/:id
  def show
    @template = Template.active.find_by(id: params[:id])
    if @template
      render "templates/show"
    else
      raise GenericException.new(message: "Template not found", code: :not_found)
    end
  end

  # GET /api/v1/template/find_by_domain/
  def find_by_domain
  origin = find_host(request)

  # Fallback for local development
  if Rails.env.development? || Rails.env.production?
    domain = Domain.find_by(fqdn: origin) || Domain.first
  else
    domain = Domain.find_by(fqdn: origin)
  end

  @template = Template.active.find_by(id: domain&.template_id)

  if @template
    render "templates/show"
  else
    render json: { error: "Template not found for #{origin}" }, status: :not_found
  end
end

  private

  def find_host(request)
    extract_host(request.origin) || extract_host(request.original_url)
  end

  def extract_host(url)
    url&.match(%r{https?://([^/]+)}).captures[0] rescue nil
  end
end
