# # frozen_string_literal: true

# class Api::SessionsController < ApplicationController
#     def create
#         user = User.find_by(email: params[:email])
#         if user&.authenticate(params[:password])
#             token = JWT.encode(user_id: user.id)
#             render json: { token: token }, status: :created
#         else
#             render json: { error: 'Invalid email or password' }, status: :unauthorized
#         end
#     end

#     private

#     def session_params
#         params.permit(:email, :password)
#     end
# end
