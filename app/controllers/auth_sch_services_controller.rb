class AuthSchServicesController < ApplicationController

  def sync
    user = get_user(params[:id], [])
    if user
      render json: { success: true, user: user_json(user) }
    end
  end

  def memberships
    user = get_user(params[:id], [ :groups, { memberships: [ { posts: [ :post_type ] } ] } ])
    if user
      render json: { success: true, memberships: membership_json(user) }
    end
  end

  def entrants
    user = get_user(params[:id], [ { entryrequests: [ { evaluation: [ :group ] } ] } ])
    if user
      render json: entrants_json(user, params[:semester])
    end
  end

private

  def entrants_json(user, semester)
    entrants = user.entryrequests.select { |er| er.evaluation.accepted && er.evaluation.semester == semester }
    entrant_array = []
    entrants.each do |entrant|
      entrant_array.push({
        groupId: entrant.evaluation.group_id,
        groupName: entrant.evaluation.group.name,
        entrantType: entrant.entry_type
        })
    end
    entrant_array
  end

  def membership_json(user)
    memberships_array = []
    user.memberships.each do |membership|
      next if membership.newbie?
      memberships_array.push({
        start: membership.start,
        end: membership.end,
        group_name: membership.group.name,
        group_id: membership.group.id,
        posts: membership.posts.map { |p| p.post_type.name }
        })
      memberships_array.last[:posts].push(membership.end ? 'öregtag' : 'tag')
    end
    memberships_array
  end

  def user_json(user)
    {
      displayName: user.full_name,
      mail: user.email,
      givenName: user.firstname,
      sn: user.lastname,
      eduPersonNickName: user.nickname,
      uid: user.screen_name,
      mobile: user.cell_phone,
      schacPersonalUniqueId: user.id
    }.compact
  end

  def get_user(id, includes)
    type = id_type(id)
    return error_response(400, t(:invalid_id)) if type == :invalid
    if type == :neptun
      user = User.includes(includes)
        .find_by({ type => id.upcase })
    else
      user = User.includes(includes)
        .find_by({ type => id })
    end
    return error_response(404, t(:non_existent_id, id: id)) if !user
    user
  end

  def id_type(id)
    return :neptun if id =~ Rails.configuration.x.neptun_regex
    return :auth_sch_id if id =~ Rails.configuration.x.uuid_regex
    :invalid
  end

  def error_response(error_code, message)
    msg = { success: false, message: message }
    render json: msg, status: error_code
    nil
  end

end
