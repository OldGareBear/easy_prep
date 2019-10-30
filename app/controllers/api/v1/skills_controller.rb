module Api
  module V1
    class SkillsController < ApplicationController
      def index
        search_term = "%#{params[:search_query]}%"
        skills = Skill.where.not(oid: nil).where('name like ? or oid like ?', search_term, search_term).limit(10)
        render json: { results: skills }, status: status
      end
    end
  end
end
