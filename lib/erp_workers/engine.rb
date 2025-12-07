# frozen_string_literal: true

require "view_component/engine"

module ErpWorkers
  class Engine < ::Rails::Engine
    isolate_namespace ErpWorkers

    initializer "erp_workers.setup" do |app|
      ActiveSupport.on_load(:action_controller_base) do
        append_view_path Rails.root.join("app/views")
      end
    end

    config.eager_load_paths << root.join("app/components")

    config.generators do |g|
      g.test_framework :rspec
      g.template_engine :slim
    end
  end
end
