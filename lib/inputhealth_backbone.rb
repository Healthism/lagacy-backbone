require "inputhealth_backbone/version"

module InputhealthBackbone
  if defined? ::Rails::Engine
    module Rails
      class Engine < ::Rails::Engine
      end
    end
  elsif defined? ::Savanna::Assets
    ::Savanna::Assets.add_path_from_gem __FILE__
  end


end
