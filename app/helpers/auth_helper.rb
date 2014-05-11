module AuthHelper
  def prechecked_remember_me(object)
    if object.remember_me.nil?
      true
    else
      object.remember_me
    end
  end
end
