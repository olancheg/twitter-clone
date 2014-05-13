module UsersHelper
  def user_title(user)
    title = "@#{user.username}"
    title << " (#{user.realname})" if user.realname.present?
    title
  end

  def incoming_requests_title(user)
    "Incoming (#{user.incoming_requests_count})"
  end

  def outgoing_requests_title(user)
    "Outgoing (#{user.outgoing_requests_count})"
  end

  def dropdown_friends_link(user)
    title = 'Friends'

    if user.incoming_requests_count > 0
      title << " (#{user.incoming_requests_count})"
      link = [:incoming, :friendships]
    else
      link = :friendships
    end

    link_to(title, link)
  end
end
