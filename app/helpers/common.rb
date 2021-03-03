module Common

  def ad_params
    JSON.parse(request.body.read)['ad']
  end
end
