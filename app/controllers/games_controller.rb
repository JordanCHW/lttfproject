class GamesController < ApplicationController
  # GET /games
  # GET /games.json
  def index
    session[:player_id]="0"
    @games = Game.order(" created_at DESC").page(params[:page]).per(50)
    @gamescount=Game.all.size
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @games }
    end
  end
  def show_player_games
    @game = Game.find(params[:format].to_i)
    @playerssummery=@game.getplayersummary
    @playerssummery=@playerssummery.find_all{|v| v['name']==params[:player_name]}
    @gamesrecords=@game.getdetailgamesrecord
    @gamesrecords=@gamesrecords.find_all{|v| v['Aplayer']==params[:player_name]||v['Bplayer']==params[:player_name]}
    @targetplayername=params[:player_name]
   end  
  # GET /games/1
  # GET /games/1.json
  def show

    @game = Game.find(params[:id])
    @playerssummery=@game.getplayersummary
    @gamesrecords=@game.getdetailgamesrecord

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/new
  # GET /games/new.json
  def new
    @game = Game.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(params[:game])

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render json: @game, status: :created, location: @game }
      else
        format.html { render action: "new" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.json
  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end
  def lttfratinginfo
    
  end
  def lttfprize
    #@players=Playerprofile.where(:updated_at => APP_CONFIG['award_statistic_start_date']..APP_CONFIG['award_statistic_end_date'])
    @players=Game.qualified_players_for_prize_games_2018
    @joingames_ranking=@players.sort_by(&:prize_2018_statistic_gamelist_count).reverse.first(10)
    @wongames_ranking=@players.sort_by(&:qualifiedwongames_count).reverse.first(10)
    #@highest_score_player=@joingames_ranking.select{ |player| player.statistic_gamelist_count > 11 }.sort_by(&:current_score).reverse.first(10)
    @highest_score_player=@players.select{ |player| player.prize_2018_statistic_gamelist_count > 11 }.sort_by(&:current_score).reverse.first(10)
    @award_gameholers=Gameholder.all.sort_by(&:prize_games_count).reverse.first(10)
  end
end
