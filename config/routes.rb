Rails.application.routes.draw do

  # Define routes for MatchesController
  resources :matches, only: [:index]  # Assuming you only need the index action for now

  # Define routes for LeaderboardController
  get 'leaderboard', to: 'leaderboard#index'  # Assuming you have an index action in LeaderboardController

  resources :friends, only: [:index]
  resources :groups, only: [:index]
  # Add more routes for other controllers as needed
  resources :teams, only: [:index]
  # Set root route
  root 'matches#index'  # Assuming you want the matches index as the root route
end
