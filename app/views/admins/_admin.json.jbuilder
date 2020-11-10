json.extract! admin, :id, :title, :email, :password, :level, :open_password, :encrypted_password,
              :password_digest,:created_at, :updated_at
json.url admin_url(admin, format: :json)
