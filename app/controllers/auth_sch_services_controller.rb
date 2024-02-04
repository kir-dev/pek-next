class AuthSchServicesController < ApplicationController
  skip_before_action :require_login
  before_action :validate_authsc_ip

  def sync
    user = get_user(params[:id], [])
    render json: { success: true, user: user_json(user) } if user
  end

  def memberships
    user = get_user(params[:id], [:groups, { memberships: [{ posts: [:post_type] }] }])
    render json: { success: true, memberships: membership_json(user) } if user
  end

  def entrants
    user = get_user(params[:id], [{ entry_requests: [{ evaluation: [:group] }] }])
    render json: entrants_json(user, params[:semester]) if user
  end

  private

  def validate_authsc_ip
    valid_authsc_ips = ENV["VALID_AUTHSCH_IPS"].split(',')
    render status: :forbidden, plain: 'Forbidden' unless valid_authsc_ips.include?(request.remote_ip)
  end

  def entrants_json(user, semester)
    entrants = user.entry_requests.select do |er|
      er.evaluation.accepted && er.evaluation.semester == semester
    end
    entrant_array = []
    entrants.each do |entrant|
      entrant = { groupId: entrant.evaluation.group_id,
                  groupName: entrant.evaluation.group.name,
                  entrantType: entrant.entry_type }
      entrant_array.push entrant
    end
    entrant_array
  end

  def membership_json(user)
    memberships_array = []
    user.memberships.each do |membership|
      next if membership.newbie? || membership.archived?

      membership_data = { start: membership.start_date,
                          end: membership.end_date,
                          group_name: membership.group.name,
                          group_id: membership.group.id,
                          posts: membership.posts.map { |p| p.post_type.name } }
      memberships_array.push membership_data
      memberships_array.last[:posts].push(membership.end_date ? 'öregtag' : 'tag')
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

    user = User.includes(includes) .find_by(type => id.upcase) if type == :neptun
    user ||= User.includes(includes).find_by(type => id)
    return error_response(404, t(:non_existent_id, id: id)) unless user

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
