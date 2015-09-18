class Webhooks::CloverController < Webhooks::MainController
  def test
    data = request.body.read
    data = JSON.parse(data)
    puts data

    @test = data
  end
end
