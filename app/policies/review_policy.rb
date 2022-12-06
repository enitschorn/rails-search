class ReviewPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end

    def show?
      true
    end

    def create?
      record.flat.bookings.where(user_id: user).user_id == user
    end

    def new?
      create?
    end

    def update?
      record.user == user
    end

    def edit?
      update?
    end

    def destroy?
      record.user == user
    end
  end
end
