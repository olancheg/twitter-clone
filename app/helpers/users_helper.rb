module UsersHelper
  def user_title(user)
    title = "@#{user.username}"
    title << " (#{user.realname})" if user.realname.present?
    title
  end
end
