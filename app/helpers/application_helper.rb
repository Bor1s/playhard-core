module ApplicationHelper
  def vk_login_link
    link_to image_tag(asset_path('vk_logo.jpg'), alt: 'Sign In via VK'), '/auth/vkontakte', class: 'thumbnail'
  end

  def allowed_to_administrate?
    can? :manage, :all
  end

  def admin_sidepanel
    case controller_name
    when 'genres'
      content_tag :div do
        link_to new_genre_path, class: 'pull-right btn btn-primary' do
          content_tag :i, ' New', class: 'fa fa-plus'
        end
      end.html_safe
    end
  end

  def regular_sidepanel
    content_tag :div, 'Your dashboard'
  end

  def errors_for model
    unless model.errors.empty?
      html =<<-HTML
        <div class='alert alert-danger alert-dismissable'>
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <ul>
            #{model.errors.full_messages.map do |msg|
              content_tag :li, msg
            end.join}
          </ul>
        </div>
      HTML
      html.html_safe
    end
  end

  def flash_messages
    unless flash.empty?
      msgs = flash.map {|name, msg| msg}.join(' ')
      html =<<-HTML
        <div class='alert alert-success alert-dismissable'>
          #{msgs}
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        </div>
      HTML
      html.html_safe
    end
  end

  def current_tab? name
    controller_name == name
  end
end
