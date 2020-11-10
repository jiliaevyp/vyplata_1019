json.array!(@monds) do |mond|
  json.extract! mond, :yahre, :monat, :num_monat, :tag, :hour, :kfoberhour, :kfnalog, :procentsocial
  json.url mond_url(mond, format: :json)
end