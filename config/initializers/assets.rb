# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.compile = true
#Rails.application.config.assets.precompile +=  ['*.js', '*.css', '*.css.erb'] 
Rails.application.config.assets.precompile += %w( rentals/index.css )
Rails.application.config.assets.precompile += %w( rentals/index.js )
Rails.application.config.assets.precompile += %w( rentals/invoice.css )
Rails.application.config.assets.precompile += %w( rentals/rental_schedule.css )
Rails.application.config.assets.precompile += %w( financial_transactions/new.js )
Rails.application.config.assets.precompile += %w( incurred_incidentals/show.css )
Rails.application.config.assets.precompile += %w( incurred_incidentals/new.js )
Rails.application.config.assets.precompile += %w( rentals/new.js )
#Rails.application.config.assets.precompile += ['**/*']
#Rails.application.config.assets.precompile += ['*.js', '*.css', '**/*.js', '**/*.css']
