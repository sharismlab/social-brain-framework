module.exports = (mongoose) ->

    collection = "users"

    Schema = mongoose.Schema
    ObjectId = mongoose.SchemaTypes.ObjectId

    UserSchema = new Schema (
        seuron_id : 
          type: ObjectId
          index: true
          ref: 'SeuronSchema' 
        date: Date
        twit: Object
    )

    UserSchema.methods.createWithTwitter = ( twitUserMeta, accessToken, accessTokenSecret, callback ) ->

        twitterProfile =
            accessToken: accessToken
            accessTokenSecret: accessTokenSecret
            id: twitUserMeta.id
            name: twitUserMeta.name
            screenName: twitUserMeta.screen_name
            location: twitUserMeta.location
            description: twitUserMeta.description
            profileImageUrl: twitUserMeta.profile_image_url
            url: twitUserMeta.url
            protected: twitUserMeta.protected
            followersCount: twitUserMeta.followers_count
            profileBackgroundColor: twitUserMeta.profile_background_color
            profileTextColor: twitUserMeta.profile_text_color
            profileLinkColor: twitUserMeta.profile_link_color
            profileSidebarFillColor: twitUserMeta.profile_sidebar_fill_color
            profileSiderbarBorderColor: twitUserMeta.profile_sidebar_border_color
            friendsCount: twitUserMeta.friends_count
            createdAt: twitUserMeta.created_at
            favouritesCount: twitUserMeta.favourites_count
            utcOffset: twitUserMeta.utc_offset
            timeZone: twitUserMeta.time_zone
            profileBackgroundImageUrl: twitUserMeta.profile_background_image_url
            profileBackgroundTile: twitUserMeta.profile_background_tile
            profileUseBackgroundImage: twitUserMeta.profile_use_background_image
            geoEnabled: twitUserMeta.geo_enabled
            verified: twitUserMeta.verified
            statusesCount: twitUserMeta.statuses_count
            lang: twitUserMeta.lang
            contributorsEnabled: twitUserMeta.contributors_enabled

        # info to store inside new User
        # params ={}
        @twit = twitterProfile

        # console.log params
        @save callback

        this



    UserSchema