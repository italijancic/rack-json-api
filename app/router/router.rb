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

  def initialize(request)
    @request = request
  end

  def route
    add_route_info_to_request_params
    controller = controller_class
    if controller
      controller.new(request).send(route_info[:action])
    else
      BaseController.new(request).not_found
    end
  rescue StandardError
    BaseController.new(request)
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
    case fragment
    when 'new'
      [http_method, nil, :new]
    when nil
      action = request.get? ? :index : :create
      [http_method, nil, action]
    else
      action = request.get? ? :show : :delete
      [http_method, fragment, action]
    end
  end

  def path_fragments
    @path_fragments ||= request.path.split('/').reject(&:empty?)
  end

  def http_method
    request.request_method
  end

  # Get the proper controller
  def controller_name
    "#{route_info[:resource].capitalize}Controller"
  end

  def controller_class
    Object.const_get(controller_name)
  rescue NameError
    nil
  end
end
