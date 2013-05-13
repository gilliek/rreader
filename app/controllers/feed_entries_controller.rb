class FeedEntriesController < ApplicationController
  # GET /feed_entries/1
  # GET /feed_entries/1.json
  def show
    @entry = FeedEntry.find(params[:id])
    @entry.update_attribute(:read, true)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @entry }
      format.js
    end
  end

  # DELETE /feed_entries/1
  # DELETE /feed_entries/1.json
  def destroy
    @entry = FeedEntry.find(params[:id])
    @entry.destroy

    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end
end
