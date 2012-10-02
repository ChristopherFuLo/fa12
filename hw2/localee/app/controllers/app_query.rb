class AppQuery

  ################################
  #  DO NOT MODIFY THIS SECTION  #
  ################################

  attr_accessor :posts
  attr_accessor :users
  attr_accessor :user
  attr_accessor :locations
  attr_accessor :following_locations
  attr_accessor :location

  ###########################################
  #  TODO: Implement the following methods  #
  ###########################################

  # Purpose: Show all the locations being followed by the current user
  # Input:
  #   user_id - the user id of the current user
  # Assign: assign the following variables
  #   @following_locations - An array of hashes of location information.
  #                          Order does not matter.
  #                          Each hash should include:
  #     * :id - the location id
  #     * :name - the name of the location
  #     * :latitude - the latitude
  #     * :longitude - the longitude
  # Output: None
  def get_following_locations(user_id)
    @following_locations = []
    listOfUsersLocations = ActiveRecord::Base.connection.execute("SELECT * from Userslocations where users_id = #{user_id}")
    listOfUsersLocations.each do |userLocations|
      @following_locations << Locations.find(userLocations["locations_id"])
    end
  nil
  end

  # Purpose: Show the information and all posts for a given location
  # Input:
  #   location_id - The id of the location for which to show the information and posts
  # Assign: assign the following variables
  #   @location - A hash of the given location. The hash should include:
  #     * :id - the location id
  #     * :name - the name of the location
  #     * :latitude - the latitude
  #     * :longitude - the longitude
  #   @posts - An array of hashes of post information, for the given location.
  #            Reverse chronological order by creation time (newest post first).
  #            Each hash should include:
  #     * :author_id - the id of the user who created this post
  #     * :author - the name of the user who created this post
  #     * :text - the contents of the post
  #     * :created_at - the time the post was created
  #     * :location - a hash of this post's location information. The hash should include:
  #         * :id - the location id
  #         * :name - the name of the location
  #         * :latitude - the latitude
  #         * :longitude - the longitude
  # Output: None
  def get_posts_for_location(location_id)
    @posts = []
    @location = Locations.find(location_id)
    Posts.where("locations_id = ?", location_id).order("created_at DESC").each do |singlePost|
      tempHash = {:author_id=>singlePost.users_id, :author=>User.find(singlePost.users_id).name, :text=>singlePost.content, :created_at=>singlePost.created_at}
      tempHash.update(:location => { :id=>@location[:id], :name=>@location[:name], :latitude=>@location[:latitude], :longitude=>@location[:longitude] } )
      @posts << tempHash
    end
  nil
  end

  # Purpose: Show the current user's stream of posts from all the locations the user follows
  # Input:
  #   user_id - the user id of the current user
  # Assign: assign the following variables
  #   @posts - An array of hashes of post information from all locations the current user follows.
  #            Reverse chronological order by creation time (newest post first).
  #            Each hash should include:
  #     * :author_id - the id of the user who created this post
  #     * :author - the name of the user who created this post
  #     * :text - the contents of the post
  #     * :created_at - the time the post was created
  #     * :location - a hash of this post's location information. The hash should include:
  #         * :id - the location id
  #         * :name - the name of the location
  #         * :latitude - the latitude
  #         * :longitude - the longitude
  # Output: None
  def get_stream_for_user(user_id)
    @posts = []
    Posts.where("users_id = ?", user_id).order("created_at DESC").each do |singlePost|
      tempLocation = Locations.find(singlePost.locations_id)
      tempHash = {:author_id=>singlePost.users_id, :author=>User.find(singlePost.users_id).name, :text=>singlePost.content, :created_at=>singlePost.created_at}
      tempHash.update(:location=> {:id=>tempLocation[:id], :name=>tempLocation[:name], :latitude=>tempLocation[:latitude], :longitude=>tempLocation[:longitude]})
      @posts << tempHash
    end
  nil
  end

  # Purpose: Retrieve the locations within a GPS bounding box
  # Input:
  #   nelat - latitude of the north-east corner of the bounding box
  #   nelng - longitude of the north-east corner of the bounding box
  #   swlat - latitude of the south-west corner of the bounding box
  #   swlng - longitude of the south-west corner of the bounding box
  #   user_id - the user id of the current user
  # Assign: assign the following variables
  #   @locations - An array of hashes of location information, which lie within the bounding box specified by the input.
  #                In increasing latitude order.
  #                At most 50 locations.
  #                Each hash should include:
  #     * :id - the location id
  #     * :name - the name of the location
  #     * :latitude - the latitude
  #     * :longitude - the longitude
  #     * :follows - true if the current user follows this location. false otherwise.
  # Output: None
  def get_nearby_locations(nelat, nelng, swlat, swlng, user_id)
  @locations = []
    listOfLocations = Locations.where("longitude >= ?", swlng).where("longitude <= ?", nelng).where("latitude >= ?", swlat).where("latitude <= ?", nelat).limit(50)
    listOfLocations.each do |location|
         userLocation = (ActiveRecord::Base.connection.execute("SELECT * from Userslocations where locations_id = #{location["id"]} AND users_id = #{user_id}"))
