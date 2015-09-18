class Webhooks::CloverController < Webhooks::MainController
  def test
    data = request.body.read
    data = JSON.parse(data)
    puts data['verificationCode']

    @test = data
  end

  # /webhooks/clover
  def receive
    data = request.body.read
    data = JSON.parse(data)

    CloverWorker.perform_async(data)
    render nothing: true
  end
end
