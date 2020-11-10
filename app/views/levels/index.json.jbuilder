json.array!(@levels) do |level|
  json.extract! level, :id, :admin_id, :controller, :format, :all, :new, :edit, :show, :index
  json.url level_url(level, format: :json)
end
