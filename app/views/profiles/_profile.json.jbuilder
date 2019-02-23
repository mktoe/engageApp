json.extract! profile, :id, :user_id, :profile_name, :profile_birth, :profile_join_date, :profile_hobby, :profile_text, :created_at, :updated_at
json.url profile_url(profile, format: :json)
