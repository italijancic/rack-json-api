# frozen_string_literal: true

# ----------------
# Routes to handle
# ----------------
# GET     /resource           # index   - get a list of the resources
# GET     /resource/:id       # show    - get a specific resource
# DELETE  /resource/:id       # delete  - delete specific resource
# GET     /resource/new       # new     - get an HTML page with a form
# POST    /resource           # create  - create a new resource
#
# -------
# Pending
# -------
# PUT   -> Complete update of one resource
# PATCH -> Partial update of one resource

class Router
  attr_reader :request, :logger

  def initialize(request, logger = Logger.new(STDOUT))
    @request = request
    @logger = logger
  end

  def route
    add_route_info_to_request_params
    controller = controller_class
    if controller
      controller.new(request).send(route_info[:action])
    else
      BaseController.new(request).not_found
    end
  rescue StandardError => e
    @logger.error("Routing error: #{e.message}")
    BaseController.new(request).internal_server_error
  end

  private

  def add_route_info_to_request_params
    request.params.merge!(route_info)
  end

  def route_info
    @route_info ||= begin
      resource = path_fragments[0] || 'base'
      method, id, action = find_id_and_action(path_fragments[1])
      { method:, resource:, action:, id: }
    end
  end

  def find_id_and_action(fragment)
    action = if fragment == 'new'
               :new
             elsif fragment.nil?
               request.get? ? :index : :create
             else
               action_for_http_method
             end
    [http_method, fragment, action]
  end

  def action_for_http_method
    {
      get: :show,
      delete: :delete,
      put: :update,
      patch: :partial_update
    }.fetch(http_method, :unknown)
  end

  def path_fragments
    @path_fragments ||= request.path_info.split('/').reject(&:empty?)
  end

  def http_method
    request.request_method.downcase.to_sym
  end

  def controller_class
    Object.const_get("#{route_info[:resource].capitalize}Controller")
  rescue NameError
    nil
  end
end
