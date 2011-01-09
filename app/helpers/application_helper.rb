# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def get_user_name(id)
    return User.find(id).name
  rescue =>e
    logger.error("Application_helper::get_user_name::#{e}")
  end

  def get_category_description(id)
    return Category.find(id).description
  rescue =>e
    logger.error("Application_helper::get_category_description::#{e}")
  end
end
