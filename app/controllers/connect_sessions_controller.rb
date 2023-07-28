class ConnectSessionsController < ApplicationController
  def external_connect_show
    redirect_to session["connect_url_#{params[:customer_id]}"],
                allow_other_host: true
  end
end
