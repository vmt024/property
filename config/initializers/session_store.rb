# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_property_session',
  :secret      => 'e9b986ea259951b4ee7f6e1c6ce2db31ade1727eb552812cefbfea56d3273ab3be2977f367417d411af1e5c03a154337702df98c5c56cf15a41463ec683bd004'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
