# Autenticacion Ruby: API, Devise & JWT

Crear proyecto nuevo API

```
$ rails new api_name --api
```

Configurar CORS
```
# descomentar la gema RACK-CORS del Gemfile
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'
```

Agregar el siguiente código al archivo aplication.rb
```
config.api_only = true
config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '/api/*',
      headers: %w(Authorization),
      methods: :any,
      expose: %w(Authorization),
      max_age: 600
  end
end
```

Agregar la gema devise-jw
```
# Authentication
gem 'devise' 
gem 'devise-jwt'
```

Instalar Gemas
```
$ bundle install
```

Configurar Devise
```
$ rails generate devise:install
```

Crear el modelo User
```
$ rails generate devise user
```

Configurar JWT, agregar las especificaciones de JWT
```
# app/models/user.rb

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
end
```

Agregar columna al modelo User
```
$ rails generate migration AddJtiToUser jti:string:index:uniq
```

Ejecutar las migraciones
```
$ rails db:migrate
```

Configuración al final del archivo Devise.rb
```
# config/initializers/devise.rb
config.jwt do |jwt|
    jwt.secret = Rails.application.credentials.jwt_secret
    jwt.dispatch_requests = [
      ['POST', %r{^/login$}],
      ['GET', %r{^/signup$}]
    ]
    jwt.revocation_requests = [
      ['DELETE', %r{^/logout$}]
    ]
    jwt.expiration_time = 3600
    jwt.request_formats = {
      user: [:json]
    }
  end
```

Generar un secret
```
$ rails secret
```

Agregar el hash generado al archivo credentials.yml.enc
```
$ EDITOR=nano bin/rails credentials:edit
```

Agregar las rutas de Auth
```
# config/routes.rb

Rails.application.routes.draw do
  
  devise_for :users, skip: %i[registrations sessions passwords]
  devise_scope :user do
    post '/signup', to: 'registrations#create'
    post '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy'
  end
  resources :posts
end
```

Crear los controladores Registrations y Sessions
```
#### sessions_controller.rb

class SessionsController < Devise::SessionsController
  respond_to :json

  private

    def respond_with(resourse, opts = {})
      render json: resourse
    end

    def respond_to_on_destroy
      head :no_content
    end
end

### registrations_controller.rb

class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params)
    resource.save
    render json: resource, status: :created
  end
end
```

Iniciar server para probar la autenticación Bearer #{token}
```
$ rails s
```

Crear petición Signup, usando HTTPie
```
$ http POST :3000/signup user:='{"email": "ely@gmail.com", "password": "123456"}'
```

Realizar login para obtener el Token de autenticacion, usando HTTPie
```
$ http POST :3000/login user:='{"email": "ely@gmail.com", "password": "123456"}'

RESPONSE:
HTTP/1.1 200 OK
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJhM2Q1NzEwZi0wMDAwLTRiMjgtYTI5MC1hNzI1YTUyYzU4ZjIiLCJzdWIiOiIzIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNjE3NDM1NjAxLCJleHAiOjE2MTc0MzkyMDF9.ClgpGdpTBsUGsLZwLqUBpxTHddkkWKG3Qtxm3IlRUNg
Cache-Control: max-age=0, private, must-revalidate
Content-Type: application/json; charset=utf-8
ETag: W/"cf39c4c015548e071be15a6d51a77108"
```

Crear un endpoint POST para probar la autenticación
```
$ rails generate scaffold post title:string body:text published:boolean
```

Agregar a cada controller el before_action :authenticate_user!, para forzar el inicio de sesion o generacion de Token
```
class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :update, :destroy]

  # GET /posts
  def index
    @posts = Post.all

    render json: @posts
  end
```

Request GET a POSTS usando el token, con HTTPie
```
$ http :3000/posts 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIwYWUyNmZhZi05YTQ1LTRiOWEtYmEzYi00MGQ5Nzg1MzE5Y2QiLCJzdWIiOiIxIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNjE3NDM0NDQ2LCJleHAiOjE2MTc0MzgwNDZ9.r7bx7pgdjXGdO4GUtTzth7iS07f0MZWbn5oZawwexuU'
```
