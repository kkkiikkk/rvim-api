Rails.application.config.assets.paths << Gem.loaded_specs["rails_admin"].full_gem_path + "/vendor/assets/javascripts"
Rails.application.config.assets.paths << Gem.loaded_specs["rails_admin"].full_gem_path + "/vendor/assets/stylesheets"
Rails.application.config.assets.precompile += %w[ rails_admin/rails_admin.js rails_admin/rails_admin.css ]