tempHash = {:id=>location[:id], :name=>location[:name], :latitude=>location[:latitude], :longitude=>location[:longitude]}
	        if userLocation.size >= 1
			tempHash.merge!( {:follows=>true} )
		else		
			tempHash.merge!( {:follows=>false} )
		end		
		@locations << tempHash
    end
    nil
  end

  # Purpose: Create a new location
  # Input:
  #   location_hash - A hash of the new location information.
  #                   The hash MAY include:
  #     * :name - the name of the location
  #     * :latitude - the latitude
  #     * :longitude - the longitude
  #     NOTE: Although the UI will always populate all these fields in this hash,
  #           we may use hashes with missing fields to test your schema/models.
  #           Your schema/models/code should prevent corruption of the database.
  # Assign: None
  # Output: true if the creation is successful, false otherwise
  def create_location(location_hash={})
    name = location_hash[:name]
    latitude = location_hash[:latitude]
    longitude = location_hash[:longitude]
    if name == nil or latitude == nil or longitude == nil
    	return false
    end
    @location = Locations.new(location_hash)
    @location.save
    return true
  end

  # Purpose: The current user follows a location
  # Input:
  #   user_id - the user id of the current user
  #   location_id - The id of the location the current user should follow
  # Assign: None
  # Output: None
  # NOTE: Although the UI will never call this method multiple times,
  #       we may call it multiple times to test your schema/models.
  #       Your schema/models/code should prevent corruption of the database.
  def follow_location(user_id, location_id)
    ActiveRecord::Base.connection.execute("INSERT into Userslocations (users_id, locations_id) VALUES(#{user_id}, #{location_id})")
  nil
  end

  # Purpose: The current user unfollows a location
  # Input:
  #   user_id - the user id of the current user
  #   location_id - The id of the location the current user should unfollow
  # Assign: None
  # Output: None
  # NOTE: Although the UI will never call this method multiple times,
  #       we may call it multiple times to test your schema/models.
  #       Your schema/models/code should prevent corruption of the database.
  def unfollow_location(user_id, location_id)
	ActiveRecord::Base.connection.execute("DELETE from Userslocations where users_id = #{user_id} AND locations_id = #{location_id}")
  nil
  end

  # Purpose: The current user creates a post to a given location
  # Input:
  #   user_id - the user id of the current user
  #   post_hash - A hash of the new post information.
  #               The hash may include:
  #     * :location_id - the id of the location
  #     * :text - the text of the posts
  #     NOTE: Although the UI will always populate all these fields in this hash,
  #           we may use hashes with missing fields to test your schema/models.
  #           Your schema/models/code should prevent corruption of the database.
  # Assign: None
  # Output: true if the creation is successful, false otherwise
  def create_post(user_id, post_hash={})
    if post_hash[:location_id] == nil or post_hash[:text] == nil
      return false
    end
      tempHash = {:users_id => user_id, :locations_id=>post_hash[:location_id], :content=>post_hash[:text]}
      @posts = Posts.new(tempHash)
      @posts.save
      return true
  end

  # Purpose: Create a new user
  # Input:
  #   user_hash - A hash of the new post information.
  #               The hash may include:
  #     * :name - name of the new user
  #     * :email - email of the new user
  #     * :password - password of the new user
  #     NOTE: Although the UI will always populate all these fields in this hash,
  #           we may use hashes with missing fields to test your schema/models.
  #           Your schema/models/code should prevent corruption of the database.
  # Assign: assign the following variables
  #   @user - the new user object
  # Output: true if the creation is successful, false otherwise
  # NOTE: This method is already implemented, but you are allowed to modify it if needed.
  def create_user(user_hash={})
    if user_hash[:name] == nil or user_hash[:email] == nil or user_hash[:password] == nil
	return false
    end
    begin
      @user = User.new(user_hash)
      @user.save
    rescue ActiveRecord::Rollback => e
      return false
    end
    return true
  end

  # Purpose: Get all the posts
  # Input: None
  # Assign: assign the following variables
  #   @posts - An array of hashes of post information.
  #            Order does not matter.
  #            Each hash should include:
  #     * :author_id - the id of the user who created this post
  #     * :author - the name of the user who created this post
  #     * :text - the contents of the post
  #     * :created_at - the time the post was created
  #     * :location - a hash of this post's location information. The hash should include:
  #         * :id - the location id
  #         * :name - the name of the location
  #         * :latitude - the latitude
  #         * :longitude - the longitude
  # Output: None
  def get_all_posts
    @posts = []
    ActiveRecord::Base.connection.execute("SELECT * from posts").each do |singlePost|
      tempLocation = Locations.find(singlePost["locations_id"])
      tempHash = {:author_id=>singlePost["users_id"], :author=>User.find(singlePost["users_id"]).name, :text=>singlePost["content"], :created_at=>singlePost["created_at"]}
      tempHash.merge!( {:location => {:id => tempLocation[:id], :latitude => tempLocation[:latitude], :longitude => tempLocation[:longitude], :name => tempLocation[:name]}} )
      @posts << tempHash
    end
  nil
  end

  # Purpose: Get all the users
  # Input: None
  # Assign: assign the following variables
  #   @users - An array of hashes of user information.
  #            Order does not matter.
  #            Each hash should include:
  #     * :id - id of the user
  #     * :name - name of the user
  #     * :email - email of th user
  # Output: None
  def get_all_users
    @users = []
    ActiveRecord::Base.connection.execute("SELECT * from Users").each do |singleUser|
      @users << singleUser
    end
  #nil
  end

  # Purpose: Get all the locations
  # Input: None
  # Assign: assign the following variables
  #   @locations - An array of hashes of location information.
  #                Order does not matter.
  #                Each hash should include:
  #     * :id - the location id
  #     * :name - the name of the location
  #     * :latitude - the latitude
  #     * :longitude - the longitude
  # Output: None
  def get_all_locations
    @locations = []
    ActiveRecord::Base.connection.execute("SELECT * from Locations").each do |singleLocation|
      @locations << singleLocation
    end
  nil
  end

  # Retrieve the top 5 users who created the most posts.
  # Retrieve at most 5 rows.
  # Returns a string of the SQL query.
  # The resulting columns names must include (but are not limited to):
  #   * name - name of the user
  #   * num_posts - number of posts the user has created
  def top_users_posts_sql
    "SELECT u.id, count(*) AS num_posts 
      FROM Users u, Posts p 
      WHERE u.id = p.users_id 
      GROUP BY u.id 
      ORDER BY num_posts DESC 
      LIMIT 5
    "
  end

  # Retrieve the top 5 locations with the most unique posters. Only retrieve locations with at least 2 unique posters.
  # Retrieve at most 5 rows.
  # Returns a string of the SQL query.
  # The resulting columns names must include (but are not limited to):
  #   * name - name of the location
  #   * num_users - number of unique users who have posted to the location
  def top_locations_unique_users_sql
      "SELECT num_users, name 
      FROM (SELECT COUNT(*) as num_users, name 
        FROM (SELECT DISTINCT name, users_id 
          FROM Posts P, Locations L WHERE P.locations_id=L.id GROUP BY name, users_id) 
        GROUP BY name ORDER BY num_users DESC) 
      WHERE num_users > 1"
  end

  # Retrieve the top 5 users who follow the most locations, where each location has at least 2 posts
  # Retrieve at most 5 rows.
  # Returns a string of the SQL query.
  # The resulting columns names must include (but are not limited to):
  #   * name - name of the user
  #   * num_locations - number of locations (has at least 2 posts) the user follows
  def top_users_locations_sql
    "SELECT name, COUNT(*) as num_locations FROM (SELECT DISTINCT locations_id, U.name FROM UsersLocations UL, Users U WHERE UL.users_id=U.id AND UL.locations_id IN(SELECT id FROM (SELECT L.id, COUNT(*) as loc_posts From Locations L, Posts P WHERE L.id = P.locations_id GROUP BY name) Where loc_posts > 1)) GROUP BY name" 
  end
end
