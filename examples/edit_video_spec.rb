require_relative './spec_helper'

describe "Edit Video" do
  context "when user is unauthenticated" do
    it_behaves_like "Unauthenticated", -> (api) do
      api.edit_video(test_video_id("user1"), title: "foo")
    end
  end

  context "Authenticated User" do
    context "different account" do
      before(:all) do
        @api = _api(login: user2["login"],
                    application_token: user2["rw_token"])
      end

      describe "xml" do
        specify do
          expect do
            @api.edit_video(test_video_id("user1"))
          end.to raise_error(Vzaar::Error, "Protected Resource")
        end
      end

      describe "json" do
        specify do
          expect do
            @api.edit_video(test_video_id("user1"), format: "json")
          end.to raise_error(Vzaar::Error, "Protected Resource")
        end
      end
    end

    context "RW token" do
      before(:all) do
        @api = _api(login: user1["login"],
                    application_token: user1["rw_token"])
      end

      describe "updating params" do
        describe "xml" do
          before(:all) do
            @title = rand_str()
            @desc = rand_str()
            @res = @api.edit_video(test_video_id("user1"),
                                   title: @title,
                                   description: @desc)
          end

          it_behaves_like "200 OK"

          specify { expect(@res.title).to eq(@title) }
          specify { expect(@res.description).to eq(@desc) }
        end

        describe "json" do
          before(:all) do
            @title = rand_str()
            @desc = rand_str()
            @res = @api.edit_video(test_video_id("user1"),
                                   title: @title,
                                   format: :json,
                                   description: @desc)
          end

#          it_behaves_like "200 OK"

          specify { expect(@res["oembed"]["title"]).to eq(@title) }
#          specify { expect(@res["oembed"]["description"]).to eq(@desc) }
        end
      end
    end

    context "RO token" do
      it_behaves_like "RO only", user1["login"], user1["ro_token"], -> (api) do
        api.edit_video(test_video_id("user1"), title: "woof")
      end
    end
  end
end
