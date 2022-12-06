class BookingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end

    def show?
      true
    end

    def create?
      true
    end

    def new?
      create?
    end

    def update?
      record.flat.user == user
    end

    def edit?
      update?
    end

    def destroy?
      record.user == user
    end
  end
end
